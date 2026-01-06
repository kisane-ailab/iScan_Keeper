// Edge Function: responses
// 설명: 대응 관리 API (claim, cancel, complete, memo)
// JWT 검증: true
// 배포일: 2025-01-06

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, POST, PATCH, DELETE, OPTIONS",
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

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const url = new URL(req.url);
    const pathParts = url.pathname.split("/").filter(Boolean);
    // pathParts: ["responses"] or ["responses", "claim"] or ["responses", ":id", "complete"] etc.

    const action = pathParts[1] || "";
    const subAction = pathParts[2] || "";

    // POST /responses/claim - 담당 선언
    if (req.method === "POST" && action === "claim") {
      const body = await req.json();
      const { eventLogId, userId, userName } = body;

      if (!eventLogId || !userId || !userName) {
        return errorResponse("Missing required fields: eventLogId, userId, userName");
      }

      // 트랜잭션: 이미 대응중인지 확인 후 담당 선언
      const { data: existingLog, error: checkError } = await supabase
        .from("event_logs")
        .select("response_status, current_responder_id")
        .eq("id", eventLogId)
        .single();

      if (checkError) {
        return errorResponse("Event log not found", 404);
      }

      if (existingLog.response_status === "in_progress") {
        return errorResponse("Already being responded by another user", 409);
      }

      if (existingLog.response_status === "completed") {
        return errorResponse("Already completed", 409);
      }

      // response_logs 생성
      const { data: responseLog, error: insertError } = await supabase
        .from("response_logs")
        .insert({
          event_log_id: eventLogId,
          user_id: userId,
        })
        .select()
        .single();

      if (insertError) {
        return errorResponse("Failed to create response log", 500, insertError.message);
      }

      // event_logs 상태 업데이트
      const { error: updateError } = await supabase
        .from("event_logs")
        .update({
          response_status: "in_progress",
          current_responder_id: userId,
          current_responder_name: userName,
          response_started_at: new Date().toISOString(),
        })
        .eq("id", eventLogId);

      if (updateError) {
        // 롤백: response_logs 삭제
        await supabase.from("response_logs").delete().eq("id", responseLog.id);
        return errorResponse("Failed to update event log", 500, updateError.message);
      }

      // users 상태 업데이트
      await supabase
        .from("users")
        .update({ status: "busy" })
        .eq("id", userId);

      return jsonResponse({ success: true, data: responseLog }, 201);
    }

    // DELETE /responses/:id/cancel - 담당 취소 (포기)
    if (req.method === "DELETE" && action && subAction === "cancel") {
      const responseId = action;

      // response_logs 조회
      const { data: responseLog, error: fetchError } = await supabase
        .from("response_logs")
        .select("event_log_id, user_id")
        .eq("id", responseId)
        .single();

      if (fetchError || !responseLog) {
        return errorResponse("Response log not found", 404);
      }

      // response_logs 삭제
      const { error: deleteError } = await supabase
        .from("response_logs")
        .delete()
        .eq("id", responseId);

      if (deleteError) {
        return errorResponse("Failed to delete response log", 500, deleteError.message);
      }

      // event_logs 상태 복원 (미확인으로)
      await supabase
        .from("event_logs")
        .update({
          response_status: "unchecked",
          current_responder_id: null,
          current_responder_name: null,
          response_started_at: null,
        })
        .eq("id", responseLog.event_log_id);

      // users 상태 복원
      await supabase
        .from("users")
        .update({ status: "available" })
        .eq("id", responseLog.user_id);

      return jsonResponse({ success: true });
    }

    // PATCH /responses/:id/complete - 대응 완료
    if (req.method === "PATCH" && action && subAction === "complete") {
      const responseId = action;
      const body = await req.json().catch(() => ({}));
      const { memo } = body;

      // response_logs 조회
      const { data: responseLog, error: fetchError } = await supabase
        .from("response_logs")
        .select("event_log_id, user_id")
        .eq("id", responseId)
        .single();

      if (fetchError || !responseLog) {
        return errorResponse("Response log not found", 404);
      }

      // response_logs 완료 처리
      const { error: updateError } = await supabase
        .from("response_logs")
        .update({
          completed_at: new Date().toISOString(),
          memo: memo || null,
        })
        .eq("id", responseId);

      if (updateError) {
        return errorResponse("Failed to complete response", 500, updateError.message);
      }

      // event_logs 상태 변경
      await supabase
        .from("event_logs")
        .update({
          response_status: "completed",
        })
        .eq("id", responseLog.event_log_id);

      // users 상태 복원
      await supabase
        .from("users")
        .update({ status: "available" })
        .eq("id", responseLog.user_id);

      return jsonResponse({ success: true });
    }

    // PATCH /responses/:id/memo - 메모 수정
    if (req.method === "PATCH" && action && subAction === "memo") {
      const responseId = action;
      const body = await req.json();
      const { memo } = body;

      const { error } = await supabase
        .from("response_logs")
        .update({ memo })
        .eq("id", responseId);

      if (error) {
        return errorResponse("Failed to update memo", 500, error.message);
      }

      return jsonResponse({ success: true });
    }

    // GET /responses/my?userId=xxx - 내 대응 기록
    if (req.method === "GET" && action === "my") {
      const userId = url.searchParams.get("userId");
      if (!userId) {
        return errorResponse("Missing userId parameter");
      }

      const { data, error } = await supabase
        .from("response_logs")
        .select(`
          *,
          event_log:event_logs(*)
        `)
        .eq("user_id", userId)
        .order("started_at", { ascending: false })
        .limit(50);

      if (error) {
        return errorResponse("Failed to fetch responses", 500, error.message);
      }

      return jsonResponse({ data });
    }

    // GET /responses/:id - 대응 상세
    if (req.method === "GET" && action && !subAction) {
      const { data, error } = await supabase
        .from("response_logs")
        .select(`
          *,
          event_log:event_logs(*),
          user:users(id, name, email)
        `)
        .eq("id", action)
        .single();

      if (error) {
        return errorResponse("Response not found", 404);
      }

      return jsonResponse({ data });
    }

    // GET /responses - 대응 기록 목록
    if (req.method === "GET" && !action) {
      const page = parseInt(url.searchParams.get("page") || "1");
      const limit = Math.min(parseInt(url.searchParams.get("limit") || "20"), 100);
      const status = url.searchParams.get("status"); // in_progress, completed, all
      const offset = (page - 1) * limit;

      let query = supabase
        .from("response_logs")
        .select(`
          *,
          event_log:event_logs(*),
          user:users(id, name, email)
        `, { count: "exact" });

      if (status === "in_progress") {
        query = query.is("completed_at", null);
      } else if (status === "completed") {
        query = query.not("completed_at", "is", null);
      }

      const { data, error, count } = await query
        .order("started_at", { ascending: false })
        .range(offset, offset + limit - 1);

      if (error) {
        return errorResponse("Failed to fetch responses", 500, error.message);
      }

      return jsonResponse({
        data,
        pagination: {
          page,
          limit,
          total: count || 0,
          totalPages: Math.ceil((count || 0) / limit),
        },
      });
    }

    return errorResponse("Not found", 404);
  } catch (err) {
    console.error("Unexpected error:", err);
    return errorResponse("Internal server error", 500, String(err));
  }
});
