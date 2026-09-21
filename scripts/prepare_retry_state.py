import argparse
import io
import os
import shutil
import tarfile
import tempfile
from pathlib import Path

import requests
from databricks.sdk import WorkspaceClient


STATE_VOLUME = "dbfs:/Volumes/audtdbt_vault_prod/audtdbt/dbt_state"
LOCAL_STATE = "/local_disk0/dbt_retry_state"


def get_artifact_url(task_run_id: int):
    """
    Get the archived dbt artifacts URL from the individual dbt task run.
    """
    w = WorkspaceClient()

    output = w.jobs.get_run_output(run_id=task_run_id)

    if output.dbt_output is None:
        raise RuntimeError(
            f"Run {task_run_id} does not contain dbt_output."
        )

    artifacts_link = output.dbt_output.artifacts_link

    if not artifacts_link:
        raise RuntimeError(
            f"No artifacts_link returned for dbt task run {task_run_id}."
        )

    headers = {}

    if output.dbt_output.artifacts_headers:
        headers.update(output.dbt_output.artifacts_headers)

    return artifacts_link, headers


def download_and_extract(url, headers):
    """
    Download dbt-output.tar.gz and extract it to local disk.
    """
    if os.path.exists(LOCAL_STATE):
        shutil.rmtree(LOCAL_STATE)

    os.makedirs(LOCAL_STATE, exist_ok=True)

    print("Downloading dbt artifacts...")

    response = requests.get(
        url,
        headers=headers,
        timeout=300,
    )

    response.raise_for_status()

    print(f"Downloaded {len(response.content):,} bytes")

    with tarfile.open(
        fileobj=io.BytesIO(response.content),
        mode="r:gz",
    ) as tar:
        tar.extractall(LOCAL_STATE)

    print(f"Artifacts extracted to: {LOCAL_STATE}")


def find_state_directory():
    """
    Find the directory containing manifest.json and run_results.json.
    """
    manifest = None
    run_results = None

    for root, _, files in os.walk(LOCAL_STATE):
        if "manifest.json" in files:
            manifest = Path(root) / "manifest.json"

        if "run_results.json" in files:
            run_results = Path(root) / "run_results.json"

        if manifest and run_results:
            return manifest.parent

    raise RuntimeError(
        "Could not find both manifest.json and run_results.json "
        f"under {LOCAL_STATE}"
    )


def copy_to_volume(state_directory):
    """
    Copy the state directory into the Unity Catalog Volume.
    """
    from pyspark.sql import SparkSession

    spark = SparkSession.builder.getOrCreate()

    # dbutils is available through the Spark JVM on Databricks.
    from pyspark.dbutils import DBUtils

    dbutils = DBUtils(spark)

    print(f"Cleaning previous state from: {STATE_VOLUME}")

    try:
        dbutils.fs.rm(STATE_VOLUME, True)
    except Exception:
        pass

    dbutils.fs.mkdirs(STATE_VOLUME)

    print(f"Copying dbt state to: {STATE_VOLUME}")

    dbutils.fs.cp(
        f"file:{state_directory}",
        STATE_VOLUME,
        True,
    )

    print("State copied successfully.")


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--dbt-task-run-id",
        required=True,
        type=int,
        help="Individual Databricks task run ID for dbt_build",
    )

    args = parser.parse_args()

    print("=" * 70)
    print("Preparing dbt retry state")
    print("=" * 70)

    print(f"dbt_build task run ID: {args.dbt_task_run_id}")

    artifacts_url, headers = get_artifact_url(
        args.dbt_task_run_id
    )

    download_and_extract(
        artifacts_url,
        headers,
    )

    state_directory = find_state_directory()

    print(f"Found dbt state directory: {state_directory}")

    copy_to_volume(
        state_directory,
    )

    print("=" * 70)
    print("dbt retry state prepared successfully")
    print("=" * 70)


if __name__ == "__main__":
    main()