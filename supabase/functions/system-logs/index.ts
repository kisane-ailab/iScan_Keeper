// Edge Function: system-logs
// 설명: 시스템 로그 생성 API (외부 기기에서 호출)
// JWT 검증: false (공개 API)
// 배포일: 2025-01-06
// 업데이트: 2026-01-06 (event_type → category, error_code → code)

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

interface SystemLogRequest {
  source: string;
  description?: string;
  category?: 'event' | 'health_check';
  code?: string;
  logLevel?: 'info' | 'warning' | 'error' | 'critical';
  payload?: Record<string, unknown>;
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

    let body: SystemLogRequest;
    try {
      body = await req.json();
    } catch (parseErr) {
      return new Response(
        JSON.stringify({ error: "Invalid JSON body", details: String(parseErr) }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (!body.source) {
      return new Response(
        JSON.stringify({
          error: "Missing required field: source",
          received: body
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const { source, description, category, code, logLevel, payload: explicitPayload, ...restFields } = body;
    const payload = explicitPayload || (Object.keys(restFields).length > 0 ? restFields : {});

    const { data, error } = await supabase
      .from("system_logs")
      .insert({
        source: source,
        description: description || null,
        category: category || "event",
        code: code || null,
        log_level: logLevel || "info",
        payload: payload,
        response_status: "unresponded"
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

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          id: data.id,
          source: data.source,
          description: data.description,
          category: data.category,
          code: data.code,
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
