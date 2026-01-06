// Edge Function: kisane-datacenter-health
// 설명: 기산 데이터센터 헬스체크 (2시간 주기 cron)
// JWT 검증: false (cron에서 호출)
// 배포일: 2026-01-06

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const TARGET_URL = "http://58.238.37.52:19900/api/server-status";
const SOURCE_NAME = "Kisane DataCenter";
const SERVER_DESC = "성남 AI학습서버";

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const supabase = createClient(supabaseUrl, supabaseServiceKey);

  let isSuccess = false;
  let errorMessage = "";
  let responseData = null;

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 10000);

    const response = await fetch(TARGET_URL, {
      method: "GET",
      signal: controller.signal,
    });
    clearTimeout(timeoutId);

    if (response.ok) {
      const data = await response.json();
      responseData = data;

      if (data.status === "success") {
        isSuccess = true;
      } else {
        errorMessage = `Unexpected status: ${data.status}`;
      }
    } else {
      errorMessage = `HTTP Error: ${response.status} ${response.statusText}`;
    }
  } catch (err) {
    if (err.name === "AbortError") {
      errorMessage = "Request timeout (10s)";
    } else {
      errorMessage = `Connection error: ${err.message}`;
    }
  }

  const descWithEndpoint = `${SERVER_DESC} | ${TARGET_URL}`;

  if (isSuccess) {
    // 성공 시: 기존 health_check 레코드 업데이트 또는 새로 생성
    const { data: existing } = await supabase
      .from("system_logs")
      .select("id")
      .eq("source", SOURCE_NAME)
      .eq("category", "health_check")
      .single();

    if (existing) {
      await supabase
        .from("system_logs")
        .update({
          description: descWithEndpoint,
          log_level: "info",
          payload: responseData,
          response_status: "completed",
          created_at: new Date().toISOString(),
        })
        .eq("id", existing.id);
    } else {
      await supabase
        .from("system_logs")
        .insert({
          source: SOURCE_NAME,
          description: descWithEndpoint,
          category: "health_check",
          log_level: "info",
          payload: responseData,
          response_status: "completed",
        });
    }

    return new Response(
      JSON.stringify({ success: true, message: `${SOURCE_NAME} health check passed` }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } else {
    // 실패 시: 새 이벤트 로그 생성 (critical)
    const failDesc = `${SERVER_DESC} | ${TARGET_URL} | ${errorMessage}`;

    await supabase
      .from("system_logs")
      .insert({
        source: SOURCE_NAME,
        description: failDesc,
        category: "event",
        code: "HEALTH_CHECK_FAILED",
        log_level: "critical",
        payload: { target_url: TARGET_URL, error: errorMessage },
        response_status: "unresponded",
      });

    return new Response(
      JSON.stringify({ success: false, error: errorMessage }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
