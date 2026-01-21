-- =====================================================
-- 헬스체크 로그 압축 함수 및 크론잡
-- =====================================================
-- 규칙:
--   - info(정상) 로그만 source+site+날짜 기준 마지막 1개로 압축
--   - warning, error, critical은 절대 삭제하지 않음
--
-- 실행 시점: 매일 한국시간 00:05 (UTC 15:05)
-- =====================================================

-- 헬스체크 로그 압축 함수
create or replace function compress_health_check_logs()
returns table (
  deleted_count bigint,
  compressed_groups bigint
)
language plpgsql
security definer
as $$
declare
  v_deleted_count bigint := 0;
  v_compressed_groups bigint := 0;
  v_target_date date;
begin
  -- KST 기준 어제 날짜 계산 (타임존 버그 수정)
  v_target_date := date((now() at time zone 'Asia/Seoul') - interval '1 day');

  with daily_info_groups as (
    -- 어제 날짜의 헬스체크 로그 중 info만 source + site로 그룹화
    select
      source,
      site,
      date(created_at at time zone 'Asia/Seoul') as log_date,
      array_agg(id order by created_at desc) as log_ids,  -- 최신순 정렬
      count(*) as log_count
    from system_logs
    where
      category = 'health_check'
      and log_level = 'info'  -- info만 대상
      and date(created_at at time zone 'Asia/Seoul') = v_target_date
    group by source, site, date(created_at at time zone 'Asia/Seoul')
  ),
  logs_to_delete as (
    -- 2개 이상인 그룹에서 첫번째(마지막 로그) 제외한 나머지 선택
    select
      unnest(log_ids[2:]) as id
    from daily_info_groups
    where log_count > 1
  ),
  deleted as (
    delete from system_logs
    where id in (select id from logs_to_delete)
    returning id
  )
  select count(*) into v_deleted_count from deleted;

  -- 압축된 그룹 수 계산
  select count(*) into v_compressed_groups
  from (
    select 1
    from system_logs
    where
      category = 'health_check'
      and log_level = 'info'
      and date(created_at at time zone 'Asia/Seoul') = v_target_date
    group by source, site, date(created_at at time zone 'Asia/Seoul')
    having count(*) > 1
  ) t;

  return query select v_deleted_count, v_compressed_groups;
end;
$$;

comment on function compress_health_check_logs() is
'헬스체크 로그 압축: info(정상)만 source+site 기준 마지막 1개 유지. warning/error/critical은 절대 삭제 안함.';

-- 매일 자정(한국시간 00:05)에 실행하는 크론잡
-- UTC 기준으로 15:05 (한국시간 00:05)
select cron.schedule(
  'compress-health-check-logs',
  '5 15 * * *',
  $$ select * from compress_health_check_logs(); $$
);
