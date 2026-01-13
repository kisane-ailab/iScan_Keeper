// Edge Function: system-logs
// 설명: 시스템 로그 생성 API (외부 기기에서 호출)
// JWT 검증: false (공개 API)
// 배포일: 2025-01-06
// 업데이트: 2026-01-08 (environment 필수 필드 추가)

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
  category: 'event' | 'health_check';  // 필수
  code: string;  // 필수
  logLevel: 'info' | 'warning' | 'error' | 'critical';  // 필수
  environment: 'development' | 'production';  // 필수
  payload?: string;  // JSON string (선택)
  attachments?: string;  // JSON string (선택)
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

    // 필수 필드 검증
    const missingFields: string[] = [];
    if (!body.source) missingFields.push('source');
    if (!body.category) missingFields.push('category');
    if (!body.code) missingFields.push('code');
    if (!body.logLevel) missingFields.push('logLevel');
    if (!body.environment) missingFields.push('environment');

    if (missingFields.length > 0) {
      return new Response(
        JSON.stringify({
          error: `Missing required fields: ${missingFields.join(', ')}`,
          received: body
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // category 유효성 검증
    if (!['event', 'health_check'].includes(body.category)) {
      return new Response(
        JSON.stringify({
          error: "Invalid category. Must be 'event' or 'health_check'",
          received: body.category
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // logLevel 유효성 검증
    if (!['info', 'warning', 'error', 'critical'].includes(body.logLevel)) {
      return new Response(
        JSON.stringify({
          error: "Invalid logLevel. Must be 'info', 'warning', 'error', or 'critical'",
          received: body.logLevel
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // environment 유효성 검증
    if (!['development', 'production'].includes(body.environment)) {
      return new Response(
        JSON.stringify({
          error: "Invalid environment. Must be 'development' or 'production'",
          received: body.environment
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const { source, description, category, code, logLevel, environment, payload, attachments } = body;

    // payload와 attachments는 JSON string으로 받아서 파싱
    let parsedPayload = null;
    let parsedAttachments = null;

    if (payload) {
      try {
        parsedPayload = typeof payload === 'string' ? JSON.parse(payload) : payload;
      } catch {
        return new Response(
          JSON.stringify({ error: "Invalid payload JSON string", received: payload }),
          { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
    }

    if (attachments) {
      try {
        parsedAttachments = typeof attachments === 'string' ? JSON.parse(attachments) : attachments;
      } catch {
        return new Response(
          JSON.stringify({ error: "Invalid attachments JSON string", received: attachments }),
          { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
    }

    const { data, error } = await supabase
      .from("system_logs")
      .insert({
        source: source,
        description: description || null,
        category: category,
        code: code,
        log_level: logLevel,
        environment: environment,
        payload: parsedPayload,
        attachments: parsedAttachments,
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
          environment: data.environment,
          attachments: data.attachments,
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
