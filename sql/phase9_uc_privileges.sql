-- ============================================================
-- Phase 9 - Unity Catalog production privilege baseline
-- Replace group/service-principal placeholders before execution.
-- Review with your security/data-governance team.
-- ============================================================

-- PROD catalog/schema usage
GRANT USE CATALOG ON CATALOG autdbt_vault_prod TO `GWPC_DV_RUNNER`;
GRANT USE SCHEMA ON SCHEMA autdbt_vault_prod.autdbts TO `GWPC_DV_RUNNER`;

-- Runtime needs to create/modify dbt-managed tables in the target schema.
-- Prefer object-specific grants once the final dbt materialization strategy
-- is approved.
GRANT CREATE TABLE ON SCHEMA autdbt_vault_prod.autdbts TO `GWPC_DV_RUNNER`;
GRANT CREATE VIEW ON SCHEMA autdbt_vault_prod.autdbts TO `GWPC_DV_RUNNER`;

-- Control/audit tables
GRANT SELECT, MODIFY ON TABLE autdbt_vault_prod.autdbts.dv_job_run_control
TO `GWPC_DV_RUNNER`;

GRANT SELECT, MODIFY ON TABLE autdbt_vault_prod.autdbts.dv_job_stage_control
TO `GWPC_DV_RUNNER`;

GRANT SELECT, MODIFY ON TABLE autdbt_vault_prod.autdbts.dv_dq_result
TO `GWPC_DV_RUNNER`;

GRANT SELECT, MODIFY ON TABLE autdbt_vault_prod.autdbts.dv_reconciliation
TO `GWPC_DV_RUNNER`;

-- Read-only operational users should receive SELECT rather than MODIFY.
GRANT USE CATALOG ON CATALOG autdbt_vault_prod TO `GWPC_DV_READERS`;
GRANT USE SCHEMA ON SCHEMA autdbt_vault_prod.autdbts TO `GWPC_DV_READERS`;
GRANT SELECT ON SCHEMA autdbt_vault_prod.autdbts TO `GWPC_DV_READERS`;
