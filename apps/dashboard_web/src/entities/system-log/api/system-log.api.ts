import { api } from '@/shared/api';
import type {
  CreateSystemLogRequest,
  CreateSystemLogResponse,
  SetLogMutedRequest,
  SetLogMutedResponse,
} from '../model';

const ENDPOINT = '/system-logs';

export const systemLogApi = {
  /**
   * 시스템 로그 생성
   * POST /system-logs
   */
  create: (data: CreateSystemLogRequest) =>
    api.post<CreateSystemLogResponse, CreateSystemLogRequest>(ENDPOINT, data),

  /**
   * 시스템 로그 알림 무시 설정/해제
   * PATCH /system-logs/:id/mute
   */
  setMuted: (id: string, data: SetLogMutedRequest) =>
    api.patch<SetLogMutedResponse, SetLogMutedRequest>(`${ENDPOINT}/${id}/mute`, data),
};
