// Edge Function: stats
// 설명: 통계 API (사용자별, 일별, 전체 개요)
// JWT 검증: true
// 배포일: 2025-01-06

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
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

function formatDuration(ms: number): string {
  const seconds = Math.floor(ms / 1000);
  const minutes = Math.floor(seconds / 60);
  const hours = Math.floor(minutes / 60);

  if (hours > 0) {
    return `${hours}h ${minutes % 60}m`;
  } else if (minutes > 0) {
    return `${minutes}m ${seconds % 60}s`;
  }
  return `${seconds}s`;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  if (req.method !== "GET") {
    return errorResponse("Method not allowed", 405);
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const url = new URL(req.url);
    const pathParts = url.pathname.split("/").filter(Boolean);
    // pathParts: ["stats", "user", ":userId"] or ["stats", "daily"] or ["stats", "by-user", ":userId"] or ["stats", "by-date"]

    const action = pathParts[1] || "";
    const subAction = pathParts[2] || "";

    // 기본 날짜 범위 (7일 전 ~ 오늘)
    const defaultFrom = new Date();
    defaultFrom.setDate(defaultFrom.getDate() - 7);
    const fromParam = url.searchParams.get("from") || defaultFrom.toISOString().split("T")[0];
    const toParam = url.searchParams.get("to") || new Date().toISOString().split("T")[0];

    // GET /stats/user/:userId - 사용자별 통계
    if (action === "user" && subAction) {
      const userId = subAction;

      // 사용자 정보 조회
      const { data: user, error: userError } = await supabase
        .from("users")
        .select("id, name")
        .eq("id", userId)
        .single();

      if (userError) {
        return errorResponse("User not found", 404);
      }

      // 대응 기록 조회
      const { data: responses, error: respError } = await supabase
        .from("response_logs")
        .select("started_at, completed_at")
        .eq("user_id", userId)
        .gte("started_at", `${fromParam}T00:00:00Z`)
        .lte("started_at", `${toParam}T23:59:59Z`);

      if (respError) {
        return errorResponse("Failed to fetch stats", 500, respError.message);
      }

      const totalResponses = responses?.length || 0;
      const completed = responses?.filter((r) => r.completed_at !== null).length || 0;
      const inProgress = totalResponses - completed;

      // 평균 대응 시간 계산
      let avgResponseTimeMs = 0;
      const completedWithTime = responses?.filter((r) => r.completed_at) || [];
      if (completedWithTime.length > 0) {
        const totalMs = completedWithTime.reduce((sum, r) => {
          const start = new Date(r.started_at).getTime();
          const end = new Date(r.completed_at!).getTime();
          return sum + (end - start);
        }, 0);
        avgResponseTimeMs = totalMs / completedWithTime.length;
      }

      return jsonResponse({
        userId: user.id,
        userName: user.name,
        period: { from: fromParam, to: toParam },
        stats: {
          totalResponses,
          completed,
          inProgress,
          avgResponseTime: formatDuration(avgResponseTimeMs),
        },
      });
    }

    // GET /stats/daily - 일별 통계
    if (action === "daily") {
      const { data: responses, error } = await supabase
        .from("response_logs")
        .select("started_at, completed_at")
        .gte("started_at", `${fromParam}T00:00:00Z`)
        .lte("started_at", `${toParam}T23:59:59Z`);

      if (error) {
        return errorResponse("Failed to fetch stats", 500, error.message);
      }

      // 날짜별 그룹화
      const dailyMap = new Map<string, { total: number; completed: number }>();

      responses?.forEach((r) => {
        const date = r.started_at.split("T")[0];
        const existing = dailyMap.get(date) || { total: 0, completed: 0 };
        existing.total++;
        if (r.completed_at) {
          existing.completed++;
        }
        dailyMap.set(date, existing);
      });

      // 날짜 범위 내 모든 날짜 생성 (0인 날짜도 포함)
      const daily: Array<{ date: string; total: number; completed: number }> = [];
      const currentDate = new Date(fromParam);
      const endDate = new Date(toParam);

      while (currentDate <= endDate) {
        const dateStr = currentDate.toISOString().split("T")[0];
        const stats = dailyMap.get(dateStr) || { total: 0, completed: 0 };
        daily.push({ date: dateStr, ...stats });
        currentDate.setDate(currentDate.getDate() + 1);
      }

      return jsonResponse({
        period: { from: fromParam, to: toParam },
        daily,
      });
    }

    // GET /stats/by-user/:userId - 사용자별 대응 목록 (페이지네이션)
    if (action === "by-user" && subAction) {
      const userId = subAction;
      const page = parseInt(url.searchParams.get("page") || "1");
      const limit = Math.min(parseInt(url.searchParams.get("limit") || "20"), 100);
      const status = url.searchParams.get("status"); // in_progress, completed, all
      const offset = (page - 1) * limit;

      let query = supabase
        .from("response_logs")
        .select(`
          *,
          system_log:system_logs(*)
        `, { count: "exact" })
        .eq("user_id", userId);

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

    // GET /stats/by-date - 날짜별 대응 목록 (페이지네이션)
    if (action === "by-date") {
      const page = parseInt(url.searchParams.get("page") || "1");
      const limit = Math.min(parseInt(url.searchParams.get("limit") || "20"), 100);
      const status = url.searchParams.get("status");
      const userId = url.searchParams.get("userId");
      const offset = (page - 1) * limit;

      let query = supabase
        .from("response_logs")
        .select(`
          *,
          system_log:system_logs(*),
          user:users(id, name, email)
        `, { count: "exact" })
        .gte("started_at", `${fromParam}T00:00:00Z`)
        .lte("started_at", `${toParam}T23:59:59Z`);

      if (status === "in_progress") {
        query = query.is("completed_at", null);
      } else if (status === "completed") {
        query = query.not("completed_at", "is", null);
      }

      if (userId) {
        query = query.eq("user_id", userId);
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

    // GET /stats/overview - 전체 개요 통계
    if (action === "overview") {
      // 전체 이벤트 로그 통계
      const { count: totalEvents } = await supabase
        .from("system_logs")
        .select("*", { count: "exact", head: true });

      const { count: uncheckedEvents } = await supabase
        .from("system_logs")
        .select("*", { count: "exact", head: true })
        .eq("response_status", "unresponded");

      const { count: inProgressEvents } = await supabase
        .from("system_logs")
        .select("*", { count: "exact", head: true })
        .eq("response_status", "in_progress");

      const { count: completedEvents } = await supabase
        .from("system_logs")
        .select("*", { count: "exact", head: true })
        .eq("response_status", "completed");

      // 사용자 통계
      const { count: totalUsers } = await supabase
        .from("users")
        .select("*", { count: "exact", head: true });

      const { count: availableUsers } = await supabase
        .from("users")
        .select("*", { count: "exact", head: true })
        .eq("status", "available");

      const { count: busyUsers } = await supabase
        .from("users")
        .select("*", { count: "exact", head: true })
        .eq("status", "busy");

      return jsonResponse({
        events: {
          total: totalEvents || 0,
          unchecked: uncheckedEvents || 0,
          inProgress: inProgressEvents || 0,
          completed: completedEvents || 0,
        },
        users: {
          total: totalUsers || 0,
          available: availableUsers || 0,
          busy: busyUsers || 0,
        },
      });
    }

    return errorResponse("Not found", 404);
  } catch (err) {
    console.error("Unexpected error:", err);
    return errorResponse("Internal server error", 500, String(err));
  }
});
