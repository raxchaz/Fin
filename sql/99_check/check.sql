.tables
SELECT COUNT(*) AS total_cases FROM ops_cases;
SELECT COUNT(*) AS total_events FROM ops_events;
SELECT * FROM ops_cases ORDER BY created_at DESC LIMIT 5;
SELECT * FROM ops_events ORDER BY event_time DESC LIMIT 10;
