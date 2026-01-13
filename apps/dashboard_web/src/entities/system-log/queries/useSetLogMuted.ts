import { useMutation, useQueryClient } from '@tanstack/react-query';
import { systemLogApi } from '../api';
import type { SetLogMutedRequest, SetLogMutedResponse } from '../model';

interface SetLogMutedParams {
  id: string;
  data: SetLogMutedRequest;
}

/**
 * 시스템 로그 알림 무시 설정/해제 mutation hook
 */
export function useSetLogMuted() {
  const queryClient = useQueryClient();

  return useMutation<SetLogMutedResponse, Error, SetLogMutedParams>({
    mutationFn: ({ id, data }) => systemLogApi.setMuted(id, data),
    onSuccess: () => {
      // 로그 관련 쿼리 무효화
      queryClient.invalidateQueries({ queryKey: ['system-logs'] });
    },
  });
}
