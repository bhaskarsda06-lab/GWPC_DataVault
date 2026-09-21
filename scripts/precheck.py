import argparse
import json
import os
import tarfile
import tempfile

import requests
from databricks.sdk import WorkspaceClient


# ============================================================
# Configuration
# ============================================================

STATE_DIR = "/Volumes/audtdbt_vault_prod/audtdbtt/dbt_state"

MANIFEST_FILE = os.path.join(
    STATE_DIR,
    "manifest.json"
)

RUN_RESULTS_FILE = os.path.join(
    STATE_DIR,
    "run_results.json"
)

DBT_BUILD_TASK_KEY = "dbt_build"


# ============================================================
# Arguments
# ============================================================

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


# ============================================================
# Find manifest.json + run_results.json
# ============================================================

def find_state_directory(extract_dir):

    for root, _, files in os.walk(extract_dir):

        if (
            "manifest.json" in files
            and "run_results.json" in files
        ):
            return root

    return None


# ============================================================
# Safe extraction
# ============================================================

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


# ============================================================
# Find previous dbt_build task
# ============================================================

def find_previous_dbt_build(
    workspace,
    job_id,
    current_run_id
):

    print("Searching for previous dbt_build...")

    runs = workspace.jobs.list_runs(
        job_id=job_id,
        completed_only=True,
        expand_tasks=True,
        limit=20
    )

    for job_run in runs:

        parent_run_id = int(job_run.run_id)

        # Do not use current job run
        if parent_run_id == current_run_id:
            continue

        for task in (job_run.tasks or []):

            if task.task_key != DBT_BUILD_TASK_KEY:
                continue

            if not task.run_id:
                continue

            print(
                f"Previous dbt_build found:"
                f" job_run_id={parent_run_id},"
                f" task_run_id={task.run_id}"
            )

            return int(task.run_id)

    return None


# ============================================================
# Download dbt artifacts
# ============================================================

def download_dbt_artifacts(
    workspace,
    dbt_task_run_id
):

    print(
        f"Getting dbt output for task run "
        f"{dbt_task_run_id}..."
    )

    output = workspace.jobs.get_run_output(
        run_id=dbt_task_run_id
    )

    if not output.dbt_output:

        print(
            "No dbt_output found."
        )

        return None

    artifacts_link = (
        output.dbt_output.artifacts_link
    )

    if not artifacts_link:

        print(
            "No dbt artifact link found."
        )

        return None

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
        f"{len(response.content):,} bytes."
    )

    return response.content


# ============================================================
# Copy ONLY manifest.json and run_results.json
# ============================================================

def copy_required_state(artifact_bytes):

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

        print("Extracting dbt artifacts...")

        with tarfile.open(
            archive_file,
            "r:gz"
        ) as tar:

            safe_extract(
                tar,
                extract_dir
            )

        state_directory = find_state_directory(
            extract_dir
        )

        if not state_directory:

            print(
                "manifest.json and "
                "run_results.json were not found."
            )

            return False

        manifest_source = os.path.join(
            state_directory,
            "manifest.json"
        )

        run_results_source = os.path.join(
            state_directory,
            "run_results.json"
        )

        # Make sure Volume directory exists
        os.makedirs(
            STATE_DIR,
            exist_ok=True
        )

        # ----------------------------------------------------
        # Copy manifest.json
        # ----------------------------------------------------

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

        print(
            "Copied manifest.json to Volume."
        )

        # ----------------------------------------------------
        # Copy run_results.json
        # ----------------------------------------------------

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
            "Copied run_results.json to Volume."
        )

        return True


# ============================================================
# Decide FULL_BUILD or RETRY
# ============================================================

def decide_run_mode():

    print("=" * 60)
    print("Reading run_results.json from Volume")
    print("=" * 60)

    if not os.path.isfile(
        MANIFEST_FILE
    ):

        print(
            "manifest.json not found."
        )

        print(
            "Decision: FULL_BUILD"
        )

        return "FULL_BUILD"

    if not os.path.isfile(
        RUN_RESULTS_FILE
    ):

        print(
            "run_results.json not found."
        )

        print(
            "Decision: FULL_BUILD"
        )

        return "FULL_BUILD"

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
            "No results found in run_results.json."
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

    # Everything successful
    if all(
        status == "success"
        for status in statuses
    ):

        print(
            "Previous dbt run was successful."
        )

        print(
            "Decision: FULL_BUILD"
        )

        return "FULL_BUILD"

    # ERROR or SKIPPED exists
    print(
        "Previous dbt run contains "
        "ERROR/SKIPPED."
    )

    print(
        "Decision: RETRY"
    )

    return "RETRY"


# ============================================================
# Main
# ============================================================

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

    print(
        f"Volume         : {STATE_DIR}"
    )

    workspace = WorkspaceClient()

    # --------------------------------------------------------
    # Find previous dbt_build
    # --------------------------------------------------------

    dbt_task_run_id = find_previous_dbt_build(
        workspace,
        job_id,
        current_run_id
    )

    # --------------------------------------------------------
    # First run / no previous dbt_build
    # --------------------------------------------------------

    if not dbt_task_run_id:

        print(
            "No previous dbt_build found."
        )

        run_mode = "FULL_BUILD"

        dbutils.jobs.taskValues.set(
            key="run_mode",
            value=run_mode
        )

        print(
            f"RUN MODE = {run_mode}"
        )

        return

    # --------------------------------------------------------
    # Get previous dbt artifacts
    # --------------------------------------------------------

    artifact_bytes = download_dbt_artifacts(
        workspace,
        dbt_task_run_id
    )

    # --------------------------------------------------------
    # If artifacts unavailable
    # --------------------------------------------------------

    if not artifact_bytes:

        print(
            "Previous dbt artifacts unavailable."
        )

        run_mode = "FULL_BUILD"

        dbutils.jobs.taskValues.set(
            key="run_mode",
            value=run_mode
        )

        print(
            f"RUN MODE = {run_mode}"
        )

        return

    # --------------------------------------------------------
    # Copy ONLY manifest + run_results to Volume
    # --------------------------------------------------------

    copied = copy_required_state(
        artifact_bytes
    )

    if not copied:

        print(
            "Required state files could not "
            "be copied."
        )

        run_mode = "FULL_BUILD"

        dbutils.jobs.taskValues.set(
            key="run_mode",
            value=run_mode
        )

        return

    # --------------------------------------------------------
    # Read Volume and decide
    # --------------------------------------------------------

    run_mode = decide_run_mode()

    dbutils.jobs.taskValues.set(
        key="run_mode",
        value=run_mode
    )

    print("=" * 60)
    print(
        f"FINAL RUN MODE = {run_mode}"
    )
    print("=" * 60)


if __name__ == "__main__":
    main()