PRAGMA foreign_keys = ON;

-- Partners (KYC vendor + payment processor)
INSERT INTO partners(partner_id, partner_type, name) VALUES
('p_kyc_1', 'KYC_VENDOR', 'KYCVendorOne'),
('p_proc_1', 'PAYMENT_PROCESSOR', 'StablecoinProcessorOne');

-- Users
INSERT INTO users(user_id, country, created_at) VALUES
('u_001', 'KR', '2025-12-20 09:10:00'),
('u_002', 'SG', '2025-12-20 10:05:00'),
('u_003', 'PH', '2025-12-20 11:22:00');

-- KYC cases
INSERT INTO compliance_cases(case_id, user_id, case_type, status, vendor_partner_id, created_at, resolved_at, fail_reason) VALUES
('k_001', 'u_001', 'KYC', 'pass',    'p_kyc_1', '2025-12-20 09:12:00', '2025-12-20 09:20:00', NULL),
('k_002', 'u_002', 'KYC', 'pending', 'p_kyc_1', '2025-12-20 10:06:00', NULL,                    NULL),
('k_003', 'u_003', 'KYC', 'fail',    'p_kyc_1', '2025-12-20 11:23:00', '2025-12-20 11:40:00', 'id_mismatch');

-- Payments (stablecoin)
INSERT INTO payments(payment_id, user_id, method, network, corridor_from, corridor_to, amount, currency, status, failure_reason, created_at, completed_at, latency_ms, processor_partner_id) VALUES
('pay_001', 'u_001', 'STABLECOIN', 'USDT', 'SG', 'PH', 120.00, 'USD', 'completed', NULL,                 '2025-12-21 09:00:00', '2025-12-21 09:00:02',  2100, 'p_proc_1'),
('pay_002', 'u_001', 'STABLECOIN', 'USDC', 'SG', 'ID',  55.50, 'USD', 'failed',    'network_error',      '2025-12-21 10:10:00', NULL,                   8000, 'p_proc_1'),
('pay_003', 'u_002', 'STABLECOIN', 'USDT', 'SG', 'VN',  75.00, 'USD', 'failed',    'compliance_blocked', '2025-12-21 10:20:00', NULL,                   1500, 'p_proc_1'),
('pay_004', 'u_003', 'STABLECOIN', 'USDC', 'SG', 'PH', 200.00, 'USD', 'initiated', NULL,                 '2025-12-21 11:00:00', NULL,                    300, 'p_proc_1');
