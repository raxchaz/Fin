-- 1) Extension of existing ops_cases  (케이스 확장)
ALTER TABLE ops_cases ADD COLUMN product TEXT;          -- GrabPay / GrabFood / PEXX (확장 가능)
ALTER TABLE ops_cases ADD COLUMN payment_state TEXT;    -- AUTH / CAPTURED / HOLD / REFUNDED
ALTER TABLE ops_cases ADD COLUMN refund_state TEXT;     -- NOT_STARTED / INITIATED / PENDING / COMPLETED / FAILED
ALTER TABLE ops_cases ADD COLUMN status TEXT;           -- OPEN / PENDING / ESCALATED / RESOLVED / CLOSED
ALTER TABLE ops_cases ADD COLUMN priority TEXT;         -- LOW / MEDIUM / HIGH
ALTER TABLE ops_cases ADD COLUMN reopened INTEGER;      -- 0/1
ALTER TABLE ops_cases ADD COLUMN sla_hours INTEGER;     -- 24/48/72
ALTER TABLE ops_cases ADD COLUMN breach INTEGER;        -- 0/1
ALTER TABLE ops_cases ADD COLUMN order_id TEXT;         -- GrabFood 등 주문 연동
ALTER TABLE ops_cases ADD COLUMN tx_id TEXT;            -- 결제 트랜잭션 키
ALTER TABLE ops_cases ADD COLUMN channel TEXT;          -- CHAT / EMAIL / INAPP 등
ALTER TABLE ops_cases ADD COLUMN country TEXT;          -- SG / MY / PH 등

-- 2) Event Log Table (이벤트 로그)
CREATE TABLE IF NOT EXISTS ops_events (
  event_id INTEGER PRIMARY KEY AUTOINCREMENT,
  case_id TEXT NOT NULL,
  event_time TEXT NOT NULL,     -- ISO-8601 string
  actor TEXT NOT NULL,          -- USER / OPS / VENDOR / MERCHANT / SYSTEM
  action TEXT NOT NULL,         -- CASE_CREATED, TX_LOOKUP, REFUND_INITIATED, ...
  notes TEXT,
  FOREIGN KEY(case_id) REFERENCES ops_cases(case_id)
);

-- 3) Index for Query/Analysis (조회, 분석용)
CREATE INDEX IF NOT EXISTS idx_ops_cases_issue ON ops_cases(issue_type, issue_category);
CREATE INDEX IF NOT EXISTS idx_ops_cases_states ON ops_cases(status, refund_state, payment_state);
CREATE INDEX IF NOT EXISTS idx_ops_events_case_time ON ops_events(case_id, event_time);
