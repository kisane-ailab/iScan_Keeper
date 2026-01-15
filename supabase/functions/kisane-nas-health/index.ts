// Edge Function: kisane-nas-health
// 설명: 성남 NAS 헬스체크
// JWT 검증: false (cron에서 호출)
// 배포일: 2026-01-15
// 스케줄: 30분마다 (cron: 0,30 * * * *)
// v2: 타임아웃 10초로 통일

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const TARGET_URL = "http://182.208.91.210:5000/";
const TIMEOUT_MS = 10000; // 10초 타임아웃
const SOURCE_NAME = "Kisane Nas";
const SITE_NAME = "kisane-seongnam";
const SERVER_DESC = "성남나스";

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const supabase = createClient(supabaseUrl, supabaseServiceKey);

  let isSuccess = false;
  let errorMessage = "";
  let statusCode = 0;

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), TIMEOUT_MS);

    const response = await fetch(TARGET_URL, {
      method: "GET",
      signal: controller.signal,
    });

    clearTimeout(timeoutId);
    statusCode = response.status;

    if (response.ok) {
      isSuccess = true;
    } else {
      errorMessage = `HTTP ${response.status} ${response.statusText}`;
    }
  } catch (err) {
    if (err.name === "AbortError") {
      errorMessage = "Connection timeout (10s)";
    } else {
      errorMessage = err.message || "Unknown connection error";
    }
  }

  const descWithEndpoint = `${SERVER_DESC} | ${TARGET_URL}`;

  if (isSuccess) {
    await supabase
      .from("system_logs")
      .insert({
        source: SOURCE_NAME,
        site: SITE_NAME,
        description: descWithEndpoint,
        category: "health_check",
        code: "OK",
        log_level: "info",
        payload: { target_url: TARGET_URL, status_code: statusCode },
        response_status: "completed",
      });

    return new Response(
      JSON.stringify({ success: true, message: `${SOURCE_NAME} health check passed` }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } else {
    const failDesc = `${SERVER_DESC} | ${TARGET_URL} | ${errorMessage}`;

    await supabase
      .from("system_logs")
      .insert({
        source: SOURCE_NAME,
        site: SITE_NAME,
        description: failDesc,
        category: "health_check",
        code: "FAIL",
        log_level: "error",
        payload: { target_url: TARGET_URL, status_code: statusCode, error: errorMessage },
        response_status: "unresponded",
      });

    return new Response(
      JSON.stringify({ success: false, error: errorMessage }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
