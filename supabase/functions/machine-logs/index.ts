import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

interface MachineLogRequest {
  publicIP: string;
  companyName: string;
  vendorName: string;
  dbKey: string;
  errorCode: string;
  chatID: string;
  serialNumber: string;
  totalScanCount: string;
  runMode: string;
  language: string;
  freeSpace: string;
  freeMemory: string;
  "EdgeMan-V": string;
  "ServMan-V": string;
  "JetsonMan-V": string;
  "Artis_AI-V": string;
  "Artis_AI_Model-V": string;
  runningDbSync: string;
  runningAiTraining: string;
  lastUpdate: string;
  logLevel: string;
}

// lastUpdate 문자열(YYYYMMDDHHmmss)을 ISO 타임스탬프로 변환
function parseLastUpdate(dateStr: string): string | null {
  if (!dateStr || dateStr.length !== 14) return null;

  const year = dateStr.substring(0, 4);
  const month = dateStr.substring(4, 6);
  const day = dateStr.substring(6, 8);
  const hour = dateStr.substring(8, 10);
  const minute = dateStr.substring(10, 12);
  const second = dateStr.substring(12, 14);

  return `${year}-${month}-${day}T${hour}:${minute}:${second}+09:00`;
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
    let body: MachineLogRequest;
    try {
      body = await req.json();
    } catch (parseErr) {
      return new Response(
        JSON.stringify({ error: "Invalid JSON body", details: String(parseErr) }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 필수 필드 검증 (serialNumber만 필수)
    if (!body.serialNumber) {
      return new Response(
        JSON.stringify({
          error: "Missing required field: serialNumber",
          received: body
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // JSONB 데이터 구성
    const systemInfo = {
      freeSpace: body.freeSpace || null,
      freeMemory: body.freeMemory || null,
      totalScanCount: body.totalScanCount || null,
    };

    const versionInfo = {
      EdgeMan: body["EdgeMan-V"] || null,
      ServMan: body["ServMan-V"] || null,
      JetsonMan: body["JetsonMan-V"] || null,
      Artis_AI: body["Artis_AI-V"] || null,
      Artis_AI_Model: body["Artis_AI_Model-V"] || null,
    };

    const settings = {
      chatID: body.chatID || null,
      language: body.language || null,
      runningDbSync: body.runningDbSync === "true",
      runningAiTraining: body.runningAiTraining === "true",
    };

    // lastUpdate 파싱
    const lastUpdate = parseLastUpdate(body.lastUpdate);

    // machine_logs 테이블에 삽입
    const { data, error } = await supabase
      .from("machine_logs")
      .insert({
        serial_number: body.serialNumber,
        public_ip: body.publicIP || null,
        company_name: body.companyName || null,
        vendor_name: body.vendorName || null,
        db_key: body.dbKey || null,
        error_code: body.errorCode || null,
        run_mode: body.runMode || "base",
        log_level: body.logLevel || null,
        system_info: systemInfo,
        version_info: versionInfo,
        settings: settings,
        last_update: lastUpdate,
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
          serial_number: data.serial_number,
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
