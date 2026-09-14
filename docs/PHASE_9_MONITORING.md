# Phase 9 Monitoring

Use Databricks job monitoring plus system tables.

Useful system tables include:

- `system.lakeflow.jobs`
- job run/task timeline tables where available
- `system.access.audit`
- `system.billing.usage`
- alert system tables where enabled

Databricks documents system tables as the account-level analytical store for
operational observability, including job activity, audit events, usage and
costs.
citeturn0search7turn0search2

Recommended dashboards:

1. Pipeline success rate
2. Failed runs by stage
3. Runtime/SLA trend
4. DQ failure trend
5. Reconciliation differences
6. Job cost trend
7. Warehouse utilization
8. Security/audit activity

Do not export sensitive system-table data unnecessarily.
