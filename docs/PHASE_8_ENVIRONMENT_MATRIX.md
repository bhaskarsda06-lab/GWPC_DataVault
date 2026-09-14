# Phase 8 Environment Matrix

| Environment | Branch/Ref | Catalog | Schema | Deployment | Execution |
|---|---|---|---|---|---|
| DEV | develop | autdbt_vault_dev | autdbts | automatic | Databricks |
| TEST | approved commit/ref | autdbt_vault_test | autdbts | manual approval | Databricks |
| PROD | release tag/approved commit | autdbt_vault_prod | autdbts | protected approval | Databricks |

These catalog names are the current project baseline. Replace them if the
actual enterprise Unity Catalog names differ.
