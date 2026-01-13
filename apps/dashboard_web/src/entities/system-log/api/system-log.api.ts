import { api } from '@/shared/api';
import type { CreateSystemLogRequest, CreateSystemLogResponse } from '../model';

const ENDPOINT = '/system-logs';

export const systemLogApi = {
  /**
   * 시스템 로그 생성
   * POST /system-logs
   */
  create: (data: CreateSystemLogRequest) =>
    api.post<CreateSystemLogResponse, CreateSystemLogRequest>(ENDPOINT, data),
};
