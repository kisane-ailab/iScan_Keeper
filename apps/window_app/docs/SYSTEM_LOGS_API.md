# System Logs API

## Endpoint

```
POST https://ebxkbawwbndptgynpvxl.supabase.co/functions/v1/system-logs
```

## Headers

```
Content-Type: application/json
```

## Body 필드

| 필드 | 타입 | 필수 | 설명 |
|------|------|:----:|------|
| source | string | O | 로그 출처 |
| description | string | X | 설명, Snake케이스로된 대문자로 (아래예시참조) |
| category | string | X | `"event"` \| `"health_check"` 중 택1 |
| code | string | X | 에러 코드명 (영문) |
| logLevel | string | X | `"info"` \| `"warning"` \| `"error"` \| `"critical"` 중 택1 |
| payload | object | X | 에러 정보, 에러가 난 파일경로 등 메타데이터 |
| attachments | jsonb | X | 첨부파일의 URL이나 경로등  (스크린샷, 디버그 이미지 등) |

## 예시

### 정상 상태

```json
{
  "source": "EdgeManager",
  "description": "정상 상태",
  "category": "event",
  "code": "ERROR_CODE_OK",
  "logLevel": "info",
  "payload": {
    "errorCode": 0
  }
}
```

### 카메라 프리즈

```json
{
  "source": "EdgeManager",
  "description": "카메라 프리즈",
  "category": "event",
  "code": "ERROR_CODE_GET_CAM_SHOT_CHECK_CAM_FREEZE",
  "logLevel": "critical",
  "payload": {
    "errorCode": 104,
    "cameraId": "CAM_01"
  }
}
```

### 겹친 물체 감지

```json
{
  "source": "EdgeManager",
  "description": "겹친 물체 감지",
  "category": "event",
  "code": "ERROR_CODE_DETECT_OVERLAPPED_OBJECT",
  "logLevel": "warning",
  "payload": {
    "errorCode": "0x30000000",
    "detectedCount": 2
  }
}
```

### AI 추론 Depth 겹침

```json
{
  "source": "EdgeManager",
  "description": "사물이 서로 겹쳐있음 (Depth 기반 검출)",
  "category": "event",
  "code": "ERROR_CODE_RUN_AI_INFERENCE_RESULT_DEPTH_OVERAPPED_OBJECT",
  "logLevel": "error",
  "payload": {
    "errorCode": 510,
    "inferenceId": "INF_20260108_001"
  }
}
```

### 캘리브레이션 실패

```json
{
  "source": "EdgeManager",
  "description": "Python 캘리브레이션 실행 실패",
  "category": "event",
  "code": "ERROR_CODE_CALIBRATION_PYTHON_EXECUTION_FAILED",
  "logLevel": "critical",
  "payload": {
    "errorCode": 604,
    "scriptPath": "calibration_opencv.py"
  }
}
```

### 입력 이미지 파일 손상 (첨부파일 포함)

```json
{
  "source": "EdgeManager",
  "description": "입력 이미지 파일 손상",
  "code": "ERROR_CODE_RUN_AI_INFERENCE_RESULT_INVALID_IMAGE_FILE",
  "logLevel": "error",
  "payload": {
    "errorCode": 508,
    "imagePath": "/data/input/img_001.jpg"
  },
  "attachments": [
    { "url": "https://storage.supabase.co/.../debug_img.png", "name": "debug_img.png" }
  ]
}
```

### Health Check

```json
{
  "source": "EdgeManager",
  "description": "정기 상태 점검",
  "category": "health_check",
  "logLevel": "info",
  "payload": {
    "cpuUsage": 45.2,
    "memoryUsage": 62.8,
    "cameraStatus": "ok"
  }
}
```

## CMD 예시

```cmd
curl -X POST "https://ebxkbawwbndptgynpvxl.supabase.co/functions/v1/system-logs" -H "Content-Type: application/json" -d "{\"source\": \"EdgeManager\", \"description\": \"카메라 프리즈\", \"code\": \"ERROR_CODE_GET_CAM_SHOT_CHECK_CAM_FREEZE\", \"logLevel\": \"critical\", \"payload\": {\"errorCode\": 104}}"
```

```cmd
curl -X POST "https://ebxkbawwbndptgynpvxl.supabase.co/functions/v1/system-logs" -H "Content-Type: application/json" -d "{\"source\": \"EdgeManager\", \"description\": \"입력 이미지 손상\", \"code\": \"ERROR_CODE_RUN_AI_INFERENCE_RESULT_INVALID_IMAGE_FILE\", \"logLevel\": \"error\", \"payload\": {\"errorCode\": 508, \"imagePath\": \"/data/input/img_001.jpg\"}, \"attachments\": [{\"url\": \"https://storage.../debug.png\"}]}"
```

## Response

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "source": "EdgeManager",
    "description": "...",
    "category": "event",
    "code": "ERROR_CODE_GET_CAM_SHOT_CHECK_CAM_FREEZE",
    "log_level": "critical",
    "attachments": null,
    "response_status": "unresponded",
    "created_at": "2026-01-08T12:00:00.000Z"
  }
}
```
