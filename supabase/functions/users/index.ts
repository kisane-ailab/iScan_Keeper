// Edge Function: users
// 설명: 사용자 관리 API (CRUD, 상태 변경)
// JWT 검증: true
// 배포일: 2025-01-06

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, POST, PATCH, OPTIONS",
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
    // pathParts: ["users"] or ["users", "available"] or ["users", ":id"] or ["users", ":id", "status"]

    const action = pathParts[1] || "";
    const subAction = pathParts[2] || "";

    // GET /users/available - 대기중인 담당자 목록
    if (req.method === "GET" && action === "available") {
      const { data, error } = await supabase
        .from("users")
        .select("*")
        .eq("status", "available")
        .order("name");

      if (error) {
        return errorResponse("Failed to fetch available users", 500, error.message);
      }

      return jsonResponse({ data });
    }

    // GET /users/me - 현재 로그인한 사용자 정보 (Auth 토큰 기반)
    if (req.method === "GET" && action === "me") {
      const authHeader = req.headers.get("Authorization");
      if (!authHeader) {
        return errorResponse("Missing authorization header", 401);
      }

      const token = authHeader.replace("Bearer ", "");
      const { data: { user }, error: authError } = await supabase.auth.getUser(token);

      if (authError || !user) {
        return errorResponse("Invalid token", 401);
      }

      const { data, error } = await supabase
        .from("users")
        .select("*")
        .eq("id", user.id)
        .single();

      if (error) {
        return errorResponse("User not found", 404);
      }

      return jsonResponse({ data });
    }

    // PATCH /users/:id/status - 상태 수동 변경
    if (req.method === "PATCH" && action && subAction === "status") {
      const userId = action;
      const body = await req.json();
      const { status } = body;

      if (!status || !["available", "busy", "offline"].includes(status)) {
        return errorResponse("Invalid status. Must be: available, busy, offline");
      }

      const { data, error } = await supabase
        .from("users")
        .update({ status })
        .eq("id", userId)
        .select()
        .single();

      if (error) {
        return errorResponse("Failed to update status", 500, error.message);
      }

      return jsonResponse({ data });
    }

    // GET /users/:id - 담당자 상세 조회
    if (req.method === "GET" && action && !subAction) {
      const { data, error } = await supabase
        .from("users")
        .select("*")
        .eq("id", action)
        .single();

      if (error) {
        return errorResponse("User not found", 404);
      }

      return jsonResponse({ data });
    }

    // POST /users - 사용자 생성 (회원가입 시 호출)
    if (req.method === "POST" && !action) {
      const body = await req.json();
      const { id, name, email } = body;

      if (!id || !name || !email) {
        return errorResponse("Missing required fields: id, name, email");
      }

      const { data, error } = await supabase
        .from("users")
        .insert({
          id,
          name,
          email,
          status: "offline",
        })
        .select()
        .single();

      if (error) {
        if (error.code === "23505") {
          return errorResponse("User already exists", 409);
        }
        return errorResponse("Failed to create user", 500, error.message);
      }

      return jsonResponse({ data }, 201);
    }

    // GET /users - 담당자 목록 조회
    if (req.method === "GET" && !action) {
      const status = url.searchParams.get("status");

      let query = supabase
        .from("users")
        .select("*")
        .order("name");

      if (status && ["available", "busy", "offline"].includes(status)) {
        query = query.eq("status", status);
      }

      const { data, error } = await query;

      if (error) {
        return errorResponse("Failed to fetch users", 500, error.message);
      }

      return jsonResponse({ data });
    }

    return errorResponse("Not found", 404);
  } catch (err) {
    console.error("Unexpected error:", err);
    return errorResponse("Internal server error", 500, String(err));
  }
});
