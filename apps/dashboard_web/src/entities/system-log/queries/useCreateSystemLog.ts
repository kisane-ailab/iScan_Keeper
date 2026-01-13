import { useMutation, useQueryClient } from '@tanstack/react-query';
import { systemLogApi } from '../api';
import type { CreateSystemLogRequest, CreateSystemLogResponse } from '../model';

export const SYSTEM_LOG_QUERY_KEY = ['system-logs'] as const;

export function useCreateSystemLog() {
  const queryClient = useQueryClient();

  return useMutation<CreateSystemLogResponse, Error, CreateSystemLogRequest>({
    mutationFn: systemLogApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: SYSTEM_LOG_QUERY_KEY });
    },
  });
}
