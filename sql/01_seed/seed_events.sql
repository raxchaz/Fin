WITH RECURSIVE
cases AS (
  SELECT case_id, created_at
  FROM ops_cases
  WHERE case_id LIKE 'OPS-1%'
),
steps(step) AS (
  SELECT 1 UNION ALL SELECT step+1 FROM steps WHERE step < 8
)
INSERT INTO ops_events (case_id, event_time, actor, action, notes)
SELECT
  c.case_id,
  datetime(c.created_at, printf('+%d minutes', step*30)) AS event_time,
  CASE
    WHEN step IN (1,2) THEN 'SYSTEM'
    WHEN step IN (3,4) THEN 'OPS'
    WHEN step = 5 THEN CASE WHEN c.case_id LIKE 'OPS-10%' THEN 'VENDOR' ELSE 'MERCHANT' END
    WHEN step IN (6,7) THEN 'OPS'
    ELSE 'SYSTEM'
  END AS actor,
  CASE
    WHEN step = 1 THEN 'CASE_CREATED'
    WHEN step = 2 THEN 'TRIAGE_CLASSIFIED'
    WHEN step = 3 THEN 'TX_LOOKUP'
    WHEN step = 4 THEN 'EVIDENCE_REQUESTED'
    WHEN step = 5 THEN 'ESCALATED'
    WHEN step = 6 THEN 'REFUND_INITIATED'
    WHEN step = 7 THEN 'USER_UPDATED'
    ELSE 'CASE_CLOSED'
  END AS action,
  CASE
    WHEN step = 4 THEN 'Requested: tx_id/order_id, screenshots, timeline.'
    WHEN step = 5 THEN 'Partner ticket opened with structured payload.'
    WHEN step = 6 THEN 'Refund workflow started; monitoring status.'
    ELSE NULL
  END AS notes
FROM cases c
CROSS JOIN steps;
