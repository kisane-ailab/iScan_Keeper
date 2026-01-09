# EdgeMan 에러 코드 전체 목록

**에러 코드 정의 위치**: `kisan/kisan_error_code.h`  

## 1. 기본 상태 코드

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_OK` (0) | 정상 상태 |
| `ERROR_CODE_RESULT_OK` ("0x00000000") | 추론 정상 결과 |

---

## 2. 통신 패킷 관련 에러 (0x10000000 ~)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_INVALID_PACKET_STX_ETX` ("0x10000000") | 수신 받은 패킷의 STX와 ETX가 정의된 내용이랑 다른 경우 |
| `ERROR_CODE_INVALID_PACKET_CMD`     ("0x10000001") | 수신 받은 패킷의 Cmd 가 정의된 내용이랑 다른 경우 |

---

## 3. 추론 데이터 관련 에러 (0x20000000 ~)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_INVALID_IMAGE_COUNT`       ("0x20000000") | 추론 이미지 개수가 잘못됨 |
| `ERROR_CODE_NOT_EXIST_INFERENCE_IMAGE` ("0x20000001") | 추론 이미지가 존재하지 않음 |
| `ERROR_CODE_INVALID_DEBUG_IMAGE`       ("0x20000002") | 디버깅 이미지가 없음 |
| `ERROR_CODE_INVALID_INFERENCE_IMAGE`   ("0x20000003") | 추론 이미지에 문제가 있음 |

---

## 4. 추론 결과 관련 에러 (0x30000000 ~)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_DETECT_OVERLAPPED_OBJECT` ("0x30000000") | 겹친 물체 감지 |
| `ERROR_CODE_DETECT_UNTRAINED_OBJECT`  ("0x30000100") | 학습되지 않은 물체 감지 |
| `ERROR_CODE_DETECT_INVALID_OBJECT`    ("0x30000101") | 유효하지 않은 물체 감지 |
| `ERROR_CODE_DETECT_REFLECTION_OBJECT` ("0x30000200") | 난반사 물체 감지 |
| `ERROR_CODE_DETECT_STAND_OBJECT`      ("0x30000201") | 세워진 물체 감지 |
| `ERROR_CODE_DETECT_MAX_DEPTH_OBJECT`  ("0x30000202") | 카메라와 근접한 물체 감지 |

---

## 5. 카메라 파라미터 설정 에러 (50번대)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_SET_CAM_PARAM_UNKNOWN`                          (50) | 알 수 없는 에러 |
| `ERROR_CODE_SET_CAM_PARAM_RECV_EMPTY_BODY_PACKET`           (51) | 빈 Body 패킷 수신 |
| `ERROR_CODE_SET_CAM_PARAM_FAILED_TO_SET_JSON_INFO`          (52) | JSON 정보 설정 실패 |
| `ERROR_CODE_SET_CAM_PARAM_WRONG_JETSON_TYPE`                (53) | 잘못된 Jetson 타입 |
| `ERROR_CODE_SET_CAM_PARAM_FAILED_TO_SET_USB_STEREO_GRABBER` (54) | USB 스테레오 그랩버 설정 실패 |
| `ERROR_CODE_SET_CAM_PARAM_FAILED_TO_GET_FRAME`              (55) | 프레임 획득 실패 |
| `ERROR_CODE_SET_CAM_PARAM_CHECK_SCAN_AREA`                  (56) | 스캔 영역 검사 실패 |
| `ERROR_CODE_SET_CAM_PARAM_CHECK_IMG_INVALID`                (57) | 이미지 유효성 검사 실패 |

---

## 6. 카메라 촬영 에러 (100번대)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_GET_CAM_SHOT_UNKNOWN`                (100) | 알 수 없는 에러 |
| `ERROR_CODE_GET_CAM_SHOT_WRONG_RUN_MODE`         (101) | 잘못된 실행 모드 |
| `ERROR_CODE_GET_CAM_SHOT_RECV_EMPTY_BODY_PACKET` (102) | 빈 Body 패킷 수신 |
| `ERROR_CODE_GET_CAM_SHOT_CHECK_CAM_EMPTY`        (103) | 카메라 비어있음 |
| `ERROR_CODE_GET_CAM_SHOT_CHECK_CAM_FREEZE`       (104) | 카메라 프리즈 |
| `ERROR_CODE_GET_CAM_SHOT_CHECK_CAM_TOO_DARK`     (105) | 카메라 너무 어두움 |
| `ERROR_CODE_GET_CAM_SHOT_FAILED_TO_GET_FRAME`    (106) | 프레임 획득 실패 |

---

## 7. AI 데이터 획득 에러 (200번대)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_GET_AI_DATA_UNKNOWN`                      (200) | 알 수 없는 에러 |
| `ERROR_CODE_GET_AI_DATA_WRONG_RUN_MODE`               (201) | 잘못된 실행 모드 |
| `ERROR_CODE_GET_AI_DATA_RECV_EMPTY_BODY_PACKET`       (202) | 빈 Body 패킷 수신 |
| `ERROR_CODE_GET_AI_DATA_FAILED_TO_CREATE_INPUT_IMAGE` (203) | 입력 이미지 생성 실패 |

---

## 8. ZMQ 통신 에러 (300번대)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_ZMQ_UNKNOWN`   (300) | 알 수 없는 에러 |
| `ERROR_CODE_ZMQ_BUF_EMPTY` (301) | 버퍼 비어있음 |
| `ERROR_CODE_ZMQ_BUF_STX`   (302) | STX 버퍼 에러 |
| `ERROR_CODE_ZMQ_BUF_ETX`   (303) | ETX 버퍼 에러 |

---

## 9. Python 실행 에러 (400번대)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_RUN_PYTHON_UNKNOWN`                      (400) | 알 수 없는 에러 |
| `ERROR_CODE_RUN_PYTHON_FAILED_TO_WARM_UP`            (401) | 워밍업 실패 |
| `ERROR_CODE_RUN_PYTHON_WRONG_RUN_MODE`               (402) | 잘못된 실행 모드 |
| `ERROR_CODE_RUN_PYTHON_FAILED_TO_MAKE_PACKET`        (403) | 패킷 생성 실패 |
| `ERROR_CODE_RUN_PYTHON_FAILED_TO_CREATE_INPUT_IMAGE` (404) | 입력 이미지 생성 실패 |
| `ERROR_CODE_RUN_PYTHON_UNSUPPORT_CAM_COUNT`          (405) | 지원하지 않는 카메라 개수 |
| `ERROR_CODE_RUN_PYTHON_FAILED_TO_PYTHON_CHECK_ALIVE` (406) | Python 생존 확인 실패 |

---

## 10. AI 추론 결과 에러 (500번대)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_UNKNOWN`                     (500) | 알 수 없는 결과 / 파이썬의 비정상적 종료 시 |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_WRONG_PACKET`                (501) | 프로토콜 에러, 전송된 스트링이 0x02로 시작되지 않거나, 0x03으로 종료되지 않을 때 |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_UNKNOWN_COMMAND`             (502) | 정의되지 않은 명령 실행 (현재는 0x01 추론시작이 아니면 오류) |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_WRONG_IMAGE_NUMBER`          (503) | 추론불가능한 영상 개수 (현재는 1이 아니면 오류) |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_NOT_MACHED_INPUT_IMAGE`      (504) | 입력 절대경로 수 < 영상 개수일 때 |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_NO_IMAGE`                    (505) | 입력 이미지가 존재하지 않을 때, 혹은 절대경로 오류 |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_EMPTY_DEBUG_FLAG`            (506) | 디버깅 유무가 없을 때 |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_EMPTY_DEBUG_PATH`            (507) | 디버깅 옵션이 True일때 이미지 저장경로가 누락되었을 때 |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_INVALID_IMAGE_FILE`          (508) | 입력 이미지 파일이 비어있거나 깨져있을 때(문제되는 이미지 경로와 함께 보냄) |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_DEPTH_FAILED_TO_FIND_OBJECT` (509) | AI 모델이 검출한 영역 이외에 사물이 있을 때 (Depth 기반 검출) |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_DEPTH_OVERAPPED_OBJECT`      (510) | 사물이 서로 겹쳐있을 때 (Depth 기반 검출) |
| `ERROR_CODE_RUN_AI_INFERENCE_RESULT_DEPTH_CREATED_ABNORMALLY`    (511) | Depth가 정상적으로 생성되지 않았을 때 |

---

## 11. 캘리브레이션 에러 (600번대)

| 코드 | 설명 |
|------|------|
| `ERROR_CODE_CALIBRATION_UNKNOWN`                 (600) | 알 수 없는 에러 |
| `ERROR_CODE_CALIBRATION_ALREADY_IN_PROGRESS`     (601) | 캘리브레이션이 이미 진행 중 |
| `ERROR_CODE_CALIBRATION_FILE_WRITE_FAILED`       (602) | 캘리브레이션 파일 쓰기 실패 (calibration_results.xml) |
| `ERROR_CODE_CALIBRATION_PYTHON_SCRIPT_NOT_FOUND` (603) | 캘리브레이션 python 스크립트 없음 (calibration_opencv.py) |
| `ERROR_CODE_CALIBRATION_PYTHON_EXECUTION_FAILED` (604) | Python 캘리브레이션 실행 실패 |
| `ERROR_CODE_CALIBRATION_RESULT_FILE_NOT_FOUND`   (605) | 캘리브레이션 결과 파일 없음 (calibration_result.xml) |
| `ERROR_CODE_CALIBRATION_AI_RESTART_FAILED`       (606) | python 재시작 실패 |
| `ERROR_CODE_CALIBRATION_DEPTH_VALIDATION_FAILED` (607) | Depth 검증 실패 (depth_offset.txt) |
| `ERROR_CODE_CALIBRATION_CONNECTION_FAILED`       (608) | 캘리브레이션 서비스 연결 실패 |
| `ERROR_CODE_CALIBRATION_HTTP_ERROR`              (609) | HTTP 통신 오류 |

================================================================================================================================================

**에러 코드로 정의되지 않은 에러**

## 1. HTTP 통신 에러

### WinHTTP API 에러

| 에러 종류 | 설명 | 에러 코드 |
|----------|------|-----------|
| WinHTTP 세션 생성 실패 | `WinHttpOpen()` 실패 | `GetLastError()` |
| 서버 연결 실패 | `WinHttpConnect()` 실패 | `GetLastError()` |
| HTTP 요청 핸들 생성 실패 | `WinHttpOpenRequest()` 실패 | `GetLastError()` |
| HTTP 요청 전송 실패 | `WinHttpSendRequest()` 실패 | `GetLastError()` |
| HTTP 응답 수신 실패 | `WinHttpReceiveResponse()` 실패 | `GetLastError()` |

### HTTP 타임아웃 에러

| 타임아웃 종류 | 타임아웃 시간 | 에러 코드 |
|--------------|--------------|-----------|
| 연결 타임아웃 | 10초 | `ERROR_WINHTTP_TIMEOUT` (12002) |
| 전송 타임아웃 | 10초 | `ERROR_WINHTTP_TIMEOUT` (12002) |
| 수신 타임아웃 | 10초 | `ERROR_WINHTTP_TIMEOUT` (12002) |
| DNS 타임아웃 | 3초 | - |

### HTTP 상태 코드 에러

| 상태 코드 | 설명 | 처리 방식 |
|-----------|------|-----------|
| **400 Bad Request** | 잘못된 요청 형식 또는 내용 | 재전송 안 함 (Telegram API) |
| **403 Forbidden** | 접근 거부 (봇 차단 또는 채팅 접근 불가) | 재전송 안 함 (Telegram API) |
| **429 Too Many Requests** | 요청 속도 제한 초과 | 재전송 시도 (Telegram API) |
| **500+ Server Error** | 서버 내부 오류 | 재전송 시도 |
| **200/201 외 모든 상태 코드** | 정상 응답이 아닌 경우 | 경고 로그 출력 |

### HTTP 예외 처리

| 예외 종류 | 설명 |
|----------|------|
| `std::exception` | 표준 예외 발생 |
| `Unknown exception` | 알 수 없는 예외 |

---

## 2. 네트워크/통신 에러

### 소켓 통신 에러

| 에러 종류 | 설명 | 에러 코드 |
|----------|------|-----------|
| 소켓 수신 실패 | `recv()` 함수 실패 | `WSAGetLastError()` |
| 연결 종료 | 상대방이 연결 종료 | `bytesReceived == 0` |
| 데이터 부족 | 수신된 데이터가 2바이트 미만 | - |
| STX 에러 | 시작 바이트(0x02) 불일치 | - |
| ETX 에러 | 종료 바이트(0x03) 불일치 | - |
| JSON 파싱 실패 | JSON 헤더 파싱 실패 | - |
| 체크섬 불일치 | 체크섬 검증 실패 | - |
| 헤더 오버플로우 | 헤더 크기 제한 초과 | - |

### ZMQ (ZeroMQ) 통신 에러

| 에러 종류 | 설명 | 처리 방식 |
|----------|------|-----------|
| ZMQ 수신 실패 | `zmq_msg_recv()` 실패 | 재시도 (10ms 대기) |
| 빈 버퍼 | 수신 버퍼가 비어있음 | 연결 종료 |
| JSON 파싱 실패 | ZMQ 메시지 JSON 파싱 실패 | 재시도 (10ms 대기) |
| ZMQ 전송 실패 | `zmq_send()` 실패 | 경고 로그 출력 |

### 기타 네트워크 통신 에러

| 에러 종류 | 설명 | 에러 코드 |
|----------|------|-----------|
| FTP 연결 실패 | FTP 서버 연결 실패 | `GetLastError()` |
| FTP 데이터 소켓 실패 | FTP 데이터 전송 소켓 실패 | `GetLastError()` |
| SSH 연결 실패 | SSH 서버 연결 실패 | `GetLastError()` |
| SSH 인증 실패 | SSH 인증 실패 | - |
| Telegram API 전송 실패 | HTTP 요청/응답 실패 | `GetLastError()` |
| Telegram 타임아웃 | 타임아웃 발생 (12002) | 재전송 안 함 |
| TCP 연결 실패 | TCP 서버 연결 실패 | `WSAGetLastError()` |
| TCP 바인드 실패 | 소켓 바인드 실패 | `WSAGetLastError()` |
| TCP 전송/수신 실패 | `send()`/`recv()` 함수 실패 | `WSAGetLastError()` |
| iScanKeeper 서버 연결 실패 | iScanKeeper 서버 연결 실패 | `GetLastError()` |

================================================================================================================================================

**긴급 에러 알림에 보내는 내용**
## 1. 카메라 관련 오류
- 6. 카메라 촬영 에러 (100번대)와 동일

## 2. JSON 설정 파일 감지
(config, camera_param 등등)
- JSON 설정 파일이 누락된 경우
- JSON 설정 파일이 변경된 경우 

## 3. Smartro POS DB 변경 감지
- Smartro POS DB 파일이 변경된 경우
- 변경된 항목이 감지된 경우

## 4. iScan 인스턴스 추론 실패(HTTP 통신 관련)