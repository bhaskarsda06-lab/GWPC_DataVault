import sys
import json
from datetime import datetime


# ============================================================
# CONFIGURATION
# ============================================================

CATALOG = "autdbt_vault_prod"
SCHEMA = "autdbtt"

MANIFEST_TABLE = f"{CATALOG}.{SCHEMA}.dbt_manifest_artifacts"
RUN_RESULTS_TABLE = f"{CATALOG}.{SCHEMA}.dbt_run_results_artifacts"


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


manifest_df = spark.createDataFrame(
    manifest_record,
    [
        "invocation_id",
        "artifact_type",
        "artifact_json",
        "load_timestamp"
    ]
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
    [
        "invocation_id",
        "artifact_type",
        "artifact_json",
        "load_timestamp"
    ]
)


# ============================================================
# 8. LOAD MANIFEST TABLE
# ============================================================

print("\nLoading manifest table...")

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
# 10. RECONCILIATION
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


print(
    f"Manifest expected : 1"
)

print(
    f"Manifest loaded   : {manifest_loaded}"
)

print(
    f"Run results expected : 1"
)

print(
    f"Run results loaded   : {run_results_loaded}"
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


print("\nRECONCILIATION SUCCESS")


# ============================================================
# 11. CREATE ARCHIVE DIRECTORY
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
# 12. ARCHIVE MANIFEST
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
# 13. ARCHIVE RUN_RESULTS
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
# 14. VERIFY ARCHIVE
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
# 15. FINAL SUCCESS
# ============================================================

print("\n")
print("=" * 80)
print("SUCCESS - DBT ARTIFACT PROCESSING COMPLETED")
print("=" * 80)

print(
    f"Invocation ID : {invocation_id}"
)

print(
    "Loaded:"
)

print(
    "  1. manifest.json"
)

print(
    "  2. run_results.json"
)

print(
    f"\nArchived to:"
)

print(
    archive_dir
)

print("=" * 80)