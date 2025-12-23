CREATE TABLE ops_cases (
    case_id TEXT PRIMARY KEY,
    created_at TEXT,
    issue_category TEXT,
    issue_type TEXT,
    root_cause TEXT,
    resolution_path TEXT,
    ttr_hours INTEGER,
    preventable TEXT,
    notes TEXT
);
