// Edge Function: n8n-automation-health
// 설명: n8n Automation 서버 헬스체크
// JWT 검증: false (cron에서 호출)
// 배포일: 2026-01-15
// 스케줄: 30분마다 (cron: 0,30 * * * *)
//          KST 00:00, 00:30, 01:00, 01:30, ... 매시 0분, 30분
// v3: site를 kisane-main으로 변경

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const TARGET_URL = "http://58.238.37.52:60501";
const SOURCE_NAME = "n8n Automation";
const SITE_NAME = "kisane-main";
const SERVER_DESC = "n8n Workflow Automation Server";

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const supabase = createClient(supabaseUrl, supabaseServiceKey);

  let isSuccess = false;
  let errorMessage = "";
  let responseStatus = 0;

  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 10000);

    const response = await fetch(TARGET_URL, {
      method: "GET",
      signal: controller.signal,
    });
    clearTimeout(timeoutId);
    responseStatus = response.status;

    if (response.ok) {
      isSuccess = true;
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
    await supabase
      .from("system_logs")
      .insert({
        source: SOURCE_NAME,
        site: SITE_NAME,
        description: descWithEndpoint,
        category: "health_check",
        code: "OK",
        log_level: "info",
        payload: { target_url: TARGET_URL, status_code: responseStatus },
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
        payload: { target_url: TARGET_URL, error: errorMessage },
        response_status: "unresponded",
      });

    return new Response(
      JSON.stringify({ success: false, error: errorMessage }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
