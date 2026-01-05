import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

interface EventLogRequest {
  source: string;
  errorCode?: string;
  logLevel?: string;
  payload?: Record<string, unknown>;
  // 기존 machine 호환용 필드들 (payload로 자동 변환)
  [key: string]: unknown;
}

Deno.serve(async (req: Request) => {
  // CORS preflight
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  // POST만 허용
  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ error: "Method not allowed" }),
      { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }

  try {
    // Supabase 클라이언트 생성
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !supabaseServiceKey) {
      return new Response(
        JSON.stringify({
          error: "Server configuration error",
          details: { hasUrl: !!supabaseUrl, hasKey: !!supabaseServiceKey }
        }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // 요청 본문 파싱
    let body: EventLogRequest;
    try {
      body = await req.json();
    } catch (parseErr) {
      return new Response(
        JSON.stringify({ error: "Invalid JSON body", details: String(parseErr) }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // source 필수 체크
    if (!body.source) {
      return new Response(
        JSON.stringify({
          error: "Missing required field: source",
          received: body
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 예약 필드 추출
    const { source, errorCode, logLevel, payload: explicitPayload, ...restFields } = body;

    // payload 구성: 명시적 payload가 있으면 사용, 아니면 나머지 필드를 payload로
    const payload = explicitPayload || (Object.keys(restFields).length > 0 ? restFields : {});

    // event_logs 테이블에 삽입
    const { data, error } = await supabase
      .from("event_logs")
      .insert({
        source: source,
        error_code: errorCode || null,
        log_level: logLevel || "info",
        payload: payload,
        response_status: "unchecked"
      })
      .select()
      .single();

    if (error) {
      console.error("Database error:", error);
      return new Response(
        JSON.stringify({
          error: "Failed to save log",
          details: error.message,
          code: error.code,
          hint: error.hint
        }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 성공 응답
    return new Response(
      JSON.stringify({
        success: true,
        data: {
          id: data.id,
          source: data.source,
          error_code: data.error_code,
          log_level: data.log_level,
          response_status: data.response_status,
          created_at: data.created_at
        }
      }),
      { status: 201, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (err) {
    console.error("Unexpected error:", err);
    return new Response(
      JSON.stringify({
        error: "Internal server error",
        details: String(err),
        stack: err instanceof Error ? err.stack : undefined
      }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
