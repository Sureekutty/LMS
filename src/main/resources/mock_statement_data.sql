-- ====================================================================
-- Statement Dispatcher - Mock Data SQL
-- ====================================================================
-- This script seeds realistic transaction and statement records
-- for the Member Portal. Ensure at least 10 entries per user exist
-- for comprehensive UI testing of the statement history.

-- Create test members (if not using ApplicationRunner seeding)
INSERT IGNORE INTO members (id, membership_no, name, status, created_at, updated_at) 
VALUES 
(1, 'MEM-0001', 'John Doe', 'ACTIVE', NOW(), NOW()),
(2, 'MEM-0002', 'Jane Smith', 'ACTIVE', NOW(), NOW());

-- Seed Transactions for MEM-0001 (John Doe)
-- Type: DEPOSIT, WITHDRAWAL, LOAN_EMI, SHARE_CAPITAL
INSERT IGNORE INTO transactions (id, member_id, transaction_date, type, amount, status, reference_no) VALUES 
(1001, 1, DATE_SUB(NOW(), INTERVAL 45 DAY), 'DEPOSIT', 5000.00, 'COMPLETED', 'TXN-000001'),
(1002, 1, DATE_SUB(NOW(), INTERVAL 40 DAY), 'SHARE_CAPITAL', 1000.00, 'COMPLETED', 'TXN-000002'),
(1003, 1, DATE_SUB(NOW(), INTERVAL 30 DAY), 'LOAN_EMI', 2500.00, 'COMPLETED', 'TXN-000003'),
(1004, 1, DATE_SUB(NOW(), INTERVAL 25 DAY), 'DEPOSIT', 1500.00, 'COMPLETED', 'TXN-000004'),
(1005, 1, DATE_SUB(NOW(), INTERVAL 20 DAY), 'WITHDRAWAL', 1000.00, 'COMPLETED', 'TXN-000005'),
(1006, 1, DATE_SUB(NOW(), INTERVAL 15 DAY), 'LOAN_EMI', 2500.00, 'COMPLETED', 'TXN-000006'),
(1007, 1, DATE_SUB(NOW(), INTERVAL 14 DAY), 'DEPOSIT', 3000.00, 'COMPLETED', 'TXN-000007'),
(1008, 1, DATE_SUB(NOW(), INTERVAL 10 DAY), 'THRIFT', 500.00, 'COMPLETED', 'TXN-000008'),
(1009, 1, DATE_SUB(NOW(), INTERVAL 5 DAY), 'DEPOSIT', 2000.00, 'COMPLETED', 'TXN-000009'),
(1010, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 'LOAN_EMI', 2500.00, 'COMPLETED', 'TXN-000010');

-- Seed Transactions for MEM-0002 (Jane Smith)
INSERT IGNORE INTO transactions (id, member_id, transaction_date, type, amount, status, reference_no) VALUES 
(1011, 2, DATE_SUB(NOW(), INTERVAL 45 DAY), 'DEPOSIT', 8000.00, 'COMPLETED', 'TXN-000011'),
(1012, 2, DATE_SUB(NOW(), INTERVAL 35 DAY), 'SHARE_CAPITAL', 2000.00, 'COMPLETED', 'TXN-000012'),
(1013, 2, DATE_SUB(NOW(), INTERVAL 30 DAY), 'THRIFT', 1500.00, 'COMPLETED', 'TXN-000013'),
(1014, 2, DATE_SUB(NOW(), INTERVAL 28 DAY), 'WITHDRAWAL', 3000.00, 'COMPLETED', 'TXN-000014'),
(1015, 2, DATE_SUB(NOW(), INTERVAL 20 DAY), 'DEPOSIT', 4000.00, 'COMPLETED', 'TXN-000015'),
(1016, 2, DATE_SUB(NOW(), INTERVAL 18 DAY), 'THRIFT', 1500.00, 'COMPLETED', 'TXN-000016'),
(1017, 2, DATE_SUB(NOW(), INTERVAL 12 DAY), 'LOAN_EMI', 4500.00, 'COMPLETED', 'TXN-000017'),
(1018, 2, DATE_SUB(NOW(), INTERVAL 8 DAY), 'DEPOSIT', 2500.00, 'COMPLETED', 'TXN-000018'),
(1019, 2, DATE_SUB(NOW(), INTERVAL 3 DAY), 'THRIFT', 1500.00, 'COMPLETED', 'TXN-000019'),
(1020, 2, DATE_SUB(NOW(), INTERVAL 1 DAY), 'LOAN_EMI', 4500.00, 'COMPLETED', 'TXN-000020');
