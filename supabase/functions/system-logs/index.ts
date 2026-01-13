// Edge Function: system-logs
// 설명: 시스템 로그 생성 및 관리 API
// JWT 검증: false (공개 API)
// 배포일: 2025-01-06
// 업데이트: 2026-01-13 (mute/unmute 기능 추가)

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, PATCH, OPTIONS",
};

function jsonResponse(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function errorResponse(error: string, status = 400, details?: unknown) {
  return jsonResponse({ error, details }, status);
}

interface SystemLogRequest {
  source: string;
  description?: string;
  category: 'event' | 'health_check';
  code: string;
  logLevel: 'info' | 'warning' | 'error' | 'critical';
  environment: 'development' | 'production';
  payload?: string;
  attachments?: string;
  [key: string]: unknown;
}

Deno.serve(async (req: Request) => {
  // CORS preflight
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !supabaseServiceKey) {
      return errorResponse("Server configuration error", 500, {
        hasUrl: !!supabaseUrl,
        hasKey: !!supabaseServiceKey
      });
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const url = new URL(req.url);
    const pathParts = url.pathname.split("/").filter(Boolean);
    // pathParts: ["system-logs"] or ["system-logs", ":id", "mute"]

    const logId = pathParts[1] || "";
    const action = pathParts[2] || "";

    // PATCH /system-logs/:id/mute - 알림 무시 토글
    if (req.method === "PATCH" && logId && action === "mute") {
      const body = await req.json().catch(() => ({}));
      const { muted } = body as { muted?: boolean };

      if (typeof muted !== "boolean") {
        return errorResponse("Missing or invalid 'muted' field. Must be boolean.");
      }

      const { data, error } = await supabase
        .from("system_logs")
        .update({ is_muted: muted ? true : null })
        .eq("id", logId)
        .select("id, source, code, is_muted")
        .single();

      if (error) {
        if (error.code === "PGRST116") {
          return errorResponse("System log not found", 404);
        }
        return errorResponse("Failed to update mute status", 500, error.message);
      }

      return jsonResponse({
        success: true,
        data: {
          id: data.id,
          source: data.source,
          code: data.code,
          is_muted: data.is_muted ?? false
        }
      });
    }

    // POST /system-logs - 로그 생성
    if (req.method === "POST" && !logId) {
      let body: SystemLogRequest;
      try {
        body = await req.json();
      } catch (parseErr) {
        return errorResponse("Invalid JSON body", 400, String(parseErr));
      }

      // 필수 필드 검증
      const missingFields: string[] = [];
      if (!body.source) missingFields.push('source');
      if (!body.category) missingFields.push('category');
      if (!body.code) missingFields.push('code');
      if (!body.logLevel) missingFields.push('logLevel');
      if (!body.environment) missingFields.push('environment');

      if (missingFields.length > 0) {
        return errorResponse(`Missing required fields: ${missingFields.join(', ')}`, 400, { received: body });
      }

      // category 유효성 검증
      if (!['event', 'health_check'].includes(body.category)) {
        return errorResponse("Invalid category. Must be 'event' or 'health_check'", 400, { received: body.category });
      }

      // logLevel 유효성 검증
      if (!['info', 'warning', 'error', 'critical'].includes(body.logLevel)) {
        return errorResponse("Invalid logLevel. Must be 'info', 'warning', 'error', or 'critical'", 400, { received: body.logLevel });
      }

      // environment 유효성 검증
      if (!['development', 'production'].includes(body.environment)) {
        return errorResponse("Invalid environment. Must be 'development' or 'production'", 400, { received: body.environment });
      }

      const { source, description, category, code, logLevel, environment, payload, attachments } = body;

      // payload와 attachments는 JSON string으로 받아서 파싱
      let parsedPayload = null;
      let parsedAttachments = null;

      if (payload) {
        try {
          parsedPayload = typeof payload === 'string' ? JSON.parse(payload) : payload;
        } catch {
          return errorResponse("Invalid payload JSON string", 400, { received: payload });
        }
      }

      if (attachments) {
        try {
          parsedAttachments = typeof attachments === 'string' ? JSON.parse(attachments) : attachments;
        } catch {
          return errorResponse("Invalid attachments JSON string", 400, { received: attachments });
        }
      }

      const { data, error } = await supabase
        .from("system_logs")
        .insert({
          source,
          description: description || null,
          category,
          code,
          log_level: logLevel,
          environment,
          payload: parsedPayload,
          attachments: parsedAttachments,
          response_status: "unresponded"
        })
        .select()
        .single();

      if (error) {
        console.error("Database error:", error);
        return errorResponse("Failed to save log", 500, {
          message: error.message,
          code: error.code,
          hint: error.hint
        });
      }

      return jsonResponse({
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
      }, 201);
    }

    return errorResponse("Not found", 404);
  } catch (err) {
    console.error("Unexpected error:", err);
    return errorResponse("Internal server error", 500, {
      message: String(err),
      stack: err instanceof Error ? err.stack : undefined
    });
  }
});
