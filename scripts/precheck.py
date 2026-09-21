import argparse
import json
import os
import tarfile
import tempfile
from datetime import datetime, timezone

import requests
from databricks.sdk import WorkspaceClient


# ---------------------------------------------------------
# Configuration
# ---------------------------------------------------------

STATE_ROOT = "/Volumes/audtdbt_vault_prod/audtdbtt/dbt_state"

MANIFEST_FILE = os.path.join(
    STATE_ROOT,
    "manifest.json"
)

RUN_RESULTS_FILE = os.path.join(
    STATE_ROOT,
    "run_results.json"
)

DBT_TASK_KEY = "dbt_build"


# ---------------------------------------------------------
# Arguments
# ---------------------------------------------------------

def parse_args():

    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--job-id",
        required=True
    )

    parser.add_argument(
        "--current-run-id",
        required=True
    )

    return parser.parse_args()


# ---------------------------------------------------------
# Safe tar extraction
# ---------------------------------------------------------

def safe_extract(tar, destination):

    destination = os.path.abspath(destination)

    for member in tar.getmembers():

        member_path = os.path.abspath(
            os.path.join(
                destination,
                member.name
            )
        )

        if not member_path.startswith(
            destination + os.sep
        ):
            raise RuntimeError(
                f"Unsafe archive path: {member.name}"
            )

    tar.extractall(destination)


# ---------------------------------------------------------
# Find dbt state directory
# ---------------------------------------------------------

def find_state_directory(extract_dir):

    for root, _, files in os.walk(extract_dir):

        if (
            "manifest.json" in files
            and
            "run_results.json" in files
        ):
            return root

    return None


# ---------------------------------------------------------
# Find previous dbt_build task
# ---------------------------------------------------------

def find_previous_dbt_build(
    workspace,
    job_id,
    current_run_id
):

    print("Searching previous dbt_build run...")

    runs = workspace.jobs.list_runs(
        job_id=job_id,
        completed_only=True,
        expand_tasks=True,
        limit=20
    )

    for run in runs:

        parent_run_id = int(run.run_id)

        # Ignore current job run
        if parent_run_id == current_run_id:
            continue

        for task in (run.tasks or []):

            if task.task_key != DBT_TASK_KEY:
                continue

            if not task.run_id:
                continue

            print(
                f"Found previous dbt_build:"
                f" task_run_id={task.run_id},"
                f" job_run_id={parent_run_id}"
            )

            return (
                int(task.run_id),
                parent_run_id
            )

    return None


# ---------------------------------------------------------
# Download dbt artifacts
# ---------------------------------------------------------

def download_dbt_artifacts(
    workspace,
    task_run_id
):

    print(
        f"Getting dbt output for task run "
        f"{task_run_id}"
    )

    output = workspace.jobs.get_run_output(
        run_id=task_run_id
    )

    if not output.dbt_output:

        raise RuntimeError(
            "dbt_output was not returned."
        )

    artifacts_link = (
        output.dbt_output.artifacts_link
    )

    if not artifacts_link:

        raise RuntimeError(
            "dbt artifact link was not returned."
        )

    headers = (
        output.dbt_output.artifacts_headers
        or {}
    )

    print("Downloading dbt artifacts...")

    response = requests.get(
        artifacts_link,
        headers=headers,
        timeout=300
    )

    response.raise_for_status()

    print(
        f"Downloaded "
        f"{len(response.content):,} bytes"
    )

    return response.content


# ---------------------------------------------------------
# Put latest state into Volume
# ---------------------------------------------------------

def save_latest_state(
    artifact_bytes,
    parent_run_id
):

    with tempfile.TemporaryDirectory() as temp_dir:

        archive_file = os.path.join(
            temp_dir,
            "dbt-output.tar.gz"
        )

        with open(
            archive_file,
            "wb"
        ) as f:

            f.write(artifact_bytes)

        extract_dir = os.path.join(
            temp_dir,
            "extracted"
        )

        os.makedirs(
            extract_dir,
            exist_ok=True
        )

        with tarfile.open(
            archive_file,
            "r:gz"
        ) as tar:

            safe_extract(
                tar,
                extract_dir
            )

        state_directory = (
            find_state_directory(
                extract_dir
            )
        )

        if not state_directory:

            raise RuntimeError(
                "manifest.json and "
                "run_results.json "
                "were not found."
            )

        print(
            f"dbt state found at: "
            f"{state_directory}"
        )

        # Only copy required state files
        manifest_source = os.path.join(
            state_directory,
            "manifest.json"
        )

        run_results_source = os.path.join(
            state_directory,
            "run_results.json"
        )

        os.makedirs(
            STATE_ROOT,
            exist_ok=True
        )

        # -------------------------------------------------
        # Override latest state
        # -------------------------------------------------

        with open(
            manifest_source,
            "rb"
        ) as source:

            with open(
                MANIFEST_FILE,
                "wb"
            ) as destination:

                destination.write(
                    source.read()
                )

        with open(
            run_results_source,
            "rb"
        ) as source:

            with open(
                RUN_RESULTS_FILE,
                "wb"
            ) as destination:

                destination.write(
                    source.read()
                )

        print(
            "Latest dbt state saved to Volume."
        )

        print(
            f"manifest.json    : {MANIFEST_FILE}"
        )

        print(
            f"run_results.json : {RUN_RESULTS_FILE}"
        )


# ---------------------------------------------------------
# Read run_results.json from Volume
# ---------------------------------------------------------

def decide_run_mode():

    print("=" * 60)
    print("Reading dbt state from Volume")
    print("=" * 60)

    # No manifest
    if not os.path.isfile(
        MANIFEST_FILE
    ):

        print(
            "manifest.json: NOT FOUND"
        )

        print(
            "Decision: FULL_BUILD"
        )

        return "FULL_BUILD"

    # No run results
    if not os.path.isfile(
        RUN_RESULTS_FILE
    ):

        print(
            "run_results.json: NOT FOUND"
        )

        print(
            "Decision: FULL_BUILD"
        )

        return "FULL_BUILD"

    print(
        "manifest.json: FOUND"
    )

    print(
        "run_results.json: FOUND"
    )

    with open(
        RUN_RESULTS_FILE,
        "r",
        encoding="utf-8"
    ) as f:

        run_results = json.load(f)

    results = run_results.get(
        "results",
        []
    )

    if not results:

        print(
            "No results found."
        )

        print(
            "Decision: FULL_BUILD"
        )

        return "FULL_BUILD"

    statuses = [
        str(
            result.get(
                "status",
                ""
            )
        ).lower()
        for result in results
    ]

    success_count = statuses.count(
        "success"
    )

    error_count = statuses.count(
        "error"
    )

    skipped_count = statuses.count(
        "skipped"
    )

    print(
        f"Total results : {len(statuses)}"
    )

    print(
        f"SUCCESS       : {success_count}"
    )

    print(
        f"ERROR         : {error_count}"
    )

    print(
        f"SKIPPED       : {skipped_count}"
    )

    # Everything succeeded
    if all(
        status == "success"
        for status in statuses
    ):

        print(
            "Previous dbt run = SUCCESS"
        )

        print(
            "Decision: FULL_BUILD"
        )

        return "FULL_BUILD"

    # Error or skipped exists
    print(
        "Previous dbt run contains "
        "ERROR/SKIPPED."
    )

    print(
        "Decision: RETRY"
    )

    return "RETRY"


# ---------------------------------------------------------
# Main
# ---------------------------------------------------------

def main():

    args = parse_args()

    job_id = int(
        args.job_id
    )

    current_run_id = int(
        args.current_run_id
    )

    print("=" * 60)
    print("DBT PRECHECK")
    print("=" * 60)

    print(
        f"Job ID         : {job_id}"
    )

    print(
        f"Current Run ID : {current_run_id}"
    )

    workspace = WorkspaceClient()

    # -----------------------------------------------------
    # Find previous dbt_build
    # -----------------------------------------------------

    previous = find_previous_dbt_build(
        workspace,
        job_id,
        current_run_id
    )

    # -----------------------------------------------------
    # First ever run
    # -----------------------------------------------------

    if not previous:

        print(
            "No previous dbt_build found."
        )

        print(
            "Decision: FULL_BUILD"
        )

        dbutils.jobs.taskValues.set(
            key="run_mode",
            value="FULL_BUILD"
        )

        return

    task_run_id, parent_run_id = previous

    # -----------------------------------------------------
    # Bring previous dbt artifacts
    # -----------------------------------------------------

    artifact_bytes = (
        download_dbt_artifacts(
            workspace,
            task_run_id
        )
    )

    # -----------------------------------------------------
    # Put latest manifest + results in Volume
    # -----------------------------------------------------

    save_latest_state(
        artifact_bytes,
        parent_run_id
    )

    # -----------------------------------------------------
    # Read Volume and decide
    # -----------------------------------------------------

    run_mode = decide_run_mode()

    dbutils.jobs.taskValues.set(
        key="run_mode",
        value=run_mode
    )

    print("=" * 60)
    print(
        f"FINAL RUN MODE: {run_mode}"
    )
    print("=" * 60)


if __name__ == "__main__":
    main()