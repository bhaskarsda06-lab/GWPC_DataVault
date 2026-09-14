-- Phase 10.7 Unity Catalog security review queries.
-- Run these only with an authorized security/admin identity.
-- READ ONLY. These queries inspect metadata; they do not change grants.

-- 1. Catalog grants
SHOW GRANTS ON CATALOG autdbt_vault_prod;

-- 2. Vault schema grants
SHOW GRANTS ON SCHEMA autdbt_vault_prod.autdbtt;

-- 3. Staging schema grants
SHOW GRANTS ON SCHEMA autdbt_vault_prod.autdbtt_autdbts;

-- 4. Production object grants
SHOW GRANTS ON TABLE autdbt_vault_prod.autdbtt.hub_account;
SHOW GRANTS ON TABLE autdbt_vault_prod.autdbtt.hub_contact;
SHOW GRANTS ON TABLE autdbt_vault_prod.autdbtt.hub_policy;
SHOW GRANTS ON TABLE autdbt_vault_prod.autdbtt.bridge_policy_account_contact;

-- Review the results against your organization's approved IAM matrix.
-- Do not paste secrets into tickets or logs.
