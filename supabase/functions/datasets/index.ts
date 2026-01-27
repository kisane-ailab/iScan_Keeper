// Edge Function: datasets
// 설명: 데이터셋 워크플로우 관리 API
// JWT 검증: true (인증 필요)
// 배포일: 2026-01-27

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
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

// 데이터셋 상태 타입
type DatasetState =
  | "s2_registered"
  | "s3_in_review"
  | "s4_review_done"
  | "s5_admin_decision"
  | "s6_published";

type AdminDecision = "pending" | "approved" | "rejected";

interface CreateDatasetRequest {
  name: string;
  description?: string;
  source_path: string;
  metadata?: Record<string, unknown>;
  environment?: "development" | "production";
  organization_id?: string;
}

interface StartReviewRequest {
  reviewer_id: string;
  reviewer_name: string;
}

interface SubmitReviewRequest {
  review_note?: string;
}

interface ApproveRequest {
  approver_id: string;
  approver_name: string;
}

interface RejectRequest {
  approver_id: string;
  approver_name: string;
  rejection_reason: string;
}

interface PublishRequest {
  published_path: string;
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
        hasKey: !!supabaseServiceKey,
      });
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const url = new URL(req.url);
    const pathParts = url.pathname.split("/").filter(Boolean);
    // pathParts: ["datasets"] or ["datasets", ":id"] or ["datasets", ":id", "action"]

    const datasetId = pathParts[1] || "";
    const action = pathParts[2] || "";

    // =========================================
    // GET /datasets - 데이터셋 목록 조회
    // =========================================
    if (req.method === "GET" && !datasetId) {
      const state = url.searchParams.get("state");
      const adminDecision = url.searchParams.get("admin_decision");
      const reviewerId = url.searchParams.get("reviewer_id");
      const environment = url.searchParams.get("environment");
      const limit = parseInt(url.searchParams.get("limit") || "50");
      const offset = parseInt(url.searchParams.get("offset") || "0");

      let query = supabase.from("datasets").select("*", { count: "exact" });

      if (state) {
        query = query.eq("state", state);
      }
      if (adminDecision) {
        query = query.eq("admin_decision", adminDecision);
      }
      if (reviewerId) {
        query = query.eq("reviewer_id", reviewerId);
      }
      if (environment) {
        query = query.eq("environment", environment);
      }

      const { data, error, count } = await query
        .order("created_at", { ascending: false })
        .range(offset, offset + limit - 1);

      if (error) {
        return errorResponse("Failed to fetch datasets", 500, error.message);
      }

      return jsonResponse({
        success: true,
        data,
        total: count,
        limit,
        offset,
      });
    }

    // =========================================
    // GET /datasets/:id - 단일 데이터셋 조회
    // =========================================
    if (req.method === "GET" && datasetId && !action) {
      const { data, error } = await supabase
        .from("datasets")
        .select("*")
        .eq("id", datasetId)
        .single();

      if (error) {
        if (error.code === "PGRST116") {
          return errorResponse("Dataset not found", 404);
        }
        return errorResponse("Failed to fetch dataset", 500, error.message);
      }

      return jsonResponse({ success: true, data });
    }

    // =========================================
    // POST /datasets - 데이터셋 등록 (S2)
    // =========================================
    if (req.method === "POST" && !datasetId) {
      let body: CreateDatasetRequest;
      try {
        body = await req.json();
      } catch {
        return errorResponse("Invalid JSON body", 400);
      }

      const missingFields: string[] = [];
      if (!body.name) missingFields.push("name");
      if (!body.source_path) missingFields.push("source_path");

      if (missingFields.length > 0) {
        return errorResponse(
          `Missing required fields: ${missingFields.join(", ")}`,
          400,
          { received: body }
        );
      }

      const { data, error } = await supabase
        .from("datasets")
        .insert({
          name: body.name,
          description: body.description || null,
          source_path: body.source_path,
          metadata: body.metadata || {},
          environment: body.environment || "production",
          organization_id: body.organization_id || null,
          state: "s2_registered",
          admin_decision: "pending",
        })
        .select()
        .single();

      if (error) {
        console.error("Database error:", error);
        return errorResponse("Failed to create dataset", 500, {
          message: error.message,
          code: error.code,
        });
      }

      return jsonResponse({ success: true, data }, 201);
    }

    // =========================================
    // POST /datasets/:id/start-review - 리뷰 시작 (S2 → S3)
    // =========================================
    if (req.method === "POST" && datasetId && action === "start-review") {
      let body: StartReviewRequest;
      try {
        body = await req.json();
      } catch {
        return errorResponse("Invalid JSON body", 400);
      }

      if (!body.reviewer_id || !body.reviewer_name) {
        return errorResponse("Missing reviewer_id or reviewer_name", 400);
      }

      // 현재 상태 확인
      const { data: current, error: fetchError } = await supabase
        .from("datasets")
        .select("state")
        .eq("id", datasetId)
        .single();

      if (fetchError) {
        if (fetchError.code === "PGRST116") {
          return errorResponse("Dataset not found", 404);
        }
        return errorResponse("Failed to fetch dataset", 500, fetchError.message);
      }

      if (current.state !== "s2_registered") {
        return errorResponse(
          `Cannot start review from state ${current.state}. Must be s2_registered.`,
          400
        );
      }

      const { data, error } = await supabase
        .from("datasets")
        .update({
          state: "s3_in_review" as DatasetState,
          reviewer_id: body.reviewer_id,
          reviewer_name: body.reviewer_name,
          review_started_at: new Date().toISOString(),
        })
        .eq("id", datasetId)
        .select()
        .single();

      if (error) {
        return errorResponse("Failed to start review", 500, error.message);
      }

      return jsonResponse({ success: true, data });
    }

    // =========================================
    // POST /datasets/:id/complete-review - 리뷰 완료 (S3 → S4)
    // =========================================
    if (req.method === "POST" && datasetId && action === "complete-review") {
      let body: SubmitReviewRequest = {};
      try {
        body = await req.json();
      } catch {
        // body는 선택적
      }

      const { data: current, error: fetchError } = await supabase
        .from("datasets")
        .select("state")
        .eq("id", datasetId)
        .single();

      if (fetchError) {
        if (fetchError.code === "PGRST116") {
          return errorResponse("Dataset not found", 404);
        }
        return errorResponse("Failed to fetch dataset", 500, fetchError.message);
      }

      if (current.state !== "s3_in_review") {
        return errorResponse(
          `Cannot complete review from state ${current.state}. Must be s3_in_review.`,
          400
        );
      }

      const { data, error } = await supabase
        .from("datasets")
        .update({
          state: "s4_review_done" as DatasetState,
          review_completed_at: new Date().toISOString(),
          review_note: body.review_note || null,
        })
        .eq("id", datasetId)
        .select()
        .single();

      if (error) {
        return errorResponse("Failed to complete review", 500, error.message);
      }

      return jsonResponse({ success: true, data });
    }

    // =========================================
    // POST /datasets/:id/submit-review - 리뷰 제출 (S4 → S5)
    // =========================================
    if (req.method === "POST" && datasetId && action === "submit-review") {
      const { data: current, error: fetchError } = await supabase
        .from("datasets")
        .select("state")
        .eq("id", datasetId)
        .single();

      if (fetchError) {
        if (fetchError.code === "PGRST116") {
          return errorResponse("Dataset not found", 404);
        }
        return errorResponse("Failed to fetch dataset", 500, fetchError.message);
      }

      if (current.state !== "s4_review_done") {
        return errorResponse(
          `Cannot submit review from state ${current.state}. Must be s4_review_done.`,
          400
        );
      }

      const { data, error } = await supabase
        .from("datasets")
        .update({
          state: "s5_admin_decision" as DatasetState,
        })
        .eq("id", datasetId)
        .select()
        .single();

      if (error) {
        return errorResponse("Failed to submit review", 500, error.message);
      }

      return jsonResponse({ success: true, data });
    }

    // =========================================
    // POST /datasets/:id/approve - 승인 (S5에서 승인)
    // =========================================
    if (req.method === "POST" && datasetId && action === "approve") {
      let body: ApproveRequest;
      try {
        body = await req.json();
      } catch {
        return errorResponse("Invalid JSON body", 400);
      }

      if (!body.approver_id || !body.approver_name) {
        return errorResponse("Missing approver_id or approver_name", 400);
      }

      const { data: current, error: fetchError } = await supabase
        .from("datasets")
        .select("state")
        .eq("id", datasetId)
        .single();

      if (fetchError) {
        if (fetchError.code === "PGRST116") {
          return errorResponse("Dataset not found", 404);
        }
        return errorResponse("Failed to fetch dataset", 500, fetchError.message);
      }

      if (current.state !== "s5_admin_decision") {
        return errorResponse(
          `Cannot approve from state ${current.state}. Must be s5_admin_decision.`,
          400
        );
      }

      const { data, error } = await supabase
        .from("datasets")
        .update({
          admin_decision: "approved" as AdminDecision,
          approver_id: body.approver_id,
          approver_name: body.approver_name,
          approved_at: new Date().toISOString(),
        })
        .eq("id", datasetId)
        .select()
        .single();

      if (error) {
        return errorResponse("Failed to approve dataset", 500, error.message);
      }

      return jsonResponse({ success: true, data });
    }

    // =========================================
    // POST /datasets/:id/reject - 반려 (S5 → S3)
    // =========================================
    if (req.method === "POST" && datasetId && action === "reject") {
      let body: RejectRequest;
      try {
        body = await req.json();
      } catch {
        return errorResponse("Invalid JSON body", 400);
      }

      if (!body.approver_id || !body.approver_name || !body.rejection_reason) {
        return errorResponse(
          "Missing approver_id, approver_name, or rejection_reason",
          400
        );
      }

      const { data: current, error: fetchError } = await supabase
        .from("datasets")
        .select("state")
        .eq("id", datasetId)
        .single();

      if (fetchError) {
        if (fetchError.code === "PGRST116") {
          return errorResponse("Dataset not found", 404);
        }
        return errorResponse("Failed to fetch dataset", 500, fetchError.message);
      }

      if (current.state !== "s5_admin_decision") {
        return errorResponse(
          `Cannot reject from state ${current.state}. Must be s5_admin_decision.`,
          400
        );
      }

      const { data, error } = await supabase
        .from("datasets")
        .update({
          state: "s3_in_review" as DatasetState,
          admin_decision: "rejected" as AdminDecision,
          approver_id: body.approver_id,
          approver_name: body.approver_name,
          approved_at: new Date().toISOString(),
          rejection_reason: body.rejection_reason,
          // 리뷰 시작 시간 초기화 (재리뷰)
          review_started_at: new Date().toISOString(),
          review_completed_at: null,
          review_note: null,
        })
        .eq("id", datasetId)
        .select()
        .single();

      if (error) {
        return errorResponse("Failed to reject dataset", 500, error.message);
      }

      return jsonResponse({ success: true, data });
    }

    // =========================================
    // POST /datasets/:id/publish - 퍼블리시 (S5 → S6)
    // =========================================
    if (req.method === "POST" && datasetId && action === "publish") {
      let body: PublishRequest;
      try {
        body = await req.json();
      } catch {
        return errorResponse("Invalid JSON body", 400);
      }

      if (!body.published_path) {
        return errorResponse("Missing published_path", 400);
      }

      const { data: current, error: fetchError } = await supabase
        .from("datasets")
        .select("state, admin_decision")
        .eq("id", datasetId)
        .single();

      if (fetchError) {
        if (fetchError.code === "PGRST116") {
          return errorResponse("Dataset not found", 404);
        }
        return errorResponse("Failed to fetch dataset", 500, fetchError.message);
      }

      if (current.state !== "s5_admin_decision") {
        return errorResponse(
          `Cannot publish from state ${current.state}. Must be s5_admin_decision.`,
          400
        );
      }

      if (current.admin_decision !== "approved") {
        return errorResponse(
          `Cannot publish without approval. Current decision: ${current.admin_decision}`,
          400
        );
      }

      const { data, error } = await supabase
        .from("datasets")
        .update({
          state: "s6_published" as DatasetState,
          published_at: new Date().toISOString(),
          published_path: body.published_path,
        })
        .eq("id", datasetId)
        .select()
        .single();

      if (error) {
        return errorResponse("Failed to publish dataset", 500, error.message);
      }

      return jsonResponse({ success: true, data });
    }

    // =========================================
    // DELETE /datasets/:id - 데이터셋 삭제
    // =========================================
    if (req.method === "DELETE" && datasetId && !action) {
      const { error } = await supabase
        .from("datasets")
        .delete()
        .eq("id", datasetId);

      if (error) {
        return errorResponse("Failed to delete dataset", 500, error.message);
      }

      return jsonResponse({ success: true, message: "Dataset deleted" });
    }

    return errorResponse("Not found", 404);
  } catch (err) {
    console.error("Unexpected error:", err);
    return errorResponse("Internal server error", 500, {
      message: String(err),
      stack: err instanceof Error ? err.stack : undefined,
    });
  }
});
