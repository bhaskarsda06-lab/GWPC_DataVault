-- ============================================================
-- GWPC Data Vault 2.0 - DEV DEMO INPUT DATA
-- Run AFTER 01_DDL.sql
-- ============================================================

-- Clear previous demo data
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_accountcontactrole_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_accountcontact_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_contact_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_address_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_effectivedatedfields_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_paymentplansummary_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_policycontactrole_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_policyperiod_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_policy_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pc_account_curr;

TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_accountcontactrole_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_accountstatus_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_billingmethod_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_country_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_jurisdiction_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_maritalstatus_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_namesuffix_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_policyperiodstatus_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_state_curr;
TRUNCATE TABLE autdbt_vault_dev.autdbts.pctl_termtype_curr;

-- ============================================================
-- ACCOUNT
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pc_account_curr
VALUES
('ACC001','A10001','John Smith','PERSONAL','ACTIVE',0,current_timestamp(),current_timestamp()),
('ACC002','A10002','Mary Johnson','COMMERCIAL','ACTIVE',0,current_timestamp(),current_timestamp()),
('ACC003','A10003','David Williams','COMMERCIAL','ACTIVE',0,current_timestamp(),current_timestamp()),
('ACC004','A10004','Sarah Brown','PERSONAL','ACTIVE',0,current_timestamp(),current_timestamp()),
('ACC005','A10005','Robert Davis','PERSONAL','ACTIVE',0,current_timestamp(),current_timestamp());

-- ============================================================
-- CONTACT
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pc_contact_curr
VALUES
('CON001',1001,'John','A','Smith','1985-05-10','TAX001','john.smith@example.com','john.smith@example.com','9000000001','CA','US','ADDR001','MR','MARRIED',0,current_timestamp(),current_timestamp()),
('CON002',1002,'Mary','B','Johnson','1988-08-15','TAX002','mary.johnson@example.com','mary.johnson@example.com','9000000002','NY','US','ADDR002','MS','SINGLE',0,current_timestamp(),current_timestamp()),
('CON003',1003,'David',NULL,'Williams','1982-03-20','TAX003','david.williams@example.com','david.williams@example.com','9000000003','TX','US','ADDR003','MR','MARRIED',0,current_timestamp(),current_timestamp()),
('CON004',1004,'Sarah','C','Brown','1990-11-02','TAX004','sarah.brown@example.com','sarah.brown@example.com','9000000004','FL','US','ADDR004','MS','SINGLE',0,current_timestamp(),current_timestamp()),
('CON005',1005,'Robert',NULL,'Davis','1979-01-25','TAX005','robert.davis@example.com','robert.davis@example.com','9000000005','WA','US','ADDR005','MR','MARRIED',0,current_timestamp(),current_timestamp());

-- ============================================================
-- ADDRESS
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pc_address_curr
VALUES
('ADDR001','100 Main Street',NULL,'Los Angeles','CA','CA','90001','US','US',0,current_timestamp(),current_timestamp()),
('ADDR002','200 Park Avenue',NULL,'New York','NY','NY','10001','US','US',0,current_timestamp(),current_timestamp()),
('ADDR003','300 Oak Street',NULL,'Dallas','TX','TX','75001','US','US',0,current_timestamp(),current_timestamp()),
('ADDR004','400 Palm Road',NULL,'Miami','FL','FL','33101','US','US',0,current_timestamp(),current_timestamp()),
('ADDR005','500 Pine Street',NULL,'Seattle','WA','WA','98101','US','US',0,current_timestamp(),current_timestamp());

-- ============================================================
-- ACCOUNT CONTACT
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pc_accountcontact_curr
VALUES
('AC001','ACC001','CON001',0,current_timestamp(),current_timestamp()),
('AC002','ACC002','CON002',0,current_timestamp(),current_timestamp()),
('AC003','ACC003','CON003',0,current_timestamp(),current_timestamp()),
('AC004','ACC004','CON004',0,current_timestamp(),current_timestamp()),
('AC005','ACC005','CON005',0,current_timestamp(),current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pc_accountcontactrole_curr
VALUES
('ACR001','ACC001','CON001','PRIMARY',0,current_timestamp(),current_timestamp()),
('ACR002','ACC002','CON002','PRIMARY',0,current_timestamp(),current_timestamp()),
('ACR003','ACC003','CON003','PRIMARY',0,current_timestamp(),current_timestamp()),
('ACR004','ACC004','CON004','PRIMARY',0,current_timestamp(),current_timestamp()),
('ACR005','ACC005','CON005','PRIMARY',0,current_timestamp(),current_timestamp());

-- ============================================================
-- POLICY
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pc_policy_curr
VALUES
('POL001','P10001','ACC001','AUTO','PERSONAL_AUTO','ACTIVE',0,current_timestamp(),current_timestamp()),
('POL002','P10002','ACC002','PROPERTY','COMMERCIAL_PROPERTY','ACTIVE',0,current_timestamp(),current_timestamp()),
('POL003','P10003','ACC003','GENERAL','COMMERCIAL_GENERAL','ACTIVE',0,current_timestamp(),current_timestamp()),
('POL004','P10004','ACC004','AUTO','PERSONAL_AUTO','CANCELLED',0,current_timestamp(),current_timestamp()),
('POL005','P10005','ACC005','PROPERTY','COMMERCIAL_PROPERTY','ACTIVE',0,current_timestamp(),current_timestamp());

-- ============================================================
-- POLICY PERIOD
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pc_policyperiod_curr
VALUES
('PP001','POL001','P10001',1,1,'2026-01-01','2026-12-31','ACTIVE',0,current_timestamp(),current_timestamp()),
('PP002','POL002','P10002',1,1,'2026-02-01','2027-01-31','ACTIVE',0,current_timestamp(),current_timestamp()),
('PP003','POL003','P10003',1,1,'2026-03-01','2027-02-28','ACTIVE',0,current_timestamp(),current_timestamp()),
('PP004','POL004','P10004',1,1,'2026-04-01','2026-09-30','CANCELLED',0,current_timestamp(),current_timestamp()),
('PP005','POL005','P10005',1,1,'2026-05-01','2027-04-30','ACTIVE',0,current_timestamp(),current_timestamp());

-- ============================================================
-- POLICY CONTACT ROLE
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pc_policycontactrole_curr
VALUES
('PCR001','POL001','CON001','PRIMARY',0,current_timestamp(),current_timestamp()),
('PCR002','POL002','CON002','PRIMARY',0,current_timestamp(),current_timestamp()),
('PCR003','POL003','CON003','PRIMARY',0,current_timestamp(),current_timestamp()),
('PCR004','POL004','CON004','PRIMARY',0,current_timestamp(),current_timestamp()),
('PCR005','POL005','CON005','PRIMARY',0,current_timestamp(),current_timestamp());

-- ============================================================
-- PAYMENT PLAN
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pc_paymentplansummary_curr
VALUES
('PAY001','ACC001','POL001','MONTHLY',1200.00,'USD',0,current_timestamp(),current_timestamp()),
('PAY002','ACC002','POL002','MONTHLY',2500.00,'USD',0,current_timestamp(),current_timestamp()),
('PAY003','ACC003','POL003','QUARTERLY',1800.00,'USD',0,current_timestamp(),current_timestamp()),
('PAY004','ACC004','POL004','MONTHLY',900.00,'USD',0,current_timestamp(),current_timestamp()),
('PAY005','ACC005','POL005','ANNUAL',3000.00,'USD',0,current_timestamp(),current_timestamp());

-- ============================================================
-- EFFECTIVE DATED
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pc_effectivedatedfields_curr
VALUES
('EDF001','POL001','2026-01-01','2026-12-31',0,current_timestamp(),current_timestamp()),
('EDF002','POL002','2026-02-01','2027-01-31',0,current_timestamp(),current_timestamp()),
('EDF003','POL003','2026-03-01','2027-02-28',0,current_timestamp(),current_timestamp()),
('EDF004','POL004','2026-04-01','2026-09-30',0,current_timestamp(),current_timestamp()),
('EDF005','POL005','2026-05-01','2027-04-30',0,current_timestamp(),current_timestamp());

-- ============================================================
-- REFERENCE DATA
-- ============================================================
INSERT INTO autdbt_vault_dev.autdbts.pctl_accountcontactrole_curr
VALUES
('R001','PRIMARY','PRIMARY','Primary Contact','Primary account contact',true,current_timestamp()),
('R002','BILLING','BILLING','Billing Contact','Billing contact',true,current_timestamp()),
('R003','OWNER','OWNER','Owner','Account owner',true,current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pctl_accountstatus_curr
VALUES
('AS001','ACTIVE','Active','Active account',true,current_timestamp()),
('AS002','INACTIVE','Inactive','Inactive account',true,current_timestamp()),
('AS003','CLOSED','Closed','Closed account',true,current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pctl_billingmethod_curr
VALUES
('BM001','DIRECT','Direct Bill','Direct billing',true,current_timestamp()),
('BM002','AGENCY','Agency Bill','Agency billing',true,current_timestamp()),
('BM003','LISTBILL','List Bill','List billing',true,current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pctl_country_curr
VALUES
('C001','US','United States','United States',true,current_timestamp()),
('C002','CA','Canada','Canada',true,current_timestamp()),
('C003','IN','India','India',true,current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pctl_jurisdiction_curr
VALUES
('J001','CA','California','California',true,current_timestamp()),
('J002','NY','New York','New York',true,current_timestamp()),
('J003','TX','Texas','Texas',true,current_timestamp()),
('J004','FL','Florida','Florida',true,current_timestamp()),
('J005','WA','Washington','Washington',true,current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pctl_maritalstatus_curr
VALUES
('M001','MARRIED','Married','Married',true,current_timestamp()),
('M002','SINGLE','Single','Single',true,current_timestamp()),
('M003','DIVORCED','Divorced','Divorced',true,current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pctl_namesuffix_curr
VALUES
('N001','MR','Mr.','Mr.',true,current_timestamp()),
('N002','MS','Ms.','Ms.',true,current_timestamp()),
('N003','DR','Dr.','Dr.',true,current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pctl_policyperiodstatus_curr
VALUES
('PS001','ACTIVE','Active','Active policy period',true,current_timestamp()),
('PS002','CANCELLED','Cancelled','Cancelled policy period',true,current_timestamp()),
('PS003','EXPIRED','Expired','Expired policy period',true,current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pctl_state_curr
VALUES
('S001','CA','California','California',true,current_timestamp()),
('S002','NY','New York','New York',true,current_timestamp()),
('S003','TX','Texas','Texas',true,current_timestamp()),
('S004','FL','Florida','Florida',true,current_timestamp()),
('S005','WA','Washington','Washington',true,current_timestamp());

INSERT INTO autdbt_vault_dev.autdbts.pctl_termtype_curr
VALUES
('T001','ANNUAL','Annual','Annual term',true,current_timestamp()),
('T002','SEMIANNUAL','Semi Annual','Semi annual term',true,current_timestamp()),
('T003','MONTHLY','Monthly','Monthly term',true,current_timestamp());

-- ============================================================
-- QUICK COUNT VERIFICATION
-- ============================================================
SELECT 'pc_account_curr' AS table_name, COUNT(*) AS row_count
FROM autdbt_vault_dev.autdbts.pc_account_curr
UNION ALL
SELECT 'pc_contact_curr', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_contact_curr
UNION ALL
SELECT 'pc_policy_curr', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_policy_curr
UNION ALL
SELECT 'pc_policyperiod_curr', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_policyperiod_curr
UNION ALL
SELECT 'pc_accountcontact_curr', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_accountcontact_curr
UNION ALL
SELECT 'pc_policycontactrole_curr', COUNT(*)
FROM autdbt_vault_dev.autdbts.pc_policycontactrole_curr;
