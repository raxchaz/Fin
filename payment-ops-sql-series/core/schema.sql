PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS incidents;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS compliance_cases;
DROP TABLE IF EXISTS partners;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id TEXT PRIMARY KEY,
  country TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE partners (
  partner_id TEXT PRIMARY KEY,
  partner_type TEXT NOT NULL,
  name TEXT NOT NULL
);

CREATE TABLE compliance_cases (
  case_id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  case_type TEXT NOT NULL,
  status TEXT NOT NULL,
  vendor_partner_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  resolved_at TEXT,
  fail_reason TEXT,
  FOREIGN KEY(user_id) REFERENCES users(user_id),
  FOREIGN KEY(vendor_partner_id) REFERENCES partners(partner_id)
);

CREATE TABLE payments (
  payment_id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  method TEXT NOT NULL,
  network TEXT NOT NULL,
  corridor_from TEXT NOT NULL,
  corridor_to TEXT NOT NULL,
  amount REAL NOT NULL,
  currency TEXT NOT NULL,
  status TEXT NOT NULL,
  failure_reason TEXT,
  created_at TEXT NOT NULL,
  completed_at TEXT,
  latency_ms INTEGER NOT NULL,
  processor_partner_id TEXT NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(user_id),
  FOREIGN KEY(processor_partner_id) REFERENCES partners(partner_id)
);

CREATE TABLE incidents (
  incident_id TEXT PRIMARY KEY,
  incident_type TEXT NOT NULL,
  severity INTEGER NOT NULL,
  started_at TEXT NOT NULL,
  resolved_at TEXT,
  summary TEXT NOT NULL,
  suspected_partner_id TEXT,
  FOREIGN KEY(suspected_partner_id) REFERENCES partners(partner_id)
);
