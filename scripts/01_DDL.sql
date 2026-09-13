-- 01_DDL.sql
-- GWPC Data Vault 2.0 development input/source layer for Azure Databricks.
CREATE CATALOG IF NOT EXISTS autdbt_vault_dev;

CREATE SCHEMA IF NOT EXISTS autdbt_vault_dev.autdbts;
CREATE SCHEMA IF NOT EXISTS autdbt_vault_dev.autdbtt;
CREATE SCHEMA IF NOT EXISTS autdbt_vault_dev.raw;
CREATE SCHEMA IF NOT EXISTS autdbt_vault_dev.bronze;
CREATE SCHEMA IF NOT EXISTS autdbt_vault_dev.silver;
CREATE SCHEMA IF NOT EXISTS autdbt_vault_dev.gold;
CREATE SCHEMA IF NOT EXISTS autdbt_vault_dev.audit;

-- Source/current tables referenced by the existing staging models.
CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_account_curr (
 publicid STRING, accountnumber STRING, accountname STRING, accounttype STRING,
 status STRING, createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_accountcontactrole_curr (
 publicid STRING, accountpublicid STRING, contactpublicid STRING, rolecode STRING,
 createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_accountcontact_curr (
 publicid STRING, accountpublicid STRING, contactpublicid STRING,
 createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_address_curr (
 publicid STRING, addressline1 STRING, addressline2 STRING, city STRING,
 statecode STRING, postalcode STRING, countrycode STRING,
 createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_contact_curr (
 publicid STRING, firstname STRING, middlename STRING, lastname STRING,
 email STRING, phone STRING, createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_effectivedatedfields_curr (
 publicid STRING, objectpublicid STRING, effectivedate DATE, expirationdate DATE,
 createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_paymentplansummary_curr (
 publicid STRING, accountpublicid STRING, policypublicid STRING, paymentplan STRING,
 premiumamount DECIMAL(18,2), currencycode STRING,
 createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_policy_curr (
 publicid STRING, policynumber STRING, accountpublicid STRING, productcode STRING,
 policytype STRING, statuscode STRING, createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_policycontactrole_curr (
 publicid STRING, policypublicid STRING, contactpublicid STRING, rolecode STRING,
 createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pc_policyperiod_curr (
 publicid STRING, policypublicid STRING, periodnumber INT, termnumber INT,
 effectivefrom DATE, effectiveto DATE, statuscode STRING,
 createddate TIMESTAMP, updateddate TIMESTAMP) USING DELTA;

-- Reference tables.
CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_accountcontactrole_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_accountstatus_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_billingmethod_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_country_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_maritalstatus_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_jurisdiction_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_namesuffix_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_state_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_termtype_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.autdbts.pctl_policyperiodstatus_curr (
 publicid STRING, code STRING, name STRING, description STRING,
 activeflag BOOLEAN, updateddate TIMESTAMP) USING DELTA;

CREATE TABLE IF NOT EXISTS autdbt_vault_dev.audit.dbt_run_audit (
 run_id STRING, model_name STRING, source_count BIGINT, target_count BIGINT,
 rejected_count BIGINT, run_status STRING, run_start_ts TIMESTAMP,
 run_end_ts TIMESTAMP, error_message STRING) USING DELTA;
