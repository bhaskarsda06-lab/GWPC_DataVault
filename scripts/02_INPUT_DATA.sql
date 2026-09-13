-- 02_INPUT_DATA.sql
-- GWPC Data Vault 2.0 - DEMO input data
-- Run AFTER 01_DDL.sql.
-- This script clears and reloads the DEMO source tables.

USE CATALOG autdbt_vault_dev;

-- ============================================================
-- CLEAR DEMO DATA
-- ============================================================

DELETE FROM autdbts.pc_account_curr;
DELETE FROM autdbts.pc_accountcontactrole_curr;
DELETE FROM autdbts.pc_accountcontact_curr;
DELETE FROM autdbts.pc_address_curr;
DELETE FROM autdbts.pc_contact_curr;
DELETE FROM autdbts.pc_effectivedatedfields_curr;
DELETE FROM autdbts.pc_paymentplansummary_curr;
DELETE FROM autdbts.pc_policy_curr;
DELETE FROM autdbts.pc_policycontactrole_curr;
DELETE FROM autdbts.pc_policyperiod_curr;

DELETE FROM autdbts.pctl_accountcontactrole_curr;
DELETE FROM autdbts.pctl_accountstatus_curr;
DELETE FROM autdbts.pctl_billingmethod_curr;
DELETE FROM autdbts.pctl_country_curr;
DELETE FROM autdbts.pctl_maritalstatus_curr;
DELETE FROM autdbts.pctl_jurisdiction_curr;
DELETE FROM autdbts.pctl_namesuffix_curr;
DELETE FROM autdbts.pctl_state_curr;
DELETE FROM autdbts.pctl_termtype_curr;
DELETE FROM autdbts.pctl_policyperiodstatus_curr;

-- ============================================================
-- PC_ACCOUNT
-- retired = 0 means active/non-retired
-- retired = 1 means retired
-- ============================================================

INSERT INTO autdbts.pc_account_curr
(publicid, accountnumber, accountname, accounttype, status, createddate, updateddate, retired)
VALUES
('ACC001','A10001','Acme Insurance Customer','INDIVIDUAL','ACTIVE',TIMESTAMP '2026-01-10 09:00:00',TIMESTAMP '2026-09-01 10:00:00',0),
('ACC002','A10002','Global Manufacturing LLC','COMMERCIAL','ACTIVE',TIMESTAMP '2026-01-11 09:30:00',TIMESTAMP '2026-09-02 11:00:00',0),
('ACC003','A10003','Sunrise Retail Group','COMMERCIAL','ACTIVE',TIMESTAMP '2026-01-12 10:00:00',TIMESTAMP '2026-09-03 12:00:00',0),
('ACC004','A10004','John Smith','INDIVIDUAL','INACTIVE',TIMESTAMP '2026-01-13 11:00:00',TIMESTAMP '2026-09-04 13:00:00',0),
('ACC005','A10005','BlueSky Logistics','COMMERCIAL','ACTIVE',TIMESTAMP '2026-01-14 12:00:00',TIMESTAMP '2026-09-05 14:00:00',0);

-- ============================================================
-- PC_CONTACT
-- ============================================================

INSERT INTO autdbts.pc_contact_curr
(publicid, firstname, middlename, lastname, email, phone, createddate, updateddate, retired)
VALUES
('CON001','John','A','Smith','john.smith@example.com','9000000001',TIMESTAMP '2026-01-10 09:00:00',TIMESTAMP '2026-09-01 10:00:00',0),
('CON002','Mary','B','Johnson','mary.johnson@example.com','9000000002',TIMESTAMP '2026-01-11 09:30:00',TIMESTAMP '2026-09-02 11:00:00',0),
('CON003','David',NULL,'Williams','david.williams@example.com','9000000003',TIMESTAMP '2026-01-12 10:00:00',TIMESTAMP '2026-09-03 12:00:00',0),
('CON004','Sarah','C','Brown','sarah.brown@example.com','9000000004',TIMESTAMP '2026-01-13 11:00:00',TIMESTAMP '2026-09-04 13:00:00',0),
('CON005','Robert',NULL,'Davis','robert.davis@example.com','9000000005',TIMESTAMP '2026-01-14 12:00:00',TIMESTAMP '2026-09-05 14:00:00',0);

-- ============================================================
-- ACCOUNT CONTACT
-- ============================================================

INSERT INTO autdbts.pc_accountcontact_curr
(publicid, accountpublicid, contactpublicid, createddate, updateddate)
VALUES
('AC001','ACC001','CON001',TIMESTAMP '2026-01-10 09:00:00',TIMESTAMP '2026-09-01 10:00:00'),
('AC002','ACC002','CON002',TIMESTAMP '2026-01-11 09:30:00',TIMESTAMP '2026-09-02 11:00:00'),
('AC003','ACC003','CON003',TIMESTAMP '2026-01-12 10:00:00',TIMESTAMP '2026-09-03 12:00:00'),
('AC004','ACC004','CON004',TIMESTAMP '2026-01-13 11:00:00',TIMESTAMP '2026-09-04 13:00:00'),
('AC005','ACC005','CON005',TIMESTAMP '2026-01-14 12:00:00',TIMESTAMP '2026-09-05 14:00:00');

-- ============================================================
-- ACCOUNT CONTACT ROLE
-- ============================================================

INSERT INTO autdbts.pc_accountcontactrole_curr
(publicid, accountpublicid, contactpublicid, rolecode, createddate, updateddate, retired)
VALUES
('ACR001','ACC001','CON001','PRIMARY',TIMESTAMP '2026-01-10 09:00:00',TIMESTAMP '2026-09-01 10:00:00',0),
('ACR002','ACC002','CON002','PRIMARY',TIMESTAMP '2026-01-11 09:30:00',TIMESTAMP '2026-09-02 11:00:00',0),
('ACR003','ACC003','CON003','PRIMARY',TIMESTAMP '2026-01-12 10:00:00',TIMESTAMP '2026-09-03 12:00:00',0),
('ACR004','ACC004','CON004','SECONDARY',TIMESTAMP '2026-01-13 11:00:00',TIMESTAMP '2026-09-04 13:00:00',0),
('ACR005','ACC005','CON005','PRIMARY',TIMESTAMP '2026-01-14 12:00:00',TIMESTAMP '2026-09-05 14:00:00',0);

-- ============================================================
-- ADDRESS
-- ============================================================

INSERT INTO autdbts.pc_address_curr
(publicid, addressline1, addressline2, city, statecode, postalcode, countrycode, createddate, updateddate)
VALUES
('ADR001','100 Main Street',NULL,'New York','NY','10001','US',TIMESTAMP '2026-01-10 09:00:00',TIMESTAMP '2026-09-01 10:00:00'),
('ADR002','200 Market Street','Suite 10','Chicago','IL','60601','US',TIMESTAMP '2026-01-11 09:30:00',TIMESTAMP '2026-09-02 11:00:00'),
('ADR003','300 Lake Road',NULL,'Dallas','TX','75201','US',TIMESTAMP '2026-01-12 10:00:00',TIMESTAMP '2026-09-03 12:00:00'),
('ADR004','400 Oak Avenue',NULL,'Boston','MA','02108','US',TIMESTAMP '2026-01-13 11:00:00',TIMESTAMP '2026-09-04 13:00:00'),
('ADR005','500 Pine Boulevard','Floor 2','Seattle','WA','98101','US',TIMESTAMP '2026-01-14 12:00:00',TIMESTAMP '2026-09-05 14:00:00');

-- ============================================================
-- POLICY
-- ============================================================

INSERT INTO autdbts.pc_policy_curr
(publicid, policynumber, accountpublicid, productcode, policytype, statuscode, createddate, updateddate, retired)
VALUES
('POL001','P10001','ACC001','AUTO','PERSONAL_AUTO','ACTIVE',TIMESTAMP '2026-02-01 09:00:00',TIMESTAMP '2026-09-01 10:00:00',0),
('POL002','P10002','ACC002','PROPERTY','COMMERCIAL_PROPERTY','ACTIVE',TIMESTAMP '2026-02-02 09:00:00',TIMESTAMP '2026-09-02 11:00:00',0),
('POL003','P10003','ACC003','GENERAL','COMMERCIAL_GENERAL','ACTIVE',TIMESTAMP '2026-02-03 09:00:00',TIMESTAMP '2026-09-03 12:00:00',0),
('POL004','P10004','ACC004','AUTO','PERSONAL_AUTO','CANCELLED',TIMESTAMP '2026-02-04 09:00:00',TIMESTAMP '2026-09-04 13:00:00',0),
('POL005','P10005','ACC005','PROPERTY','COMMERCIAL_PROPERTY','ACTIVE',TIMESTAMP '2026-02-05 09:00:00',TIMESTAMP '2026-09-05 14:00:00',0);

-- ============================================================
-- POLICY CONTACT ROLE
-- ============================================================

INSERT INTO autdbts.pc_policycontactrole_curr
(publicid, policypublicid, contactpublicid, rolecode, createddate, updateddate, retired)
VALUES
('PCR001','POL001','CON001','INSURED',TIMESTAMP '2026-02-01 09:00:00',TIMESTAMP '2026-09-01 10:00:00',0),
('PCR002','POL002','CON002','INSURED',TIMESTAMP '2026-02-02 09:00:00',TIMESTAMP '2026-09-02 11:00:00',0),
('PCR003','POL003','CON003','INSURED',TIMESTAMP '2026-02-03 09:00:00',TIMESTAMP '2026-09-03 12:00:00',0),
('PCR004','POL004','CON004','INSURED',TIMESTAMP '2026-02-04 09:00:00',TIMESTAMP '2026-09-04 13:00:00',0),
('PCR005','POL005','CON005','INSURED',TIMESTAMP '2026-02-05 09:00:00',TIMESTAMP '2026-09-05 14:00:00',0);

-- ============================================================
-- POLICY PERIOD
-- ============================================================

INSERT INTO autdbts.pc_policyperiod_curr
(publicid, policypublicid, periodnumber, termnumber, effectivefrom, effectiveto, statuscode, createddate, updateddate, retired)
VALUES
('PP001','POL001',1,1,DATE '2026-01-01',DATE '2026-12-31','ACTIVE',TIMESTAMP '2026-01-01 09:00:00',TIMESTAMP '2026-09-01 10:00:00',0),
('PP002','POL002',1,1,DATE '2026-02-01',DATE '2027-01-31','ACTIVE',TIMESTAMP '2026-02-01 09:00:00',TIMESTAMP '2026-09-02 11:00:00',0),
('PP003','POL003',1,1,DATE '2026-03-01',DATE '2027-02-28','ACTIVE',TIMESTAMP '2026-03-01 09:00:00',TIMESTAMP '2026-09-03 12:00:00',0),
('PP004','POL004',1,1,DATE '2026-04-01',DATE '2026-09-30','CANCELLED',TIMESTAMP '2026-04-01 09:00:00',TIMESTAMP '2026-09-04 13:00:00',0),
('PP005','POL005',1,1,DATE '2026-05-01',DATE '2027-04-30','ACTIVE',TIMESTAMP '2026-05-01 09:00:00',TIMESTAMP '2026-09-05 14:00:00',0);

-- ============================================================
-- PAYMENT PLAN SUMMARY
-- ============================================================

INSERT INTO autdbts.pc_paymentplansummary_curr
(publicid, accountpublicid, policypublicid, paymentplan, premiumamount, currencycode, createddate, updateddate, retired)
VALUES
('PAY001','ACC001','POL001','MONTHLY',1200.00,'USD',TIMESTAMP '2026-02-01 09:00:00',TIMESTAMP '2026-09-01 10:00:00',0),
('PAY002','ACC002','POL002','QUARTERLY',5000.00,'USD',TIMESTAMP '2026-02-02 09:00:00',TIMESTAMP '2026-09-02 11:00:00',0),
('PAY003','ACC003','POL003','MONTHLY',3500.00,'USD',TIMESTAMP '2026-02-03 09:00:00',TIMESTAMP '2026-09-03 12:00:00',0),
('PAY004','ACC004','POL004','MONTHLY',900.00,'USD',TIMESTAMP '2026-02-04 09:00:00',TIMESTAMP '2026-09-04 13:00:00',0),
('PAY005','ACC005','POL005','ANNUAL',12000.00,'USD',TIMESTAMP '2026-02-05 09:00:00',TIMESTAMP '2026-09-05 14:00:00',0);

-- ============================================================
-- EFFECTIVE DATED FIELDS
-- ============================================================

INSERT INTO autdbts.pc_effectivedatedfields_curr
(publicid, objectpublicid, effectivedate, expirationdate, createddate, updateddate)
VALUES
('EDF001','POL001',DATE '2026-01-01',DATE '2026-12-31',TIMESTAMP '2026-01-01 09:00:00',TIMESTAMP '2026-09-01 10:00:00'),
('EDF002','POL002',DATE '2026-02-01',DATE '2027-01-31',TIMESTAMP '2026-02-01 09:00:00',TIMESTAMP '2026-09-02 11:00:00'),
('EDF003','POL003',DATE '2026-03-01',DATE '2027-02-28',TIMESTAMP '2026-03-01 09:00:00',TIMESTAMP '2026-09-03 12:00:00'),
('EDF004','POL004',DATE '2026-04-01',DATE '2026-09-30',TIMESTAMP '2026-04-01 09:00:00',TIMESTAMP '2026-09-04 13:00:00'),
('EDF005','POL005',DATE '2026-05-01',DATE '2027-04-30',TIMESTAMP '2026-05-05 09:00:00',TIMESTAMP '2026-09-05 14:00:00');

-- ============================================================
-- REFERENCE DATA
-- typecode is intentionally included because the staging model expects it.
-- ============================================================

INSERT INTO autdbts.pctl_accountcontactrole_curr
(publicid, code, typecode, name, description, activeflag, updateddate)
VALUES
('R001','PRIMARY','PRIMARY','Primary Contact','Primary account contact',true,TIMESTAMP '2026-09-01 10:00:00'),
('R002','SECONDARY','SECONDARY','Secondary Contact','Secondary account contact',true,TIMESTAMP '2026-09-01 10:00:00'),
('R003','AUTHORIZED','AUTHORIZED','Authorized Contact','Authorized account contact',true,TIMESTAMP '2026-09-01 10:00:00');

INSERT INTO autdbts.pctl_accountstatus_curr
(publicid, code, name, description, activeflag, updateddate)
VALUES
('AS001','ACTIVE','Active','Active account',true,TIMESTAMP '2026-09-01 10:00:00'),
('AS002','INACTIVE','Inactive','Inactive account',true,TIMESTAMP '2026-09-01 10:00:00'),
('AS003','CLOSED','Closed','Closed account',true,TIMESTAMP '2026-09-01 10:00:00');

INSERT INTO autdbts.pctl_billingmethod_curr
(publicid, code, name, description, activeflag, updateddate)
VALUES
('BM001','DIRECT','Direct Bill','Direct customer billing',true,TIMESTAMP '2026-09-01 10:00:00'),
('BM002','AGENCY','Agency Bill','Agency billing',true,TIMESTAMP '2026-09-01 10:00:00'),
('BM003','MORTGAGE','Mortgage','Mortgage billing',true,TIMESTAMP '2026-09-01 10:00:00');

INSERT INTO autdbts.pctl_country_curr
(publicid, code, name, description, activeflag, updateddate)
VALUES
('COU001','US','United States','United States of America',true,TIMESTAMP '2026-09-01 10:00:00'),
('COU002','CA','Canada','Canada',true,TIMESTAMP '2026-09-01 10:00:00'),
('COU003','IN','India','India',true,TIMESTAMP '2026-09-01 10:00:00');

INSERT INTO autdbts.pctl_maritalstatus_curr
(publicid, code, name, description, activeflag, updateddate)
VALUES
('MS001','SINGLE','Single','Single',true,TIMESTAMP '2026-09-01 10:00:00'),
('MS002','MARRIED','Married','Married',true,TIMESTAMP '2026-09-01 10:00:00'),
('MS003','DIVORCED','Divorced','Divorced',true,TIMESTAMP '2026-09-01 10:00:00');

INSERT INTO autdbts.pctl_jurisdiction_curr
(publicid, code, name, description, activeflag, updateddate)
VALUES
('J001','NY','New York','New York jurisdiction',true,TIMESTAMP '2026-09-01 10:00:00'),
('J002','IL','Illinois','Illinois jurisdiction',true,TIMESTAMP '2026-09-01 10:00:00'),
('J003','TX','Texas','Texas jurisdiction',true,TIMESTAMP '2026-09-01 10:00:00'),
('J004','MA','Massachusetts','Massachusetts jurisdiction',true,TIMESTAMP '2026-09-01 10:00:00'),
('J005','WA','Washington','Washington jurisdiction',true,TIMESTAMP '2026-09-01 10:00:00');

INSERT INTO autdbts.pctl_namesuffix_curr
(publicid, code, name, description, activeflag, updateddate)
VALUES
('NS001','JR','Jr','Junior',true,TIMESTAMP '2026-09-01 10:00:00'),
('NS002','SR','Sr','Senior',true,TIMESTAMP '2026-09-01 10:00:00'),
('NS003','III','III','Third',true,TIMESTAMP '2026-09-01 10:00:00');

INSERT INTO autdbts.pctl_state_curr
(publicid, code, name, description, activeflag, updateddate)
VALUES
('ST001','NY','New York','New York',true,TIMESTAMP '2026-09-01 10:00:00'),
('ST002','IL','Illinois','Illinois',true,TIMESTAMP '2026-09-01 10:00:00'),
('ST003','TX','Texas','Texas',true,TIMESTAMP '2026-09-01 10:00:00'),
('ST004','MA','Massachusetts','Massachusetts',true,TIMESTAMP '2026-09-01 10:00:00'),
('ST005','WA','Washington','Washington',true,TIMESTAMP '2026-09-01 10:00:00');

INSERT INTO autdbts.pctl_termtype_curr
(publicid, code, name, description, activeflag, updateddate)
VALUES
('TT001','ANNUAL','Annual','Annual policy term',true,TIMESTAMP '2026-09-01 10:00:00'),
('TT002','SEMI_ANNUAL','Semi Annual','Six month policy term',true,TIMESTAMP '2026-09-01 10:00:00'),
('TT003','MONTHLY','Monthly','Monthly policy term',true,TIMESTAMP '2026-09-01 10:00:00');

INSERT INTO autdbts.pctl_policyperiodstatus_curr
(publicid, code, name, description, activeflag, updateddate)
VALUES
('PPS001','ACTIVE','Active','Active policy period',true,TIMESTAMP '2026-09-01 10:00:00'),
('PPS002','CANCELLED','Cancelled','Cancelled policy period',true,TIMESTAMP '2026-09-01 10:00:00'),
('PPS003','EXPIRED','Expired','Expired policy period',true,TIMESTAMP '2026-09-01 10:00:00');

-- ============================================================
-- BASIC VALIDATION
-- ============================================================

SELECT 'pc_account_curr' AS table_name, COUNT(*) AS row_count FROM autdbts.pc_account_curr
UNION ALL SELECT 'pc_accountcontactrole_curr', COUNT(*) FROM autdbts.pc_accountcontactrole_curr
UNION ALL SELECT 'pc_accountcontact_curr', COUNT(*) FROM autdbts.pc_accountcontact_curr
UNION ALL SELECT 'pc_address_curr', COUNT(*) FROM autdbts.pc_address_curr
UNION ALL SELECT 'pc_contact_curr', COUNT(*) FROM autdbts.pc_contact_curr
UNION ALL SELECT 'pc_effectivedatedfields_curr', COUNT(*) FROM autdbts.pc_effectivedatedfields_curr
UNION ALL SELECT 'pc_paymentplansummary_curr', COUNT(*) FROM autdbts.pc_paymentplansummary_curr
UNION ALL SELECT 'pc_policy_curr', COUNT(*) FROM autdbts.pc_policy_curr
UNION ALL SELECT 'pc_policycontactrole_curr', COUNT(*) FROM autdbts.pc_policycontactrole_curr
UNION ALL SELECT 'pc_policyperiod_curr', COUNT(*) FROM autdbts.pc_policyperiod_curr
UNION ALL SELECT 'pctl_accountcontactrole_curr', COUNT(*) FROM autdbts.pctl_accountcontactrole_curr
UNION ALL SELECT 'pctl_accountstatus_curr', COUNT(*) FROM autdbts.pctl_accountstatus_curr
UNION ALL SELECT 'pctl_billingmethod_curr', COUNT(*) FROM autdbts.pctl_billingmethod_curr
UNION ALL SELECT 'pctl_country_curr', COUNT(*) FROM autdbts.pctl_country_curr
UNION ALL SELECT 'pctl_maritalstatus_curr', COUNT(*) FROM autdbts.pctl_maritalstatus_curr
UNION ALL SELECT 'pctl_jurisdiction_curr', COUNT(*) FROM autdbts.pctl_jurisdiction_curr
UNION ALL SELECT 'pctl_namesuffix_curr', COUNT(*) FROM autdbts.pctl_namesuffix_curr
UNION ALL SELECT 'pctl_state_curr', COUNT(*) FROM autdbts.pctl_state_curr
UNION ALL SELECT 'pctl_termtype_curr', COUNT(*) FROM autdbts.pctl_termtype_curr
UNION ALL SELECT 'pctl_policyperiodstatus_curr', COUNT(*) FROM autdbts.pctl_policyperiodstatus_curr;
