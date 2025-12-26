-- (1) Number of cases / Number of events  || 케이스 수 / 이벤트 수 
SELECT
  (SELECT COUNT(*) FROM ops_cases WHERE case_id LIKE 'OPS-1%') AS cases_160,
  (SELECT COUNT(*) FROM ops_events WHERE case_id LIKE 'OPS-1%') AS events_total;

-- (2) Issue-specific frequency ||  이슈별 빈도
SELECT issue_type, COUNT(*) AS cnt
FROM ops_cases
WHERE case_id LIKE 'OPS-1%'
GROUP BY issue_type
ORDER BY cnt DESC;

-- (3) SLA breach rate || SLA breach 비율
SELECT issue_type, ROUND(AVG(breach) * 100, 1) AS breach_rate_pct
FROM ops_cases
WHERE case_id LIKE 'OPS-1%'
GROUP BY issue_type
ORDER BY breach_rate_pct DESC;

-- (4) Vendor/Merchant Dependency || Vendor/Merchant 의존도
SELECT resolution_path, COUNT(*) AS cnt
FROM ops_cases
WHERE case_id LIKE 'OPS-1%'
GROUP BY resolution_path
ORDER BY cnt DESC;

-- (5)  Reopen Parent Issue || Reopen 상위 이슈
SELECT issue_type, COUNT(*) AS reopened_cnt
FROM ops_cases
WHERE case_id LIKE 'OPS-1%' AND reopened = 1
GROUP BY issue_type
ORDER BY reopened_cnt DESC;

-- (6) Average number of events per case || 케이스당 평균 이벤트 수 
SELECT
  ROUND(COUNT(e.event_id)*1.0 / COUNT(DISTINCT c.case_id), 2) AS avg_events_per_case
FROM ops_cases c
JOIN ops_events e ON c.case_id = e.case_id
WHERE c.case_id LIKE 'OPS-1%';
