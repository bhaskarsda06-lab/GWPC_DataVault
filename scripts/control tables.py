import json
from datetime import datetime

MANIFEST_FILE = "/Volumes/autdbt_vault_prod/dbt_artifacts/target/manifest.json"
RUN_RESULTS_FILE = "/Volumes/autdbt_vault_prod/dbt_artifacts/target/run_results.json"

manifest_rows = []
result_rows = []

# ============================================================
# READ MANIFEST
# ============================================================

with open(MANIFEST_FILE, "r", encoding="utf-8") as f:
    manifest = json.load(f)

invocation_id = manifest.get("metadata", {}).get("invocation_id")
generated_at = datetime.now()

for unique_id, node in manifest.get("nodes", {}).items():

    resource_type = node.get("resource_type")

    if resource_type not in ("model", "test"):
        continue

    database_name = node.get("database")
    schema_name = node.get("schema")
    alias = node.get("alias")

    relation_name = None

    if database_name and schema_name and alias:
        relation_name = (
            f"{database_name}.{schema_name}.{alias}"
        )

    depends_on = json.dumps(
        node.get("depends_on", {}).get("nodes", [])
    )

    manifest_rows.append((
        invocation_id,
        unique_id,
        resource_type,
        node.get("name"),
        database_name,
        schema_name,
        alias,
        relation_name,
        node.get("config", {}).get("materialized"),
        depends_on,
        generated_at
    ))


# ============================================================
# READ RUN_RESULTS
# ============================================================

with open(RUN_RESULTS_FILE, "r", encoding="utf-8") as f:
    run_results = json.load(f)

result_invocation_id = (
    run_results.get("metadata", {})
    .get("invocation_id")
)

for result in run_results.get("results", []):

    unique_id = result.get("unique_id", "")

    resource_type = unique_id.split(".", 1)[0]

    result_rows.append((
        result_invocation_id,
        unique_id,
        resource_type,
        result.get("status"),
        result.get("execution_time"),
        result.get("message"),
        generated_at
    ))


# ============================================================
# WRITE MANIFEST TABLE
# ============================================================

manifest_df = spark.createDataFrame(
    manifest_rows,
    [
        "invocation_id",
        "unique_id",
        "resource_type",
        "name",
        "database_name",
        "schema_name",
        "alias",
        "relation_name",
        "materialized",
        "depends_on",
        "generated_at"
    ]
)

manifest_df.write.mode("append").saveAsTable(
    "control.dbt_manifest"
)


# ============================================================
# WRITE RUN RESULTS TABLE
# ============================================================

result_df = spark.createDataFrame(
    result_rows,
    [
        "invocation_id",
        "unique_id",
        "resource_type",
        "status",
        "execution_time",
        "message",
        "generated_at"
    ]
)

result_df.write.mode("append").saveAsTable(
    "control.dbt_run_results"
)


print(
    f"Manifest rows loaded = {len(manifest_rows)}"
)

print(
    f"Run result rows loaded = {len(result_rows)}"
)

print(
    f"Invocation ID = {invocation_id}"
)