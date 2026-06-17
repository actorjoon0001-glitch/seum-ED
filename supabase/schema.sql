-- =========================================================
-- 세움디자인하우징 전시장 모델 취합 - Supabase 스키마
-- Supabase 대시보드 > SQL Editor 에 붙여넣고 실행하세요.
-- =========================================================

-- 1) 모델 취합 테이블 ---------------------------------------
create table if not exists public.house_models (
  id            uuid primary key default gen_random_uuid(),
  hall          text        not null,                 -- 전시장 선택
  manager       text        not null,                 -- 담당자 이름
  house_type    text        not null
                  check (house_type in ('주택','쉼터','기타')),  -- 주택 유형(선택형)
  model_name    text        not null,                 -- 주택 모델명
  pyeong        numeric,                              -- 주택 평형
  price         text,                                 -- 주택가격 (예: "3억")
  exterior_urls jsonb       not null default '[]',    -- 외관사진 URL 배열
  interior_urls jsonb       not null default '[]',    -- 내부사진 URL 배열
  submitted_at  timestamptz not null default now(),   -- 제출일시(자동)
  created_at    timestamptz not null default now()
);

create index if not exists house_models_submitted_at_idx
  on public.house_models (submitted_at desc);

-- 2) RLS (행 수준 보안) -------------------------------------
alter table public.house_models enable row level security;

-- 팀장들이 로그인 없이 제출 → 익명(anon) 등록 허용
create policy "anyone can insert"
  on public.house_models for insert
  to anon, authenticated
  with check (true);

-- 취합 목록 조회 허용
create policy "anyone can read"
  on public.house_models for select
  to anon, authenticated
  using (true);

-- 제출 후 사진 추가/개별 삭제(행 업데이트) 허용
create policy "anyone can update"
  on public.house_models for update
  to anon, authenticated
  using (true)
  with check (true);

-- (선택) 삭제도 허용하려면 주석 해제
-- create policy "anyone can delete"
--   on public.house_models for delete
--   to anon, authenticated
--   using (true);

-- 3) 사진 저장용 Storage 버킷 -------------------------------
insert into storage.buckets (id, name, public)
values ('house-photos', 'house-photos', true)
on conflict (id) do nothing;

-- 버킷 정책: 누구나 업로드 / 읽기
create policy "public upload house-photos"
  on storage.objects for insert
  to anon, authenticated
  with check (bucket_id = 'house-photos');

create policy "public read house-photos"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'house-photos');
