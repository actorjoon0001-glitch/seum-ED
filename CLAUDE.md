# 작업 규칙 (세움디자인하우징 전시장 모델 취합 페이지)

## 배포 워크플로 — 항상 지킬 것
- 모든 변경은 **새 PR을 만들어 `main`에 머지**한다. (라이브 배포는 `main` 기준)
- 작업 → 개발 브랜치(`claude/eloquent-pasteur-ud7sbv`)에 커밋·푸시 → **새 PR 생성** → **자동으로 squash 머지**까지 진행한다. (사용자에게 매번 PR/머지 여부를 다시 묻지 않는다)
- 기존 PR 머지 이력과 동일하게 **squash merge** 방식 사용, 커밋 제목은 `... (#PR번호)` 형식.
- 작업 시작 전 항상 `origin/main`을 fetch 해 최신 상태 위에서 작업한다. (브랜치가 오래된 베이스에서 갈라지지 않도록)

## 프로젝트 개요
- 단일 페이지 웹앱(`index.html`) + Supabase 백엔드. 별도 빌드/서버 없음.
- 데이터: Supabase 테이블 `house_models`, 사진: Storage 버킷 `house-photos`.
- 스키마/권한: `supabase/schema.sql` (변경 시 SQL Editor에서 실행 필요).
- DB 컬럼을 추가/변경하면 `schema.sql`에 `create` 정의와 `add column if not exists …` 마이그레이션을 함께 갱신하고, 사용자에게 실행을 안내한다.
