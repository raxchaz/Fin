SELECT issue_category, COUNT(*) AS total_cases
FROM ops_cases
GROUP BY issue_category
ORDER BY total_cases DESC;
-- Ops resources are the biggest drain.

SELECT issue_category, ROUND(AVG(ttr_hours), 1) AS avg_ttr
FROM ops_cases
GROUP BY issue_category
ORDER BY avg_ttr DESC;
-- The section with the worst user experience.

SELECT preventable, COUNT(*) AS cnt
FROM ops_cases
GROUP BY preventable;
-- The proportion that can be reduced through UX/Ops improvements.

SELECT resolution_path, COUNT(*) AS cnt
FROM ops_cases
GROUP BY resolution_path
ORDER BY cnt DESC;
-- Partner dependency and bottlenecks.