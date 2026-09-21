import argparse
import io
import os
import tarfile
import tempfile
import requests

from databricks.sdk import WorkspaceClient


STATE_VOLUME = "/Volumes/audtdbt_vault_prod/audtdbt/dbt_state"


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--dbt-task-run-id",
        required=True,
        help="Individual dbt task run ID from dbt_build",
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


def find_state_directory(extract_dir):

    for root, _, files in os.walk(extract_dir):

        if (
            "manifest.json" in files
            and "run_results.json" in files
        ):
            return root

    return None


def upload_directory(workspace, local_dir):

    uploaded = []

    for root, _, files in os.walk(local_dir):

        for filename in files:

            local_file = os.path.join(
                root,
                filename
            )

            relative_path = os.path.relpath(
                local_file,
                local_dir
            )

            volume_file = os.path.join(
                STATE_VOLUME,
                relative_path
            ).replace("\\", "/")

            # Only create a subdirectory when one is actually needed.
            # Do NOT create STATE_VOLUME itself.
            relative_parent = os.path.dirname(
                relative_path
            )

            if relative_parent:

                volume_parent = os.path.join(
                    STATE_VOLUME,
                    relative_parent
                ).replace("\\", "/")

                workspace.files.create_directory(
                    volume_parent
                )

            print(
                f"Uploading: {relative_path}"
            )

            with open(
                local_file,
                "rb"
            ) as file:

                workspace.files.upload(
                    volume_file,
                    io.BytesIO(file.read()),
                    overwrite=True
                )

            uploaded.append(
                relative_path
            )

    return uploaded


def main():

    args = parse_args()

    task_run_id = int(
        args.dbt_task_run_id
    )

    print(
        "========================================"
    )
    print(
        "Preparing dbt retry state"
    )
    print(
        "========================================"
    )

    print(
        f"dbt task run ID: {task_run_id}"
    )

    workspace = WorkspaceClient()

    # ---------------------------------------------------------
    # 1. Get dbt task output
    # ---------------------------------------------------------

    print(
        "Getting dbt task output..."
    )

    output = workspace.jobs.get_run_output(
        run_id=task_run_id
    )

    if not output.dbt_output:

        raise RuntimeError(
            "No dbt_output returned from dbt_build."
        )

    artifacts_link = (
        output.dbt_output.artifacts_link
    )

    if not artifacts_link:

        raise RuntimeError(
            "dbt artifact download link was not returned."
        )

    headers = (
        output.dbt_output.artifacts_headers
        or {}
    )

    # ---------------------------------------------------------
    # 2. Download dbt artifact archive
    # ---------------------------------------------------------

    print(
        "Downloading dbt artifact archive..."
    )

    response = requests.get(
        artifacts_link,
        headers=headers,
        timeout=300
    )

    response.raise_for_status()

    artifact_bytes = response.content

    print(
        f"Downloaded {len(artifact_bytes):,} bytes."
    )

    # ---------------------------------------------------------
    # 3. Extract locally
    # ---------------------------------------------------------

    with tempfile.TemporaryDirectory() as temp_dir:

        archive_path = os.path.join(
            temp_dir,
            "dbt-output.tar.gz"
        )

        with open(
            archive_path,
            "wb"
        ) as file:

            file.write(
                artifact_bytes
            )

        extract_dir = os.path.join(
            temp_dir,
            "extracted"
        )

        os.makedirs(
            extract_dir,
            exist_ok=True
        )

        print(
            "Extracting dbt artifacts..."
        )

        with tarfile.open(
            archive_path,
            "r:gz"
        ) as tar:

            safe_extract(
                tar,
                extract_dir
            )

        # -----------------------------------------------------
        # 4. Find dbt state
        # -----------------------------------------------------

        state_directory = (
            find_state_directory(
                extract_dir
            )
        )

        if not state_directory:

            raise RuntimeError(
                "Could not find a directory containing "
                "both manifest.json and run_results.json."
            )

        print(
            f"State directory found:"
        )

        print(
            state_directory
        )

        # -----------------------------------------------------
        # 5. Validate required files
        # -----------------------------------------------------

        manifest_path = os.path.join(
            state_directory,
            "manifest.json"
        )

        run_results_path = os.path.join(
            state_directory,
            "run_results.json"
        )

        if not os.path.exists(
            manifest_path
        ):

            raise RuntimeError(
                "manifest.json not found."
            )

        if not os.path.exists(
            run_results_path
        ):

            raise RuntimeError(
                "run_results.json not found."
            )

        print(
            "Required dbt state files found:"
        )

        print(
            "  manifest.json"
        )

        print(
            "  run_results.json"
        )

        # -----------------------------------------------------
        # 6. Upload state files to existing Volume
        # -----------------------------------------------------

        print(
            "Uploading dbt state to Volume..."
        )

        uploaded = upload_directory(
            workspace,
            state_directory
        )

        # -----------------------------------------------------
        # 7. Final validation
        # -----------------------------------------------------

        print("")
        print(
            "========================================"
        )
        print(
            "dbt retry state prepared successfully"
        )
        print(
            "========================================"
        )

        print(
            f"Volume: {STATE_VOLUME}"
        )

        print(
            f"Files uploaded: {len(uploaded)}"
        )

        for file in uploaded:

            print(
                f"  {file}"
            )


if __name__ == "__main__":

    main()