from __future__ import annotations

import json
import logging
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from pyspark.sql import Row
<<<<<<< HEAD
from pyspark.sql import SparkSession
from pyspark.sql.types import (
    DoubleType,
    LongType,
    StringType,
    StructField,
    StructType,
    TimestampType,
=======
from pyspark.sql.types import (
    StructType, StructField,
    StringType, DoubleType, LongType,
    IntegerType, TimestampType, ArrayType,
)


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
>>>>>>> fdd6530beba5696d9701606e77068092d2a8c2de
)

MANIFEST_SCHEMA = StructType([
    StructField("invocation_id", StringType(), True),
    StructField("generated_at", TimestampType(), True),
    StructField("node_id", StringType(), True),
    StructField("resource_type", StringType(), True),
    StructField("package_name", StringType(), True),
    StructField("name", StringType(), True),
    StructField("database_name", StringType(), True),
    StructField("schema_name", StringType(), True),
    StructField("alias_name", StringType(), True),
    StructField("relation_name", StringType(), True),
    StructField("materialized", StringType(), True),
    StructField("path", StringType(), True),
    StructField("original_file_path", StringType(), True),
    StructField("unique_id", StringType(), True),
    StructField("depends_on_nodes", ArrayType(StringType()), True),
    StructField("raw_code", StringType(), True),
    StructField("compiled_code", StringType(), True),
    StructField("checksum", StringType(), True),
    StructField("tags", ArrayType(StringType()), True),
    StructField("loaded_at", TimestampType(), True),
])

RUN_RESULTS_SCHEMA = StructType([
    StructField("invocation_id", StringType(), True),
    StructField("generated_at", TimestampType(), True),
    StructField("unique_id", StringType(), True),
    StructField("resource_type", StringType(), True),
    StructField("status", StringType(), True),
    StructField("execution_time", DoubleType(), True),
    StructField("thread_id", StringType(), True),
    StructField("node_name", StringType(), True),
    StructField("database_name", StringType(), True),
    StructField("schema_name", StringType(), True),
    StructField("message", StringType(), True),
    StructField("rows_affected", LongType(), True),
    StructField("adapter_response", StringType(), True),
    StructField("failures", IntegerType(), True),
    StructField("run_started_at", TimestampType(), True),
    StructField("run_completed_at", TimestampType(), True),
    StructField("loaded_at", TimestampType(), True),
])


# ============================================================
# Configuration
# ============================================================

spark = SparkSession.getActiveSession()

if spark is None:
    raise RuntimeError("Active Spark session was not found.")


# Change these paths/tables if required
DBT_TARGET_DIR = os.getenv(
    "DBT_TARGET_DIR",
    "/Workspace/Repos/<YOUR_REPO>/target",
)

MANIFEST_FILE = os.path.join(DBT_TARGET_DIR, "manifest.json")
RUN_RESULTS_FILE = os.path.join(DBT_TARGET_DIR, "run_results.json")

MANIFEST_TABLE = os.getenv(
    "MANIFEST_TABLE",
    "audit.dbt_manifest",
)

RUN_RESULTS_TABLE = os.getenv(
    "RUN_RESULTS_TABLE",
    "audit.dbt_run_results",
)


# ============================================================
# Logging
# ============================================================

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)

logger = logging.getLogger("load_dbt_artifacts")


# ============================================================
# Utility Functions
# ============================================================

def utc_now() -> datetime:
    """
    Return timezone-aware UTC datetime.

    Important for Python 3.12+ and Spark TimestampType.
    """
    return datetime.now(timezone.utc)


def parse_timestamp(value: Any) -> datetime | None:
    """
    Convert dbt ISO timestamp values to timezone-aware
    Python datetime objects.

    Supports:
      - None
      - datetime
      - ISO strings
      - strings ending in Z
    """

    if value is None:
        return None

    if isinstance(value, datetime):
        if value.tzinfo is None:
            return value.replace(tzinfo=timezone.utc)

        return value.astimezone(timezone.utc)

    if isinstance(value, str):
        value = value.strip()

        if not value:
            return None

        # dbt commonly uses:
        # 2026-09-22T10:20:30.123456Z
        if value.endswith("Z"):
            value = value[:-1] + "+00:00"

        try:
            parsed = datetime.fromisoformat(value)
        except ValueError as exc:
            raise ValueError(
                f"Invalid timestamp value: {value!r}"
            ) from exc

        if parsed.tzinfo is None:
            parsed = parsed.replace(tzinfo=timezone.utc)

        return parsed.astimezone(timezone.utc)

    raise TypeError(
        f"Unsupported timestamp type: "
        f"{type(value).__name__}; value={value!r}"
    )


def read_json(path: str) -> dict:
    """
    Read JSON file from the Databricks workspace filesystem.
    """

    if not os.path.exists(path):
        raise FileNotFoundError(
            f"DBT artifact file not found: {path}"
        )

    logger.info("Reading: %s", path)

    with open(path, "r", encoding="utf-8") as file:
        return json.load(file)


def get_invocation_id(data: dict) -> str:
    """
    Get dbt invocation ID.

    manifest.json normally contains invocation_id in metadata.
    """

    metadata = data.get("metadata", {})

    invocation_id = metadata.get("invocation_id")

    if invocation_id:
        return str(invocation_id)

    # Fallback for artifacts where invocation_id isn't available.
    generated_at = metadata.get("generated_at")

    if generated_at:
        return str(generated_at)

    return utc_now().strftime("%Y%m%d%H%M%S%f")


# ============================================================
# Schemas
# ============================================================

MANIFEST_SCHEMA = StructType([
    StructField("invocation_id", StringType(), True),
    StructField("unique_id", StringType(), True),
    StructField("resource_type", StringType(), True),
    StructField("package_name", StringType(), True),
    StructField("name", StringType(), True),
    StructField("alias", StringType(), True),
    StructField("database_name", StringType(), True),
    StructField("schema_name", StringType(), True),
    StructField("relation_name", StringType(), True),
    StructField("path", StringType(), True),
    StructField("original_file_path", StringType(), True),
    StructField("generated_at", TimestampType(), True),
    StructField("loaded_at", TimestampType(), True),
])


RUN_RESULTS_SCHEMA = StructType([
    StructField("invocation_id", StringType(), True),
    StructField("unique_id", StringType(), True),
    StructField("status", StringType(), True),
    StructField("resource_type", StringType(), True),
    StructField("execution_time", DoubleType(), True),
    StructField("thread_id", StringType(), True),
    StructField("message", StringType(), True),
    StructField("failures", LongType(), True),
    StructField("started_at", TimestampType(), True),
    StructField("completed_at", TimestampType(), True),
    StructField("loaded_at", TimestampType(), True),
])


# ============================================================
# Manifest Transformation
# ============================================================

def build_manifest_rows(
    data: dict,
    invocation_id: str,
    loaded_at: datetime,
) -> list[Row]:

    metadata = data.get("metadata", {})

    generated_at = parse_timestamp(
        metadata.get("generated_at")
    )

    rows: list[Row] = []

    for unique_id, node in data.get("nodes", {}).items():

        rows.append(
            Row(
                invocation_id=invocation_id,
                unique_id=str(unique_id),
                resource_type=node.get("resource_type"),
                package_name=node.get("package_name"),
                name=node.get("name"),
                alias=node.get("alias"),
                database_name=node.get("database"),
                schema_name=node.get("schema"),
                relation_name=node.get("relation_name"),
                path=node.get("path"),
                original_file_path=node.get(
                    "original_file_path"
                ),
                generated_at=generated_at,
                loaded_at=loaded_at,
            )
        )

<<<<<<< HEAD
    return rows
=======
    df = spark.createDataFrame(rows, schema=MANIFEST_SCHEMA)

    df.write \
        .format("delta") \
        .mode("append") \
        .saveAsTable(MANIFEST_TABLE)
>>>>>>> fdd6530beba5696d9701606e77068092d2a8c2de


# ============================================================
# Run Results Transformation
# ============================================================

def build_run_results_rows(
    data: dict,
    invocation_id: str,
    loaded_at: datetime,
) -> list[Row]:

    rows: list[Row] = []

    for result in data.get("results", []):

        unique_id = result.get("unique_id")

        timing = result.get("timing", [])

        started_at = None
        completed_at = None

        if timing:
            first_timing = timing[0]

            started_at = parse_timestamp(
                first_timing.get("started_at")
            )

            completed_at = parse_timestamp(
                first_timing.get("completed_at")
            )

        execution_time = result.get("execution_time")

        if execution_time is not None:
            execution_time = float(execution_time)

        failures = result.get("failures")

        if failures is not None:
            failures = int(failures)

        rows.append(
            Row(
                invocation_id=invocation_id,
                unique_id=unique_id,
                status=result.get("status"),
                resource_type=result.get("resource_type"),
                execution_time=execution_time,
                thread_id=result.get("thread_id"),
                message=result.get("message"),
                failures=failures,
                started_at=started_at,
                completed_at=completed_at,
                loaded_at=loaded_at,
            )
        )

<<<<<<< HEAD
    return rows
=======
    df = spark.createDataFrame(rows, schema=RUN_RESULTS_SCHEMA)
>>>>>>> fdd6530beba5696d9701606e77068092d2a8c2de


# ============================================================
# Validation
# ============================================================

def validate_timestamp_columns(
    rows: list[Row],
    schema: StructType,
) -> None:

    timestamp_fields = {
        field.name
        for field in schema.fields
        if isinstance(field.dataType, TimestampType)
    }

    for row_number, row in enumerate(rows):

        for field_name in timestamp_fields:

            value = row[field_name]

            if value is not None and not isinstance(
                value,
                datetime,
            ):
                raise TypeError(
                    f"Invalid timestamp in row={row_number}, "
                    f"column={field_name}, "
                    f"value={value!r}, "
                    f"type={type(value).__name__}"
                )


# ============================================================
# Write Manifest
# ============================================================

def load_manifest(
    data: dict,
    invocation_id: str,
    loaded_at: datetime,
) -> int:

    rows = build_manifest_rows(
        data=data,
        invocation_id=invocation_id,
        loaded_at=loaded_at,
    )

    if not rows:
        logger.warning("No manifest nodes found.")
        return 0

    validate_timestamp_columns(
        rows,
        MANIFEST_SCHEMA,
    )

    df = spark.createDataFrame(
        rows,
        schema=MANIFEST_SCHEMA,
    )

    (
        df.write
        .format("delta")
        .mode("append")
        .saveAsTable(MANIFEST_TABLE)
    )

    logger.info(
        "Loaded %d manifest records into %s",
        len(rows),
        MANIFEST_TABLE,
    )

    return len(rows)


# ============================================================
# Write Run Results
# ============================================================

def load_run_results(
    data: dict,
    invocation_id: str,
    loaded_at: datetime,
) -> int:

    rows = build_run_results_rows(
        data=data,
        invocation_id=invocation_id,
        loaded_at=loaded_at,
    )

    if not rows:
        logger.warning("No run results found.")
        return 0

    validate_timestamp_columns(
        rows,
        RUN_RESULTS_SCHEMA,
    )

    df = spark.createDataFrame(
        rows,
        schema=RUN_RESULTS_SCHEMA,
    )

    (
        df.write
        .format("delta")
        .mode("append")
        .saveAsTable(RUN_RESULTS_TABLE)
    )

    logger.info(
        "Loaded %d run-result records into %s",
        len(rows),
        RUN_RESULTS_TABLE,
    )

    return len(rows)


<<<<<<< HEAD
# ============================================================
# Main
# ============================================================

def main() -> None:

    logger.info("========================================")
    logger.info("Starting DBT artifact loader")
    logger.info("========================================")

    loaded_at = utc_now()

    manifest_data = read_json(MANIFEST_FILE)

    run_results_data = read_json(RUN_RESULTS_FILE)

    invocation_id = get_invocation_id(
        manifest_data
    )

    logger.info(
        "Invocation ID: %s",
        invocation_id,
    )

    manifest_count = load_manifest(
        data=manifest_data,
        invocation_id=invocation_id,
        loaded_at=loaded_at,
    )

    run_results_count = load_run_results(
        data=run_results_data,
        invocation_id=invocation_id,
        loaded_at=loaded_at,
    )

    logger.info("========================================")
    logger.info(
        "DBT artifact loading completed successfully"
    )
    logger.info(
        "Manifest records : %d",
        manifest_count,
    )
    logger.info(
        "Run-result records: %d",
        run_results_count,
    )
    logger.info("========================================")


if __name__ == "__main__":
    main()
=======
load_manifest()
load_run_results()
>>>>>>> fdd6530beba5696d9701606e77068092d2a8c2de
