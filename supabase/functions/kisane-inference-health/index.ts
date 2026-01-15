// Edge Function: kisane-inference-health
// 설명: 별관 추론서버 SSH 포트 헬스체크
// JWT 검증: false (cron에서 호출)
// 배포일: 2026-01-15
// 스케줄: 30분마다 (cron: 0,30 * * * *)
// v3: 타임아웃 10초, 실패시 error 레벨로 통일

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const TARGET_HOST = "58.238.37.52";
const TARGET_PORT = 22222;
const TIMEOUT_MS = 10000; // 10초 타임아웃
const SOURCE_NAME = "Inference Server";
const SITE_NAME = "kisane-main";
const SERVER_DESC = "별관 추론서버 (Annex Inference Server)";

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const supabase = createClient(supabaseUrl, supabaseServiceKey);

  let isSuccess = false;
  let errorMessage = "";

  try {
    // TCP 연결 시도 (타임아웃 포함)
    const conn = await Promise.race([
      Deno.connect({ hostname: TARGET_HOST, port: TARGET_PORT }),
      new Promise<never>((_, reject) =>
        setTimeout(() => reject(new Error("Connection timeout (10s)")), TIMEOUT_MS)
      ),
    ]);

    // 연결 성공 시 바로 닫기
    (conn as Deno.Conn).close();
    isSuccess = true;
  } catch (err) {
    errorMessage = err.message || "Unknown connection error";
  }

  const targetDesc = `${TARGET_HOST}:${TARGET_PORT}`;
  const descWithEndpoint = `${SERVER_DESC} | ${targetDesc}`;

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
        payload: { target_host: TARGET_HOST, target_port: TARGET_PORT },
        response_status: "completed",
      });

    return new Response(
      JSON.stringify({ success: true, message: `${SOURCE_NAME} health check passed` }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } else {
    const failDesc = `${SERVER_DESC} | ${targetDesc} | ${errorMessage}`;

    await supabase
      .from("system_logs")
      .insert({
        source: SOURCE_NAME,
        site: SITE_NAME,
        description: failDesc,
        category: "health_check",
        code: "FAIL",
        log_level: "error",
        payload: { target_host: TARGET_HOST, target_port: TARGET_PORT, error: errorMessage },
        response_status: "unresponded",
      });

    return new Response(
      JSON.stringify({ success: false, error: errorMessage }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
