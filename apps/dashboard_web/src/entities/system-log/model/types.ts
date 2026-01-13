// 로그 레벨
export type LogLevel = 'info' | 'warning' | 'error' | 'critical';

// 로그 카테고리
export type LogCategory = 'event' | 'health_check';

// 대응 상태
export type ResponseStatus = 'unchecked' | 'in_progress' | 'completed' | 'unresponded';

// 환경
export type Environment = 'development' | 'production';

// 시스템 로그 엔티티
export interface SystemLog {
  id: string;
  source: string;
  code: string | null;
  log_level: LogLevel;
  category: LogCategory;
  description: string | null;
  payload: Record<string, unknown> | null;
  attachments: Record<string, unknown> | null;
  environment: Environment;
  response_status: ResponseStatus;
  current_responder_id: string | null;
  current_responder_name: string | null;
  response_started_at: string | null;
  organization_id: string | null;
  assigned_by_id: string | null;
  assigned_by_name: string | null;
  is_muted: boolean | null;
  created_at: string;
}

// 시스템 로그 생성 요청
export interface CreateSystemLogRequest {
  source: string;
  category: LogCategory;
  code: string;
  logLevel: LogLevel;
  environment: Environment;
  description?: string;
  payload?: string; // JSON string
  attachments?: string; // JSON string
}

// 시스템 로그 생성 응답
export interface CreateSystemLogResponse {
  success: boolean;
  data: {
    id: string;
    source: string;
    description: string | null;
    category: LogCategory;
    code: string;
    log_level: LogLevel;
    environment: Environment;
    attachments: Record<string, unknown> | null;
    response_status: ResponseStatus;
    created_at: string;
  };
}

// 시스템 로그 mute 요청
export interface SetLogMutedRequest {
  muted: boolean;
}

// 시스템 로그 mute 응답
export interface SetLogMutedResponse {
  success: boolean;
  data: {
    id: string;
    source: string;
    code: string;
    is_muted: boolean;
  };
}

// API 에러 응답
export interface ApiErrorResponse {
  error: string;
  details?: unknown;
}
