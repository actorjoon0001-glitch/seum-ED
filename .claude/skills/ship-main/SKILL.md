---
name: ship-main
description: 현재 변경사항을 개발 브랜치에 커밋·푸시하고 새 PR을 만들어 main에 squash 자동 머지한다. 세움 전시장 취합 페이지(seum-ED)의 표준 배포 워크플로. "배포", "머지", "main에 올려", "새 PR로 머지", "ship" 요청 시 사용.
---

# ship-main — 새 PR로 main에 자동 머지

이 저장소(`actorjoon0001-glitch/seum-ED`)의 **표준 배포 워크플로**다.
사용자가 변경을 요청하고 완료했으면, 매번 PR/머지 여부를 다시 묻지 말고 아래를 그대로 실행한다.

## 대상
- 개발 브랜치: `claude/eloquent-pasteur-ud7sbv`
- 베이스(라이브): `main`
- 저장소: `actorjoon0001-glitch/seum-ED` (GitHub MCP 도구 `owner=actorjoon0001-glitch`, `repo=seum-ed`)

## 절차

1. **git 신원 확인** (커밋이 Unverified로 뜨지 않도록)
   ```bash
   git config user.email noreply@anthropic.com
   git config user.name Claude
   ```

2. **최신 main 위로 정렬** — 브랜치가 오래된 베이스에서 갈라지지 않게 한다.
   ```bash
   git fetch origin main
   ```
   작업 트리가 깨끗하고 새 작업을 시작하는 경우: `git reset --hard origin/main`.
   이미 이번 턴의 변경이 워킹트리에 있으면 stash → reset → stash pop 순으로 최신 main 위에 얹는다.

3. **커밋** — 명확한 한글 제목 + 본문. 반드시 트레일러를 붙인다.
   ```
   <요약 제목>

   - 변경 요점 1
   - 변경 요점 2

   Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
   Claude-Session: <현재 세션 URL>
   ```

4. **푸시** — `git push -u origin claude/eloquent-pasteur-ud7sbv`.
   히스토리를 다시 얹었으면 `--force-with-lease` 사용. 네트워크 실패 시 2s→4s→8s→16s 백오프로 최대 4회 재시도.

5. **새 PR 생성** — `mcp__github__create_pull_request`
   - `owner=actorjoon0001-glitch`, `repo=seum-ed`, `base=main`, `head=claude/eloquent-pasteur-ud7sbv`
   - 제목/본문은 변경 내용 기준으로 작성. 본문 끝에 `🤖 Generated with [Claude Code](https://claude.com/claude-code)`.

6. **squash 머지** — `mcp__github__merge_pull_request`
   - `merge_method=squash`
   - `commit_title` 은 `<PR 제목> (#<PR번호>)` 형식 (기존 #1~#11과 동일).

7. **보고** — PR 번호와 머지 SHA를 사용자에게 알린다. 라이브(main) 배포 반영 후 확인할 포인트를 간단히 안내한다.

## 주의
- DB 컬럼을 추가/변경했으면 `supabase/schema.sql`에 `create` 정의와 `add column if not exists …` 마이그레이션을 함께 갱신하고, 사용자에게 Supabase SQL Editor에서 실행하도록 안내한다.
- 이미 머지된 PR에는 새 커밋을 쌓지 않는다. 후속 작업은 최신 main에서 다시 시작한다.
- `main`에는 직접 푸시하지 않는다. 항상 개발 브랜치 → 새 PR → squash 머지.
