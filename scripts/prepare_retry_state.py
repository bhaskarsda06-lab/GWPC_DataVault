import argparse
import io
import os
import tarfile
import tempfile
import requests

from databricks.sdk import WorkspaceClient


STATE_VOLUME = "/Volumes/audtdbt_vault_prod/audtdbt/dbt_state"
STATE_ARCHIVE = f"{STATE_VOLUME}/dbt-output.tar.gz"


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--dbt-task-run-id",
        required=True,
        help="Individual dbt task run ID from the upstream dbt_build task",
    )
    return parser.parse_args()


def safe_extract(tar, destination):
    destination = os.path.abspath(destination)

    for member in tar.getmembers():
        member_path = os.path.abspath(
            os.path.join(destination, member.name)
        )

        if not member_path.startswith(destination + os.sep):
            raise RuntimeError(
                f"Unsafe archive path detected: {member.name}"
            )

    tar.extractall(destination)


def main():
    args = parse_args()

    task_run_id = int(args.dbt_task_run_id)

    print(f"Getting dbt task output for run ID: {task_run_id}")

    # Databricks SDK uses the job/task identity for authentication.
    workspace = WorkspaceClient()

    output = workspace.jobs.get_run_output(
        run_id=task_run_id
    )

    if not output.dbt_output:
        raise RuntimeError(
            "No dbt_output was returned for the dbt_build task."
        )

    artifacts_link = output.dbt_output.artifacts_link

    if not artifacts_link:
        raise RuntimeError(
            "dbt_output.artifacts_link was not returned."
        )

    headers = output.dbt_output.artifacts_headers or {}

    print("Downloading dbt artifact archive...")

    response = requests.get(
        artifacts_link,
        headers=headers,
        timeout=300,
    )

    response.raise_for_status()

    artifact_bytes = response.content

    print(
        f"Downloaded {len(artifact_bytes):,} bytes of dbt artifacts."
    )

    # Validate the archive before storing it.
    with tempfile.TemporaryDirectory() as temp_dir:

        archive_path = os.path.join(
            temp_dir,
            "dbt-output.tar.gz"
        )

        with open(archive_path, "wb") as file:
            file.write(artifact_bytes)

        extract_dir = os.path.join(
            temp_dir,
            "extracted"
        )

        os.makedirs(extract_dir, exist_ok=True)

        with tarfile.open(
            archive_path,
            mode="r:gz"
        ) as tar:

            safe_extract(
                tar,
                extract_dir
            )

        manifest_found = False
        run_results_found = False

        for root, _, files in os.walk(extract_dir):

            if "manifest.json" in files:
                manifest_found = True

            if "run_results.json" in files:
                run_results_found = True

        if not manifest_found:
            raise RuntimeError(
                "manifest.json was not found in the dbt artifact archive."
            )

        if not run_results_found:
            raise RuntimeError(
                "run_results.json was not found in the dbt artifact archive."
            )

        print("Validated dbt artifacts:")
        print(f"  manifest.json   : {manifest_found}")
        print(f"  run_results.json: {run_results_found}")

    # Ensure the Volume directory exists.
    workspace.files.create_directory(
        STATE_VOLUME
    )

    # Upload the complete dbt artifact archive.
    print(
        f"Uploading archive to:\n{STATE_ARCHIVE}"
    )

    workspace.files.upload(
        STATE_ARCHIVE,
        io.BytesIO(artifact_bytes),
        overwrite=True,
    )

    print("dbt retry state successfully saved.")
    print(f"State archive: {STATE_ARCHIVE}")


if __name__ == "__main__":
    main()