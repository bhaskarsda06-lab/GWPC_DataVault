# Phase 2 Execution Order

Run in this order:

1. Confirm Phase 1 is complete.
2. Copy `profiles.yml.example` to your user `.dbt` directory as `profiles.yml`.
3. Replace workspace and warehouse placeholders.
4. Run `dbt deps`.
5. Run `dbt debug --target dev`.
6. Run `dbt parse --target dev`.
7. Run `dbt ls --target dev`.
8. Run `dbt build --select tag:staging --target dev`.
9. Verify staging views in Databricks.
10. Run the staging tests again if needed.

Expected logical flow:

GWPC source
    |
    v
dbt source()
    |
    v
stg_* views
    |
    v
Phase 3 Hubs
