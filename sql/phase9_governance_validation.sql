-- Phase 9 governance validation queries

-- Object inventory
SELECT table_catalog, table_schema, table_name, table_type
FROM system.information_schema.tables
WHERE table_catalog IN ('autdbt_vault_dev','autdbt_vault_test','autdbt_vault_prod')
ORDER BY table_catalog, table_schema, table_name;

-- Current grants (run with sufficient privileges)
SHOW GRANTS ON CATALOG autdbt_vault_prod;
SHOW GRANTS ON SCHEMA autdbt_vault_prod.autdbts;

-- Production control tables
SELECT * FROM autdbt_vault_prod.autdbts.dv_job_run_control
ORDER BY updated_ts DESC
LIMIT 100;
