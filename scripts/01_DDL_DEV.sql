-- ============================================================
-- GWPC Data Vault 2.0 - DEV DEMO DDL
-- Catalog : autdbt_vault
-- Source  : autdbt_vault.autdbts
-- Target  : autdbt_vault.autdbtt
-- ============================================================

CREATE CATALOG IF NOT EXISTS autdbt_vault;

CREATE SCHEMA IF NOT EXISTS autdbt_vault.autdbts;
CREATE SCHEMA IF NOT EXISTS autdbt_vault.autdbtt;
CREATE SCHEMA IF NOT EXISTS autdbt_vault.raw;
CREATE SCHEMA IF NOT EXISTS autdbt_vault.bronze;
CREATE SCHEMA IF NOT EXISTS autdbt_vault.silver;
CREATE SCHEMA IF NOT EXISTS autdbt_vault.gold;
CREATE SCHEMA IF NOT EXISTS autdbt_vault.audit;

-- ------------------------------------------------------------
-- Account
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_account_curr (
    publicid STRING,
    accountnumber STRING,
    accountname STRING,
    accounttype STRING,
    status STRING,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

-- ------------------------------------------------------------
-- Account Contact
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_accountcontactrole_curr (
    publicid STRING,
    accountpublicid STRING,
    contactpublicid STRING,
    rolecode STRING,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_accountcontact_curr (
    publicid STRING,
    accountpublicid STRING,
    contactpublicid STRING,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

-- ------------------------------------------------------------
-- Contact
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_contact_curr (
    publicid STRING,
    id BIGINT,
    firstname STRING,
    middlename STRING,
    lastname STRING,
    dateofbirth DATE,
    taxid STRING,
    email STRING,
    emailaddress1 STRING,
    phone STRING,
    state STRING,
    country STRING,
    primaryaddressid STRING,
    suffix STRING,
    maritalstatus STRING,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

-- ------------------------------------------------------------
-- Address
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_address_curr (
    publicid STRING,
    addressline1 STRING,
    addressline2 STRING,
    city STRING,
    statecode STRING,
    state STRING,
    postalcode STRING,
    countrycode STRING,
    country STRING,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

-- ------------------------------------------------------------
-- Effective-dated fields
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_effectivedatedfields_curr (
    publicid STRING,
    objectpublicid STRING,
    effectivedate DATE,
    expirationdate DATE,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

-- ------------------------------------------------------------
-- Payment Plan
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_paymentplansummary_curr (
    publicid STRING,
    accountpublicid STRING,
    policypublicid STRING,
    paymentplan STRING,
    premiumamount DECIMAL(18,2),
    currencycode STRING,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

-- ------------------------------------------------------------
-- Policy
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_policy_curr (
    publicid STRING,
    policynumber STRING,
    accountpublicid STRING,
    productcode STRING,
    policytype STRING,
    statuscode STRING,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_policycontactrole_curr (
    publicid STRING,
    policypublicid STRING,
    contactpublicid STRING,
    rolecode STRING,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

-- ------------------------------------------------------------
-- Policy Period
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pc_policyperiod_curr (
    publicid STRING,
    policypublicid STRING,
    policynumber STRING,
    periodnumber INT,
    termnumber INT,
    effectivefrom DATE,
    effectiveto DATE,
    statuscode STRING,
    retired BIGINT,
    createddate TIMESTAMP,
    updateddate TIMESTAMP
) USING DELTA;

-- ------------------------------------------------------------
-- Reference tables
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_accountcontactrole_curr (
    publicid STRING,
    code STRING,
    typecode STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_accountstatus_curr (
    publicid STRING,
    code STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_billingmethod_curr (
    publicid STRING,
    code STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_country_curr (
    publicid STRING,
    code STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_jurisdiction_curr (
    publicid STRING,
    code STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_maritalstatus_curr (
    publicid STRING,
    code STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_namesuffix_curr (
    publicid STRING,
    code STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_policyperiodstatus_curr (
    publicid STRING,
    code STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_state_curr (
    publicid STRING,
    code STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault.autdbts.pctl_termtype_curr (
    publicid STRING,
    code STRING,
    name STRING,
    description STRING,
    activeflag BOOLEAN,
    updateddate TIMESTAMP
) USING DELTA;

-- ------------------------------------------------------------
-- Audit
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS autdbt_vault.audit.dbt_run_audit (
    run_id STRING,
    model_name STRING,
    source_count BIGINT,
    target_count BIGINT,
    rejected_count BIGINT,
    run_status STRING,
    run_start_ts TIMESTAMP,
    run_end_ts TIMESTAMP,
    error_message STRING
) USING DELTA;
