// System Logs 테이블 필드 검토 보고서 생성 스크립트 (v2 - attachments 반영)
const NOTION_TOKEN = "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";
const DATABASE_ID = "2cccde0e-219b-8086-8215-de713abacd40";

async function createPage() {
  const response = await fetch("https://api.notion.com/v1/pages", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${NOTION_TOKEN}`,
      "Notion-Version": "2022-06-28",
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      parent: { database_id: DATABASE_ID },
      properties: {
        "title": {
          title: [{ text: { content: "[검토] System Logs 테이블 필드 적합성 검토 보고서" } }]
        },
        "Fo;g": {  // 관련프로젝트
          multi_select: [{ name: "iScanKeeper" }]
        },
        "`=UQ": {  // 상태
          status: { name: "완료됨" }
        },
        "~kb`": {  // 우선순위
          select: { name: "중간 우선순위" }
        },
        "=aYv": {  // 시작 날짜
          date: { start: "2026-01-08" }
        },
        "Gk<A": {  // 종료 날짜
          date: { start: "2026-01-09" }
        },
        "yw\\B": {  // 목표
          rich_text: [{ text: { content: "system_logs 테이블이 다양한 에러 소스를 수용할 수 있는지 검토" } }]
        }
      }
    })
  });

  const page = await response.json();

  if (page.id) {
    console.log("Page created:", page.id);
    await addBlocks(page.id);
  } else {
    console.error("Error creating page:", JSON.stringify(page, null, 2));
  }
}

async function addBlocks(pageId) {
  const blocks = [
    // 개요
    {
      type: "heading_1",
      heading_1: { rich_text: [{ text: { content: "개요" } }] }
    },
    {
      type: "callout",
      callout: {
        icon: { emoji: "👤" },
        rich_text: [{ text: { content: "책임자: 최재영 | 작성일: 2026-01-08" } }]
      }
    },
    {
      type: "paragraph",
      paragraph: { rich_text: [{ text: { content: "본 보고서는 Supabase system_logs 테이블이 EdgeMan 에러 코드를 포함한 다양한 로그 소스를 적절히 수용할 수 있는지 검토합니다." } }] }
    },
    {
      type: "divider",
      divider: {}
    },
    // 현재 테이블 구조 (토글)
    {
      type: "heading_2",
      heading_2: { rich_text: [{ text: { content: "현재 system_logs 테이블 구조" } }] }
    },
    {
      type: "callout",
      callout: {
        icon: { emoji: "📊" },
        rich_text: [{ text: { content: "총 13개 필드 | JSONB 2개 (payload, attachments) | ENUM 3개" } }]
      }
    },
    {
      type: "toggle",
      toggle: {
        rich_text: [{ text: { content: "테이블 필드 상세 보기" } }],
        children: [
          {
            type: "table",
            table: {
              table_width: 3,
              has_column_header: true,
              has_row_header: false,
              children: [
                { type: "table_row", table_row: { cells: [[{ text: { content: "필드명" } }], [{ text: { content: "타입" } }], [{ text: { content: "설명" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "id" } }], [{ text: { content: "UUID" } }], [{ text: { content: "기본키" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "source" } }], [{ text: { content: "VARCHAR" } }], [{ text: { content: "로그 출처 (machine, web, app 등)" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "description" } }], [{ text: { content: "TEXT" } }], [{ text: { content: "로그 설명" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "category" } }], [{ text: { content: "ENUM" } }], [{ text: { content: "event / health_check" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "code" } }], [{ text: { content: "VARCHAR" } }], [{ text: { content: "에러코드/상태코드" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "log_level" } }], [{ text: { content: "ENUM" } }], [{ text: { content: "info/warning/error/critical" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "payload" } }], [{ text: { content: "JSONB" } }], [{ text: { content: "상세 데이터 (유연한 확장)" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "attachments" } }], [{ text: { content: "JSONB" } }], [{ text: { content: "첨부파일 (이미지URL, 파일경로)" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "response_status" } }], [{ text: { content: "ENUM" } }], [{ text: { content: "대응 상태" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "current_responder_*" } }], [{ text: { content: "UUID/VARCHAR" } }], [{ text: { content: "대응 담당자 정보" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "organization_id" } }], [{ text: { content: "UUID" } }], [{ text: { content: "소속 조직" } }]] } },
                { type: "table_row", table_row: { cells: [[{ text: { content: "created_at" } }], [{ text: { content: "TIMESTAMPTZ" } }], [{ text: { content: "생성 시간" } }]] } }
              ]
            }
          }
        ]
      }
    },
    {
      type: "toggle",
      toggle: {
        rich_text: [{ text: { content: "attachments 컬럼 사용 예시" } }],
        children: [
          { type: "paragraph", paragraph: { rich_text: [{ text: { content: "// 단일 이미지" } }] } },
          { type: "code", code: { language: "json", rich_text: [{ text: { content: '[{"type": "image", "url": "https://storage.supabase.co/..."}]' } }] } },
          { type: "paragraph", paragraph: { rich_text: [{ text: { content: "// 여러 파일" } }] } },
          { type: "code", code: { language: "json", rich_text: [{ text: { content: '[\n  {"type": "image", "url": "https://..."},\n  {"type": "log", "path": "/var/log/error.log"},\n  {"type": "screenshot", "url": "https://..."}\n]' } }] } }
        ]
      }
    },
    {
      type: "divider",
      divider: {}
    },
    // EdgeMan 에러 코드 분석 (토글)
    {
      type: "heading_2",
      heading_2: { rich_text: [{ text: { content: "EdgeMan 에러 코드 분석" } }] }
    },
    {
      type: "toggle",
      toggle: {
        rich_text: [{ text: { content: "에러 코드 카테고리별 분류 (총 11개 카테고리, 50개+ 코드)" } }],
        children: [
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "기본 상태 코드: ERROR_CODE_OK (0), ERROR_CODE_RESULT_OK (0x00000000)" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "통신 패킷 에러 (0x10000000~): 2개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "추론 데이터 에러 (0x20000000~): 4개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "추론 결과 에러 (0x30000000~): 6개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "카메라 파라미터 설정 에러 (50번대): 8개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "카메라 촬영 에러 (100번대): 7개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "AI 데이터 획득 에러 (200번대): 4개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "ZMQ 통신 에러 (300번대): 4개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "Python 실행 에러 (400번대): 7개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "AI 추론 결과 에러 (500번대): 12개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "캘리브레이션 에러 (600번대): 10개 코드" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "비정형 에러: HTTP/네트워크/소켓 통신 에러" } }] } }
        ]
      }
    },
    {
      type: "divider",
      divider: {}
    },
    // 검토 결과
    {
      type: "heading_2",
      heading_2: { rich_text: [{ text: { content: "검토 결과: 적합" } }] }
    },
    {
      type: "callout",
      callout: {
        icon: { emoji: "✅" },
        rich_text: [{ text: { content: "현재 테이블 구조는 다양한 에러 소스를 수용하기에 충분히 범용적입니다." } }]
      }
    },
    {
      type: "toggle",
      toggle: {
        rich_text: [{ text: { content: "필드별 적합성 분석 상세" } }],
        children: [
          { type: "numbered_list_item", numbered_list_item: { rich_text: [{ text: { content: "source (VARCHAR): 적합 - machine, web, app, edge_function 등 다양한 출처 구분" } }] } },
          { type: "numbered_list_item", numbered_list_item: { rich_text: [{ text: { content: "code (VARCHAR): 적합 - 16진수(0x10000000), 정수(100), 문자열 등 다양한 형식 수용" } }] } },
          { type: "numbered_list_item", numbered_list_item: { rich_text: [{ text: { content: "log_level (ENUM): 적합 - info/warning/error/critical로 심각도 구분" } }] } },
          { type: "numbered_list_item", numbered_list_item: { rich_text: [{ text: { content: "payload (JSONB): 매우 적합 - 에러별 추가 정보 유연하게 저장" } }] } },
          { type: "numbered_list_item", numbered_list_item: { rich_text: [{ text: { content: "attachments (JSONB): 매우 적합 - 이미지URL, 파일경로 등 첨부파일 관리" } }] } },
          { type: "numbered_list_item", numbered_list_item: { rich_text: [{ text: { content: "category (ENUM): 적합 - event(단발)/health_check(주기적) 구분" } }] } }
        ]
      }
    },
    {
      type: "divider",
      divider: {}
    },
    // 장점
    {
      type: "heading_2",
      heading_2: { rich_text: [{ text: { content: "현재 설계의 장점" } }] }
    },
    {
      type: "toggle",
      toggle: {
        rich_text: [{ text: { content: "장점 상세 보기" } }],
        children: [
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "범용성: EdgeMan 외에 웹, 앱, Edge Function 등 다양한 소스의 로그 통합 관리" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "확장성: payload(JSONB)로 소스별 특화 데이터 저장 (스키마 변경 없이)" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "첨부파일: attachments(JSONB)로 이미지/파일 URL 유연하게 관리" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "대응 추적: response_status, responder 필드로 문제 대응 현황 관리" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "조직 분리: organization_id로 멀티 테넌시 지원" } }] } },
          { type: "bulleted_list_item", bulleted_list_item: { rich_text: [{ text: { content: "성능: 주요 필드에 인덱스 적용 (source, category, code, log_level, payload, attachments)" } }] } }
        ]
      }
    },
    {
      type: "divider",
      divider: {}
    },
    // 결론
    {
      type: "heading_2",
      heading_2: { rich_text: [{ text: { content: "결론" } }] }
    },
    {
      type: "quote",
      quote: {
        rich_text: [{ text: { content: "현재 system_logs 테이블은 범용적으로 잘 설계되어 있으며, EdgeMan 에러 코드를 포함한 다양한 소스의 로그를 오버피팅 없이 수용할 수 있습니다. attachments 컬럼 추가로 이미지/파일 관리도 가능해졌습니다. 즉시 변경이 필요한 사항은 없습니다." } }]
      }
    }
  ];

  const response = await fetch(`https://api.notion.com/v1/blocks/${pageId}/children`, {
    method: "PATCH",
    headers: {
      "Authorization": `Bearer ${NOTION_TOKEN}`,
      "Notion-Version": "2022-06-28",
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ children: blocks })
  });

  const result = await response.json();
  if (result.results) {
    console.log("Blocks added successfully!");
    console.log("Page URL: https://notion.so/" + pageId.replace(/-/g, ""));
  } else {
    console.error("Error adding blocks:", JSON.stringify(result, null, 2));
  }
}

createPage().catch(console.error);
