import sys
import json
from datetime import datetime
from pyspark.sql.types import (
    StringType, FloatType, IntegerType, TimestampType,
    StructType, StructField
)


# ============================================================
# CONFIGURATION
# ============================================================

CATALOG = "autdbt_vault_prod"
SCHEMA = "autdbtt"

MANIFEST_TABLE = f"{CATALOG}.{SCHEMA}.dbt_manifest_artifacts"
RUN_RESULTS_TABLE = f"{CATALOG}.{SCHEMA}.dbt_run_results_artifacts"
EXECUTION_SUMMARY_TABLE = f"{CATALOG}.{SCHEMA}.dbt_execution_summary"
MODEL_EXECUTIONS_TABLE = f"{CATALOG}.{SCHEMA}.dbt_model_executions"


# ============================================================
# 1. GET DBT_TARGET_DIR
# ============================================================

if len(sys.argv) < 2:
    raise RuntimeError(
        "DBT_TARGET_DIR parameter is missing."
    )

DBT_TARGET_DIR = sys.argv[1].rstrip("/")

print("=" * 80)
print("GWPC DataVault PROD")
print("DBT Artifact Loader")
print("=" * 80)

print(f"DBT_TARGET_DIR : {DBT_TARGET_DIR}")


# ============================================================
# 2. FILE PATHS
# ============================================================

MANIFEST_FILE = f"{DBT_TARGET_DIR}/manifest.json"

RUN_RESULTS_FILE = f"{DBT_TARGET_DIR}/run_results.json"

ARCHIVE_ROOT = (
    f"{DBT_TARGET_DIR}/control_files/archive"
)

print(f"MANIFEST      : {MANIFEST_FILE}")
print(f"RUN_RESULTS   : {RUN_RESULTS_FILE}")
print(f"ARCHIVE ROOT  : {ARCHIVE_ROOT}")


# ============================================================
# 3. FILE EXISTENCE CHECK
# ============================================================

def file_exists(path):

    try:
        dbutils.fs.ls(path)
        return True

    except Exception:
        return False


if not file_exists(MANIFEST_FILE):

    raise RuntimeError(
        f"manifest.json not found:\n{MANIFEST_FILE}"
    )


if not file_exists(RUN_RESULTS_FILE):

    raise RuntimeError(
        f"run_results.json not found:\n{RUN_RESULTS_FILE}"
    )


print("\nBoth artifact files found.")


# ============================================================
# 4. READ JSON FROM VOLUME
# ============================================================

def read_json_file(path):

    try:

        content = dbutils.fs.head(
            path,
            134217728
        )

        return json.loads(content)

    except Exception as e:

        raise RuntimeError(
            f"Unable to read JSON file:\n"
            f"{path}\n\n"
            f"Error: {str(e)}"
        )


print("\nReading manifest.json...")

manifest = read_json_file(
    MANIFEST_FILE
)

print("manifest.json read successfully.")


print("\nReading run_results.json...")

run_results = read_json_file(
    RUN_RESULTS_FILE
)

print("run_results.json read successfully.")


# ============================================================
# 5. GET INVOCATION ID
# ============================================================

manifest_metadata = manifest.get(
    "metadata",
    {}
)

run_metadata = run_results.get(
    "metadata",
    {}
)

run_args = run_results.get(
    "args",
    {}
)

invocation_id = (
    run_args.get("invocation_id")
    or run_metadata.get("invocation_id")
    or manifest_metadata.get("invocation_id")
)


# Fallback if invocation_id is not available

if not invocation_id:

    invocation_id = datetime.now().strftime(
        "%Y%m%d_%H%M%S"
    )


print(f"\nInvocation ID : {invocation_id}")


# ============================================================
# 6. CREATE RECORD FOR MANIFEST
# ============================================================

load_timestamp = datetime.now()

manifest_record = [(
    invocation_id,
    "manifest",
    json.dumps(
        manifest,
        default=str
    ),
    load_timestamp
)]

manifest_schema = StructType([
    StructField("invocation_id", StringType(), True),
    StructField("artifact_type", StringType(), True),
    StructField("artifact_json", StringType(), True),
    StructField("load_timestamp", TimestampType(), True),
])

manifest_df = spark.createDataFrame(
    manifest_record,
    manifest_schema
)


# ============================================================
# 7. CREATE RECORD FOR RUN_RESULTS
# ============================================================

run_results_record = [(
    invocation_id,
    "run_results",
    json.dumps(
        run_results,
        default=str
    ),
    load_timestamp
)]

run_results_df = spark.createDataFrame(
    run_results_record,
    manifest_schema
)


# ============================================================
# 8. LOAD MANIFEST TABLE
# ============================================================

print("\nLoading manifest table...")

# Remove existing rows for this invocation_id to ensure idempotency on retries
spark.sql(
    f"DELETE FROM {MANIFEST_TABLE} "
    f"WHERE invocation_id = '{invocation_id}'"
)

manifest_df.write \
    .format("delta") \
    .mode("append") \
    .saveAsTable(
        MANIFEST_TABLE
    )

print(
    f"Loaded: {MANIFEST_TABLE}"
)


# ============================================================
# 9. LOAD RUN_RESULTS TABLE
# ============================================================

print("\nLoading run_results table...")

# Remove existing rows for this invocation_id to ensure idempotency on retries
spark.sql(
    f"DELETE FROM {RUN_RESULTS_TABLE} "
    f"WHERE invocation_id = '{invocation_id}'"
)

run_results_df.write \
    .format("delta") \
    .mode("append") \
    .saveAsTable(
        RUN_RESULTS_TABLE
    )

print(
    f"Loaded: {RUN_RESULTS_TABLE}"
)


# ============================================================
# 10. PARSE EXECUTION SUMMARY
# ============================================================

print("\n" + "=" * 80)
print("PARSING EXECUTION SUMMARY")
print("=" * 80)


def parse_timestamp(ts_str):
    """Parse an ISO-8601 timestamp string to datetime."""
    if not ts_str:
        return None
    try:
        return datetime.fromisoformat(
            ts_str.replace("Z", "+00:00")
        )
    except Exception:
        return None


results = run_results.get("results", [])

models_total = 0
models_success = 0
models_failed = 0
models_skipped = 0
models_warn = 0

tests_total = 0
tests_pass = 0
tests_fail = 0
tests_warn = 0
tests_skipped = 0

error_messages = []

for r in results:
    unique_id = r.get("unique_id", "")
    status = (r.get("status") or "").lower()
    resource_type = (
        unique_id.split(".")[0] if "." in unique_id else "unknown"
    )

    if resource_type == "model":
        models_total += 1
        if status == "success":
            models_success += 1
        elif status in ("error", "fail"):
            models_failed += 1
            msg = r.get("message", "")
            if msg:
                error_messages.append(
                    f"{unique_id}: {msg}"
                )
        elif status == "skip":
            models_skipped += 1
        elif status == "warn":
            models_warn += 1

    elif resource_type == "test":
        tests_total += 1
        if status in ("pass", "success"):
            tests_pass += 1
        elif status in ("error", "fail"):
            tests_fail += 1
            msg = r.get("message", "")
            if msg:
                error_messages.append(
                    f"{unique_id}: {msg}"
                )
        elif status == "warn":
            tests_warn += 1
        elif status == "skip":
            tests_skipped += 1


if models_failed > 0 or tests_fail > 0:
    overall_status = "FAILED"
elif models_warn > 0 or tests_warn > 0:
    overall_status = "PARTIAL"
else:
    overall_status = "SUCCESS"


error_message = (
    "\n".join(error_messages[:20])
    if error_messages else None
)


dbt_command = (
    run_args.get("invocation_command") or "unknown"
)

dbt_version = run_metadata.get("dbt_version", "")

invocation_started_at = parse_timestamp(
    run_metadata.get("invocation_started_at")
)

invocation_completed_at = parse_timestamp(
    run_metadata.get("generated_at")
)

elapsed_time = run_results.get("elapsed_time", 0.0)


job_id = ""
job_run_id = ""
task_run_id = ""

for r in results:
    adapter = r.get("adapter_response", {}) or {}
    job_id = adapter.get("job_id", "") or job_id
    job_run_id = adapter.get("job_run_id", "") or job_run_id
    task_run_id = adapter.get("task_run_id", "") or task_run_id
    if job_id and job_run_id:
        break


print(f"dbt_command          : {dbt_command}")
print(f"dbt_version          : {dbt_version}")
print(f"invocation_started_at: {invocation_started_at}")
print(f"invocation_completed_at: {invocation_completed_at}")
print(f"elapsed_time         : {elapsed_time}")
print(f"models_total         : {models_total}")
print(f"models_success       : {models_success}")
print(f"models_failed        : {models_failed}")
print(f"models_skipped       : {models_skipped}")
print(f"models_warn          : {models_warn}")
print(f"tests_total          : {tests_total}")
print(f"tests_pass           : {tests_pass}")
print(f"tests_fail           : {tests_fail}")
print(f"tests_warn           : {tests_warn}")
print(f"tests_skipped        : {tests_skipped}")
print(f"overall_status       : {overall_status}")
print(f"job_id               : {job_id}")
print(f"job_run_id           : {job_run_id}")
print(f"task_run_id          : {task_run_id}")


summary_record = [(
    invocation_id,
    job_id,
    job_run_id,
    task_run_id,
    dbt_command,
    dbt_version,
    invocation_started_at,
    invocation_completed_at,
    float(elapsed_time),
    models_total,
    models_success,
    models_failed,
    models_skipped,
    models_warn,
    tests_total,
    tests_pass,
    tests_fail,
    tests_warn,
    tests_skipped,
    overall_status,
    error_message,
    load_timestamp
)]


summary_schema = StructType([
    StructField("invocation_id", StringType(), True),
    StructField("job_id", StringType(), True),
    StructField("job_run_id", StringType(), True),
    StructField("task_run_id", StringType(), True),
    StructField("dbt_command", StringType(), True),
    StructField("dbt_version", StringType(), True),
    StructField("invocation_started_at", TimestampType(), True),
    StructField("invocation_completed_at", TimestampType(), True),
    StructField("elapsed_time", FloatType(), True),
    StructField("models_total", IntegerType(), True),
    StructField("models_success", IntegerType(), True),
    StructField("models_failed", IntegerType(), True),
    StructField("models_skipped", IntegerType(), True),
    StructField("models_warn", IntegerType(), True),
    StructField("tests_total", IntegerType(), True),
    StructField("tests_pass", IntegerType(), True),
    StructField("tests_fail", IntegerType(), True),
    StructField("tests_warn", IntegerType(), True),
    StructField("tests_skipped", IntegerType(), True),
    StructField("overall_status", StringType(), True),
    StructField("error_message", StringType(), True),
    StructField("loaded_at", TimestampType(), True),
])

summary_df = spark.createDataFrame(
    summary_record,
    summary_schema
)


# ============================================================
# 11. LOAD EXECUTION SUMMARY TABLE
# ============================================================

print("\nLoading execution summary table...")

# Remove existing rows for this invocation_id to ensure idempotency on retries
spark.sql(
    f"DELETE FROM {EXECUTION_SUMMARY_TABLE} "
    f"WHERE invocation_id = '{invocation_id}'"
)

summary_df.write \
    .format("delta") \
    .mode("append") \
    .saveAsTable(
        EXECUTION_SUMMARY_TABLE
    )

print(
    f"Loaded: {EXECUTION_SUMMARY_TABLE}"
)


# ============================================================
# 12. PARSE MODEL EXECUTIONS
# ============================================================

print("\n" + "=" * 80)
print("PARSING MODEL EXECUTIONS")
print("=" * 80)


def extract_timing(timing_list, name):
    """Extract started_at and completed_at for a given timing name."""
    if not timing_list:
        return None, None
    for t in timing_list:
        if t.get("name") == name:
            return (
                parse_timestamp(t.get("started_at")),
                parse_timestamp(t.get("completed_at"))
            )
    return None, None


model_execution_records = []

for r in results:
    unique_id = r.get("unique_id", "")
    status = (r.get("status") or "").lower()

    resource_type = (
        unique_id.split(".")[0] if "." in unique_id
        else "unknown"
    )

    resource_name = (
        unique_id.split(".")[-1] if "." in unique_id
        else unique_id
    )

    execution_time = r.get("execution_time", 0.0)

    compile_started, compile_completed = extract_timing(
        r.get("timing"), "compile"
    )
    execute_started, execute_completed = extract_timing(
        r.get("timing"), "execute"
    )

    adapter = r.get("adapter_response", {}) or {}
    adapter_message = adapter.get("_message", "")
    query_id = adapter.get("query_id", "")

    failures = r.get("failures")
    if failures is None:
        failures = 0

    message = r.get("message", "")

    model_execution_records.append((
        invocation_id,
        resource_type,
        unique_id,
        resource_name,
        status,
        float(execution_time),
        compile_started,
        compile_completed,
        execute_started,
        execute_completed,
        adapter_message,
        query_id,
        int(failures),
        message,
        load_timestamp
    ))


print(
    f"Total execution records: "
    f"{len(model_execution_records)}"
)


model_executions_schema = StructType([
    StructField("invocation_id", StringType(), True),
    StructField("resource_type", StringType(), True),
    StructField("unique_id", StringType(), True),
    StructField("resource_name", StringType(), True),
    StructField("status", StringType(), True),
    StructField("execution_time", FloatType(), True),
    StructField("compile_started_at", TimestampType(), True),
    StructField("compile_completed_at", TimestampType(), True),
    StructField("execute_started_at", TimestampType(), True),
    StructField("execute_completed_at", TimestampType(), True),
    StructField("adapter_message", StringType(), True),
    StructField("query_id", StringType(), True),
    StructField("failures", IntegerType(), True),
    StructField("message", StringType(), True),
    StructField("loaded_at", TimestampType(), True),
])

model_executions_df = spark.createDataFrame(
    model_execution_records,
    model_executions_schema
)


# ============================================================
# 13. LOAD MODEL EXECUTIONS TABLE
# ============================================================

print("\nLoading model executions table...")

# Remove existing rows for this invocation_id to ensure idempotency on retries
spark.sql(
    f"DELETE FROM {MODEL_EXECUTIONS_TABLE} "
    f"WHERE invocation_id = '{invocation_id}'"
)

model_executions_df.write \
    .format("delta") \
    .mode("append") \
    .saveAsTable(
        MODEL_EXECUTIONS_TABLE
    )

print(
    f"Loaded: {MODEL_EXECUTIONS_TABLE}"
)


# ============================================================
# 14. RECONCILIATION
# ============================================================

print("\n" + "=" * 80)
print("RECONCILIATION")
print("=" * 80)


manifest_loaded = spark.table(
    MANIFEST_TABLE
).filter(
    f"invocation_id = '{invocation_id}'"
).filter(
    "artifact_type = 'manifest'"
).count()


run_results_loaded = spark.table(
    RUN_RESULTS_TABLE
).filter(
    f"invocation_id = '{invocation_id}'"
).filter(
    "artifact_type = 'run_results'"
).count()

summary_loaded = spark.table(
    EXECUTION_SUMMARY_TABLE
).filter(
    f"invocation_id = '{invocation_id}'"
).count()

model_executions_loaded = spark.table(
    MODEL_EXECUTIONS_TABLE
).filter(
    f"invocation_id = '{invocation_id}'"
).count()


print(
    f"Manifest expected       : 1"
)

print(
    f"Manifest loaded         : {manifest_loaded}"
)

print(
    f"Run results expected    : 1"
)

print(
    f"Run results loaded      : {run_results_loaded}"
)

print(
    f"Summary expected         : 1"
)

print(
    f"Summary loaded          : {summary_loaded}"
)

print(
    f"Model executions expected: {len(model_execution_records)}"
)

print(
    f"Model executions loaded  : {model_executions_loaded}"
)


if manifest_loaded != 1:

    raise RuntimeError(
        "Manifest reconciliation failed. "
        "Files will NOT be archived."
    )


if run_results_loaded != 1:

    raise RuntimeError(
        "Run results reconciliation failed. "
        "Files will NOT be archived."
    )


if summary_loaded != 1:

    raise RuntimeError(
        "Execution summary reconciliation failed. "
        "Files will NOT be archived."
    )


if model_executions_loaded != len(model_execution_records):

    raise RuntimeError(
        "Model executions reconciliation failed. "
        "Files will NOT be archived."
    )


print("\nRECONCILIATION SUCCESS")


# ============================================================
# 15. CREATE ARCHIVE DIRECTORY
# ============================================================

archive_dir = (
    f"{ARCHIVE_ROOT}/{invocation_id}"
)

print(
    f"\nCreating archive directory:\n"
    f"{archive_dir}"
)

try:

    dbutils.fs.mkdirs(
        archive_dir
    )

except Exception as e:

    raise RuntimeError(
        f"Unable to create archive directory:\n"
        f"{archive_dir}\n"
        f"Error: {str(e)}"
    )


# ============================================================
# 16. ARCHIVE MANIFEST
# ============================================================

print("\nArchiving manifest.json...")

try:

    dbutils.fs.mv(
        MANIFEST_FILE,
        f"{archive_dir}/manifest.json"
    )

except Exception as e:

    raise RuntimeError(
        f"Failed to archive manifest.json.\n"
        f"Original: {MANIFEST_FILE}\n"
        f"Error: {str(e)}"
    )


# ============================================================
# 17. ARCHIVE RUN_RESULTS
# ============================================================

print("Archiving run_results.json...")

try:

    dbutils.fs.mv(
        RUN_RESULTS_FILE,
        f"{archive_dir}/run_results.json"
    )

except Exception as e:

    raise RuntimeError(
        f"Failed to archive run_results.json.\n"
        f"Original: {RUN_RESULTS_FILE}\n"
        f"Error: {str(e)}"
    )


# ============================================================
# 18. VERIFY ARCHIVE
# ============================================================

archived_manifest = (
    f"{archive_dir}/manifest.json"
)

archived_run_results = (
    f"{archive_dir}/run_results.json"
)


if not file_exists(
    archived_manifest
):

    raise RuntimeError(
        "Archive validation failed: "
        "manifest.json not found."
    )


if not file_exists(
    archived_run_results
):

    raise RuntimeError(
        "Archive validation failed: "
        "run_results.json not found."
    )


# ============================================================
# 19. FINAL SUCCESS
# ============================================================

print("\n")
print("=" * 80)
print("SUCCESS - DBT ARTIFACT PROCESSING COMPLETED")
print("=" * 80)

print(
    f"Invocation ID : {invocation_id}"
)

print(
    f"Overall Status: {overall_status}"
)

print(
    f"Models: {models_success} success, "
    f"{models_failed} failed, "
    f"{models_skipped} skipped, "
    f"{models_warn} warn"
)

print(
    f"Tests: {tests_pass} pass, "
    f"{tests_fail} fail, "
    f"{tests_warn} warn, "
    f"{tests_skipped} skipped"
)

print(
    "Loaded:"
)

print(
    f"  1. {MANIFEST_TABLE}"
)

print(
    f"  2. {RUN_RESULTS_TABLE}"
)

print(
    f"  3. {EXECUTION_SUMMARY_TABLE}"
)

print(
    f"  4. {MODEL_EXECUTIONS_TABLE}"
)

print(
    f"\nArchived to:"
)

print(
    archive_dir
)

print("=" * 80)
