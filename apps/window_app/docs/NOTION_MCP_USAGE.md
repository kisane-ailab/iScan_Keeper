# Notion MCP 사용 가이드

## 1. MCP 설정 (.mcp.json)

```json
{
  "mcpServers": {
    "notion": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@notionhq/notion-mcp-server"],
      "env": {
        "NOTION_TOKEN": "your_notion_token_here"
      }
    }
  }
}
```

## 2. 사용 가능한 MCP 도구

### 검색/조회
| 도구 | 설명 |
|------|------|
| `API-post-search` | 페이지/데이터베이스 검색 |
| `API-retrieve-a-data-source` | 데이터베이스 스키마 조회 |
| `API-query-data-source` | 데이터베이스 쿼리 |
| `API-retrieve-a-page` | 페이지 조회 |
| `API-get-block-children` | 블록 하위 항목 조회 |

### 생성/수정
| 도구 | 설명 | 상태 |
|------|------|------|
| `API-post-page` | 페이지 생성 | ⚠️ 버그 있음 |
| `API-patch-page` | 페이지 수정 | - |
| `API-patch-block-children` | 블록 추가 | - |

## 3. 데이터베이스 검색 예시

```
mcp__notion__API-post-search
  query: "검색어"
  filter: {"property": "object", "value": "data_source"}
```

## 4. 데이터베이스 쿼리 예시

```
mcp__notion__API-query-data-source
  data_source_id: "2cccde0e-219b-81ed-9882-000b697f7123"
  page_size: 10
```

## 5. ⚠️ API-post-page 버그 우회 방법

MCP의 `API-post-page`는 객체 파라미터 직렬화 버그가 있음.
**Node.js로 직접 API 호출 필요:**

```javascript
// notion_create_page.mjs
const response = await fetch("https://api.notion.com/v1/pages", {
  method: "POST",
  headers: {
    "Authorization": "Bearer YOUR_NOTION_TOKEN",
    "Notion-Version": "2022-06-28",
    "Content-Type": "application/json"
  },
  body: JSON.stringify({
    parent: {
      database_id: "YOUR_DATABASE_ID"
    },
    properties: {
      title: {  // 속성 ID 사용 (속성명 아님)
        title: [
          {
            text: {
              content: "페이지 제목"
            }
          }
        ]
      }
    }
  })
});

const data = await response.json();
console.log(JSON.stringify(data, null, 2));
```

실행:
```bash
node notion_create_page.mjs
```

## 6. 주요 데이터베이스 정보

### 차트 (업무 관리)
- **Database ID**: `2cccde0e-219b-8086-8215-de713abacd40`
- **Data Source ID**: `2cccde0e-219b-81ed-9882-000b697f7123`

#### 속성
| 속성명 | ID | 타입 |
|--------|-----|------|
| 업무 | title | title |
| 시작 날짜 | %3DaYv | date |
| 종료 날짜 | Gk%3CA | date |
| 관련프로젝트 | Fo%3Bg | multi_select |
| 상태 | %60%3DUQ | status |
| 우선순위 | ~kb%60 | select |
| 할당 대상 | a%5EGD | people |
| 목표 | yw%5CB | rich_text |

#### 관련프로젝트 옵션
- EdgeManager
- iScanKeeper
- iScanStudio
- iScanManager
- 사내교육
- 기타

#### 상태 옵션
- 시작되지 않음
- 진행 중
- 완료됨
- 아카이브

#### 우선순위 옵션
- 낮은 우선순위
- 중간 우선순위
- 높은 우선순위

## 7. 한글 인코딩 주의사항

- **PowerShell**: Windows 인코딩 문제로 한글 깨짐
- **Node.js**: UTF-8 정상 처리 ✅
- **curl (cmd)**: 한글 깨짐

**권장: Node.js 사용**

## 8. Notion Integration 권한 설정

데이터베이스에 접근하려면:
1. 노션에서 해당 페이지/데이터베이스 열기
2. 우측 상단 `...` 메뉴 클릭
3. `연결` 또는 `Connections` 선택
4. Integration 추가

---
*마지막 업데이트: 2026-01-08*
