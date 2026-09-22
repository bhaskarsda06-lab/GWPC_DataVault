import json
from datetime import datetime

from pyspark.sql import Row


MANIFEST_FILE = (
    "/Volumes/autdbt_vault_prod/"
    "autdbtt/dbt_state/manifest.json"
)

RUN_RESULTS_FILE = (
    "/Volumes/autdbt_vault_prod/"
    "autdbtt/dbt_state/run_results.json"
)

MANIFEST_TABLE = (
    "autdbt_vault_prod.control.dbt_manifest"
)

RUN_RESULTS_TABLE = (
    "autdbt_vault_prod.control.dbt_run_results"
)


def load_json(path):

    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def load_manifest():

    data = load_json(MANIFEST_FILE)

    metadata = data.get("metadata", {})

    invocation_id = metadata.get("invocation_id")
    generated_at = metadata.get("generated_at")

    rows = []

    for unique_id, node in data.get("nodes", {}).items():

        rows.append(
            Row(
                invocation_id=invocation_id,
                generated_at=generated_at,
                node_id=unique_id,
                resource_type=node.get("resource_type"),
                package_name=node.get("package_name"),
                name=node.get("name"),
                database_name=node.get("database"),
                schema_name=node.get("schema"),
                alias_name=node.get("alias"),
                relation_name=node.get("relation_name"),
                materialized=node.get("config", {}).get(
                    "materialized"
                ),
                path=node.get("path"),
                original_file_path=node.get(
                    "original_file_path"
                ),
                unique_id=unique_id,
                depends_on_nodes=node.get(
                    "depends_on", {}
                ).get("nodes", []),
                raw_code=node.get("raw_code"),
                compiled_code=node.get(
                    "compiled_code"
                ),
                checksum=(
                    node.get("checksum", {})
                    .get("checksum")
                ),
                tags=node.get("tags", []),
                loaded_at=datetime.utcnow()
            )
        )

    df = spark.createDataFrame(rows)

    df.write \
        .format("delta") \
        .mode("append") \
        .saveAsTable(MANIFEST_TABLE)


def load_run_results():

    data = load_json(RUN_RESULTS_FILE)

    metadata = data.get("metadata", {})

    invocation_id = metadata.get("invocation_id")
    generated_at = metadata.get("generated_at")

    rows = []

    for result in data.get("results", []):

        adapter_response = result.get(
            "adapter_response"
        )

        rows.append(
            Row(
                invocation_id=invocation_id,
                generated_at=generated_at,
                unique_id=result.get("unique_id"),
                resource_type=result.get(
                    "unique_id", ""
                ).split(".")[0],
                status=result.get("status"),
                execution_time=result.get(
                    "execution_time"
                ),
                thread_id=result.get("thread_id"),
                node_name=result.get("unique_id"),
                database_name=None,
                schema_name=None,
                message=result.get("message"),
                rows_affected=(
                    adapter_response.get("rows_affected")
                    if adapter_response
                    else None
                ),
                adapter_response=json.dumps(
                    adapter_response
                ) if adapter_response else None,
                failures=result.get("failures"),
                run_started_at=None,
                run_completed_at=None,
                loaded_at=datetime.utcnow()
            )
        )

    df = spark.createDataFrame(rows)

    df.write \
        .format("delta") \
        .mode("append") \
        .saveAsTable(RUN_RESULTS_TABLE)


load_manifest()
load_run_results()