-- (1) Number of cases / Number of events  || 케이스 수 / 이벤트 수 
SELECT
  COUNT(DISTINCT c.case_id) AS cases_total,
  COUNT(e.event_id) AS events_total,
  ROUND(COUNT(e.event_id)*1.0 / COUNT(DISTINCT c.case_id), 2) AS avg_events_per_case
FROM ops_cases c
LEFT JOIN ops_events e ON c.case_id = e.case_id
WHERE c.case_id >= 'OPS-1000' AND c.case_id < 'OPS-2000';

-- (2) Issue-specific frequency ||  이슈별 빈도
SELECT
  issue_type,
  COUNT(*) AS cnt,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM ops_cases
WHERE case_id >= 'OPS-1000' AND case_id < 'OPS-2000'
GROUP BY issue_type
ORDER BY cnt DESC;


-- (3) SLA breach rate || SLA breach 비율
SELECT
  issue_type,
  SUM(breach) AS breached_cases,
  COUNT(*) AS total_cases,
  ROUND(SUM(breach) * 100.0 / COUNT(*), 1) AS breach_rate_pct
FROM ops_cases
WHERE case_id >= 'OPS-1000' AND case_id < 'OPS-2000'
GROUP BY issue_type
ORDER BY breach_rate_pct DESC;


-- (4) Vendor/Merchant Dependency || Vendor/Merchant 의존도
SELECT
  issue_type,
  resolution_path,
  COUNT(*) AS cnt
FROM ops_cases
WHERE case_id >= 'OPS-1000' AND case_id < 'OPS-2000'
GROUP BY issue_type, resolution_path
ORDER BY issue_type, cnt DESC;


-- (5)  Reopen Parent Issue || Reopen 상위 이슈
SELECT
  issue_type,
  SUM(reopened) AS reopened_cases,
  COUNT(*) AS total_cases,
  ROUND(SUM(reopened) * 100.0 / COUNT(*), 1) AS reopen_rate_pct
FROM ops_cases
WHERE case_id >= 'OPS-1000' AND case_id < 'OPS-2000'
GROUP BY issue_type
ORDER BY reopen_rate_pct DESC;


-- (6) Average number of events per case || 케이스당 평균 이벤트 수 
SELECT
  ROUND(COUNT(e.event_id)*1.0 / COUNT(DISTINCT c.case_id), 2) AS avg_events_per_case
FROM ops_cases c
LEFT JOIN ops_events e ON c.case_id = e.case_id
WHERE c.case_id >= 'OPS-1000' AND c.case_id < 'OPS-2000';
