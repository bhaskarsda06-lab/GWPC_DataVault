from __future__ import annotations

import json
import logging
import os
from datetime import datetime, timezone
from typing import Any

from pyspark.sql import Row, SparkSession
from pyspark.sql.types import (
    DoubleType,
    LongType,
    StringType,
    StructField,
    StructType,
    TimestampType,
)


# ============================================================
# SPARK SESSION
# ============================================================

spark = SparkSession.getActiveSession()

if spark is None:
    raise RuntimeError("Active Spark session was not found.")


# ============================================================
# CONFIGURATION
# ============================================================
#
# Recommended:
# Set DBT_TARGET_DIR as a Databricks Job environment variable.
#
# Example:
# DBT_TARGET_DIR=/Volumes/<catalog>/<schema>/dbt_artifacts
#
# Or, if target is actually inside your repo:
# DBT_TARGET_DIR=/Workspace/Repos/<user>/<repo>/target
#
# Do NOT use /Workspace/Repos/<YOUR_REPO>/target.
#

DBT_TARGET_DIR = os.getenv("DBT_TARGET_DIR")

if not DBT_TARGET_DIR:
    raise RuntimeError(
        "DBT_TARGET_DIR is not configured. "
        "Set DBT_TARGET_DIR to the directory containing "
        "manifest.json and run_results.json."
    )

MANIFEST_FILE = os.path.join(
    DBT_TARGET_DIR,
    "manifest.json",
)

RUN_RESULTS_FILE = os.path.join(
    DBT_TARGET_DIR,
    "run_results.json",
)

MANIFEST_TABLE = os.getenv(
    "MANIFEST_TABLE",
    "audit.dbt_manifest",
)

RUN_RESULTS_TABLE = os.getenv(
    "RUN_RESULTS_TABLE",
    "audit.dbt_run_results",
)


# ============================================================
# LOGGING
# ============================================================

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)

logger = logging.getLogger("dbt-artifact-loader")


# ============================================================
# SCHEMAS
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
# UTC TIMESTAMP
# ============================================================

def utc_now() -> datetime:
    """
    Return timezone-aware UTC datetime.

    Compatible with Python 3.12+ and Spark TimestampType.
    """
    return datetime.now(timezone.utc)


# ============================================================
# TIMESTAMP CONVERSION
# ============================================================

def parse_timestamp(value: Any) -> datetime | None:
    """
    Convert dbt timestamp values into timezone-aware
    Python datetime objects.

    Handles:
      None
      datetime
      ISO-8601 strings
      strings ending in Z
    """

    if value is None:
        return None

    if isinstance(value, datetime):

        if value.tzinfo is None:
            return value.replace(
                tzinfo=timezone.utc
            )

        return value.astimezone(timezone.utc)

    if isinstance(value, str):

        value = value.strip()

        if not value:
            return None

        if value.endswith("Z"):
            value = value[:-1] + "+00:00"

        try:
            parsed = datetime.fromisoformat(value)

        except ValueError as exc:
            raise ValueError(
                f"Invalid timestamp value: {value!r}"
            ) from exc

        if parsed.tzinfo is None:
            parsed = parsed.replace(
                tzinfo=timezone.utc
            )

        return parsed.astimezone(timezone.utc)

    raise TypeError(
        f"Unsupported timestamp type: "
        f"{type(value).__name__}; value={value!r}"
    )


# ============================================================
# FILE VALIDATION
# ============================================================

def validate_artifact_files() -> None:

    logger.info(
        "DBT target directory: %s",
        DBT_TARGET_DIR,
    )

    if not os.path.isdir(DBT_TARGET_DIR):
        raise FileNotFoundError(
            f"DBT target directory does not exist: "
            f"{DBT_TARGET_DIR}"
        )

    if not os.path.isfile(MANIFEST_FILE):
        raise FileNotFoundError(
            f"DBT manifest.json not found: "
            f"{MANIFEST_FILE}"
        )

    if not os.path.isfile(RUN_RESULTS_FILE):
        raise FileNotFoundError(
            f"DBT run_results.json not found: "
            f"{RUN_RESULTS_FILE}"
        )


# ============================================================
# JSON READER
# ============================================================

def read_json(path: str) -> dict:

    logger.info(
        "Reading artifact: %s",
        path,
    )

    with open(
        path,
        "r",
        encoding="utf-8",
    ) as file:

        return json.load(file)


# ============================================================
# INVOCATION ID
# ============================================================

def get_invocation_id(
    manifest: dict,
) -> str:

    invocation_id = (
        manifest
        .get("metadata", {})
        .get("invocation_id")
    )

    if not invocation_id:
        raise ValueError(
            "manifest.json does not contain "
            "metadata.invocation_id"
        )

    return str(invocation_id)


# ============================================================
# MANIFEST ROW BUILDER
# ============================================================

def build_manifest_rows(
    manifest: dict,
    invocation_id: str,
    loaded_at: datetime,
) -> list[Row]:

    metadata = manifest.get(
        "metadata",
        {},
    )

    generated_at = parse_timestamp(
        metadata.get("generated_at")
    )

    rows: list[Row] = []

    for unique_id, node in manifest.get(
        "nodes",
        {},
    ).items():

        rows.append(
            Row(
                invocation_id=invocation_id,
                unique_id=str(unique_id),
                resource_type=node.get(
                    "resource_type"
                ),
                package_name=node.get(
                    "package_name"
                ),
                name=node.get(
                    "name"
                ),
                alias=node.get(
                    "alias"
                ),
                database_name=node.get(
                    "database"
                ),
                schema_name=node.get(
                    "schema"
                ),
                relation_name=node.get(
                    "relation_name"
                ),
                path=node.get(
                    "path"
                ),
                original_file_path=node.get(
                    "original_file_path"
                ),
                generated_at=generated_at,
                loaded_at=loaded_at,
            )
        )

    return rows


# ============================================================
# RUN RESULTS ROW BUILDER
# ============================================================

def build_run_result_rows(
    run_results: dict,
    invocation_id: str,
    loaded_at: datetime,
) -> list[Row]:

    rows: list[Row] = []

    for result in run_results.get(
        "results",
        [],
    ):

        timing = result.get(
            "timing"
        ) or []

        started_at = None
        completed_at = None

        if timing:

            started_at = parse_timestamp(
                timing[0].get(
                    "started_at"
                )
            )

            completed_at = parse_timestamp(
                timing[0].get(
                    "completed_at"
                )
            )

        execution_time = result.get(
            "execution_time"
        )

        if execution_time is not None:
            execution_time = float(
                execution_time
            )

        failures = result.get(
            "failures"
        )

        if failures is not None:
            failures = int(failures)

        rows.append(
            Row(
                invocation_id=invocation_id,
                unique_id=result.get(
                    "unique_id"
                ),
                status=result.get(
                    "status"
                ),
                resource_type=result.get(
                    "resource_type"
                ),
                execution_time=execution_time,
                thread_id=result.get(
                    "thread_id"
                ),
                message=result.get(
                    "message"
                ),
                failures=failures,
                started_at=started_at,
                completed_at=completed_at,
                loaded_at=loaded_at,
            )
        )

    return rows


# ============================================================
# TIMESTAMP VALIDATION
# ============================================================

def validate_rows(
    rows: list[Row],
    schema: StructType,
) -> None:

    timestamp_columns = {
        field.name
        for field in schema.fields
        if isinstance(
            field.dataType,
            TimestampType,
        )
    }

    for row_number, row in enumerate(rows):

        for column in timestamp_columns:

            value = row[column]

            if (
                value is not None
                and not isinstance(
                    value,
                    datetime,
                )
            ):

                raise TypeError(
                    f"Invalid timestamp: "
                    f"row={row_number}, "
                    f"column={column}, "
                    f"value={value!r}, "
                    f"type={type(value).__name__}"
                )


# ============================================================
# CREATE TABLES
# ============================================================

def ensure_tables() -> None:

    logger.info(
        "Checking artifact tables..."
    )

    spark.sql(
        f"""
        CREATE TABLE IF NOT EXISTS
        {MANIFEST_TABLE}
        USING DELTA
        AS
        SELECT
            CAST(NULL AS STRING)
                AS invocation_id,
            CAST(NULL AS STRING)
                AS unique_id,
            CAST(NULL AS STRING)
                AS resource_type,
            CAST(NULL AS STRING)
                AS package_name,
            CAST(NULL AS STRING)
                AS name,
            CAST(NULL AS STRING)
                AS alias,
            CAST(NULL AS STRING)
                AS database_name,
            CAST(NULL AS STRING)
                AS schema_name,
            CAST(NULL AS STRING)
                AS relation_name,
            CAST(NULL AS STRING)
                AS path,
            CAST(NULL AS STRING)
                AS original_file_path,
            CAST(NULL AS TIMESTAMP)
                AS generated_at,
            CAST(NULL AS TIMESTAMP)
                AS loaded_at
        WHERE FALSE
        """
    )

    spark.sql(
        f"""
        CREATE TABLE IF NOT EXISTS
        {RUN_RESULTS_TABLE}
        USING DELTA
        AS
        SELECT
            CAST(NULL AS STRING)
                AS invocation_id,
            CAST(NULL AS STRING)
                AS unique_id,
            CAST(NULL AS STRING)
                AS status,
            CAST(NULL AS STRING)
                AS resource_type,
            CAST(NULL AS DOUBLE)
                AS execution_time,
            CAST(NULL AS STRING)
                AS thread_id,
            CAST(NULL AS STRING)
                AS message,
            CAST(NULL AS BIGINT)
                AS failures,
            CAST(NULL AS TIMESTAMP)
                AS started_at,
            CAST(NULL AS TIMESTAMP)
                AS completed_at,
            CAST(NULL AS TIMESTAMP)
                AS loaded_at
        WHERE FALSE
        """
    )


# ============================================================
# LOAD MANIFEST
# ============================================================

def load_manifest(
    manifest: dict,
    invocation_id: str,
    loaded_at: datetime,
) -> int:

    rows = build_manifest_rows(
        manifest=manifest,
        invocation_id=invocation_id,
        loaded_at=loaded_at,
    )

    if not rows:
        logger.warning(
            "manifest.json contains no nodes."
        )
        return 0

    validate_rows(
        rows,
        MANIFEST_SCHEMA,
    )

    df = spark.createDataFrame(
        rows,
        schema=MANIFEST_SCHEMA,
    )

    df.createOrReplaceTempView(
        "dbt_manifest_stage"
    )

    spark.sql(
        f"""
        MERGE INTO {MANIFEST_TABLE} AS target

        USING dbt_manifest_stage AS source

        ON target.invocation_id =
               source.invocation_id

        AND target.unique_id =
               source.unique_id

        WHEN MATCHED THEN UPDATE SET
            target.resource_type =
                source.resource_type,

            target.package_name =
                source.package_name,

            target.name =
                source.name,

            target.alias =
                source.alias,

            target.database_name =
                source.database_name,

            target.schema_name =
                source.schema_name,

            target.relation_name =
                source.relation_name,

            target.path =
                source.path,

            target.original_file_path =
                source.original_file_path,

            target.generated_at =
                source.generated_at,

            target.loaded_at =
                source.loaded_at

        WHEN NOT MATCHED THEN INSERT (
            invocation_id,
            unique_id,
            resource_type,
            package_name,
            name,
            alias,
            database_name,
            schema_name,
            relation_name,
            path,
            original_file_path,
            generated_at,
            loaded_at
        )

        VALUES (
            source.invocation_id,
            source.unique_id,
            source.resource_type,
            source.package_name,
            source.name,
            source.alias,
            source.database_name,
            source.schema_name,
            source.relation_name,
            source.path,
            source.original_file_path,
            source.generated_at,
            source.loaded_at
        )
        """
    )

    logger.info(
        "Manifest loaded: %d records",
        len(rows),
    )

    return len(rows)


# ============================================================
# LOAD RUN RESULTS
# ============================================================

def load_run_results(
    run_results: dict,
    invocation_id: str,
    loaded_at: datetime,
) -> int:

    rows = build_run_result_rows(
        run_results=run_results,
        invocation_id=invocation_id,
        loaded_at=loaded_at,
    )

    if not rows:
        logger.warning(
            "run_results.json contains no results."
        )
        return 0

    validate_rows(
        rows,
        RUN_RESULTS_SCHEMA,
    )

    df = spark.createDataFrame(
        rows,
        schema=RUN_RESULTS_SCHEMA,
    )

    df.createOrReplaceTempView(
        "dbt_run_results_stage"
    )

    spark.sql(
        f"""
        MERGE INTO {RUN_RESULTS_TABLE} AS target

        USING dbt_run_results_stage AS source

        ON target.invocation_id =
               source.invocation_id

        AND target.unique_id =
               source.unique_id

        WHEN MATCHED THEN UPDATE SET
            target.status =
                source.status,

            target.resource_type =
                source.resource_type,

            target.execution_time =
                source.execution_time,

            target.thread_id =
                source.thread_id,

            target.message =
                source.message,

            target.failures =
                source.failures,

            target.started_at =
                source.started_at,

            target.completed_at =
                source.completed_at,

            target.loaded_at =
                source.loaded_at

        WHEN NOT MATCHED THEN INSERT (
            invocation_id,
            unique_id,
            status,
            resource_type,
            execution_time,
            thread_id,
            message,
            failures,
            started_at,
            completed_at,
            loaded_at
        )

        VALUES (
            source.invocation_id,
            source.unique_id,
            source.status,
            source.resource_type,
            source.execution_time,
            source.thread_id,
            source.message,
            source.failures,
            source.started_at,
            source.completed_at,
            source.loaded_at
        )
        """
    )

    logger.info(
        "Run results loaded: %d records",
        len(rows),
    )

    return len(rows)


# ============================================================
# MAIN
# ============================================================

def main() -> None:

    logger.info(
        "========================================"
    )

    logger.info(
        "Starting production DBT artifact loader"
    )

    logger.info(
        "========================================"
    )

    loaded_at = utc_now()

    # --------------------------------------------------------
    # 1. Validate files
    # --------------------------------------------------------

    validate_artifact_files()

    # --------------------------------------------------------
    # 2. Read dbt artifacts
    # --------------------------------------------------------

    manifest_data = read_json(
        MANIFEST_FILE
    )

    run_results_data = read_json(
        RUN_RESULTS_FILE
    )

    # --------------------------------------------------------
    # 3. Get invocation ID
    # --------------------------------------------------------

    invocation_id = get_invocation_id(
        manifest_data
    )

    logger.info(
        "DBT invocation_id: %s",
        invocation_id,
    )

    # --------------------------------------------------------
    # 4. Ensure Delta tables
    # --------------------------------------------------------

    ensure_tables()

    # --------------------------------------------------------
    # 5. Load manifest
    # --------------------------------------------------------

    manifest_count = load_manifest(
        manifest=manifest_data,
        invocation_id=invocation_id,
        loaded_at=loaded_at,
    )

    # --------------------------------------------------------
    # 6. Load run results
    # --------------------------------------------------------

    run_results_count = load_run_results(
        run_results=run_results_data,
        invocation_id=invocation_id,
        loaded_at=loaded_at,
    )

    # --------------------------------------------------------
    # 7. Summary
    # --------------------------------------------------------

    logger.info(
        "========================================"
    )

    logger.info(
        "DBT artifact load completed successfully"
    )

    logger.info(
        "Invocation ID    : %s",
        invocation_id,
    )

    logger.info(
        "Manifest records : %d",
        manifest_count,
    )

    logger.info(
        "Run result records: %d",
        run_results_count,
    )

    logger.info(
        "========================================"
    )


# ============================================================
# ENTRY POINT
# ============================================================

if __name__ == "__main__":
    main()