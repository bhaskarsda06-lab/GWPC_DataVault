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

            parent_dir = os.path.dirname(volume_file)

            workspace.files.create_directory(
                parent_dir
            )

            with open(local_file, "rb") as file:

                workspace.files.upload(
                    volume_file,
                    io.BytesIO(file.read()),
                    overwrite=True,
                )

            uploaded.append(relative_path)

    return uploaded


def main():

    args = parse_args()

    task_run_id = int(args.dbt_task_run_id)

    print(
        f"Getting dbt output for task run ID: {task_run_id}"
    )

    workspace = WorkspaceClient()

    # ---------------------------------------------------------
    # 1. Get output from the failed dbt_build task
    # ---------------------------------------------------------

    output = workspace.jobs.get_run_output(
        run_id=task_run_id
    )

    if not output.dbt_output:

        raise RuntimeError(
            "No dbt_output returned from dbt_build."
        )

    artifacts_link = output.dbt_output.artifacts_link

    if not artifacts_link:

        raise RuntimeError(
            "dbt artifact download link was not returned."
        )

    headers = (
        output.dbt_output.artifacts_headers
        or {}
    )

    print("Downloading dbt artifact archive...")

    response = requests.get(
        artifacts_link,
        headers=headers,
        timeout=300,
    )

    response.raise_for_status()

    artifact_bytes = response.content

    print(
        f"Downloaded {len(artifact_bytes):,} bytes."
    )

    # ---------------------------------------------------------
    # 2. Extract artifacts locally
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

            file.write(artifact_bytes)

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
            archive_path,
            "r:gz"
        ) as tar:

            safe_extract(
                tar,
                extract_dir
            )

        # -----------------------------------------------------
        # 3. Find directory containing dbt state
        # -----------------------------------------------------

        state_directory = find_state_directory(
            extract_dir
        )

        if not state_directory:

            raise RuntimeError(
                "Could not find a directory containing "
                "both manifest.json and run_results.json."
            )

        print(
            f"dbt state directory found:\n{state_directory}"
        )

        # -----------------------------------------------------
        # 4. Create Volume directory
        # -----------------------------------------------------

        workspace.files.create_directory(
            STATE_VOLUME
        )

        # -----------------------------------------------------
        # 5. Upload actual dbt state files
        # -----------------------------------------------------

        uploaded = upload_directory(
            workspace,
            state_directory
        )

        # -----------------------------------------------------
        # 6. Validate uploaded state
        # -----------------------------------------------------

        required_files = [
            "manifest.json",
            "run_results.json",
        ]

        for required_file in required_files:

            local_required = os.path.join(
                state_directory,
                required_file
            )

            if not os.path.exists(
                local_required
            ):

                raise RuntimeError(
                    f"Required file missing: {required_file}"
                )

        print("")
        print("========================================")
        print("dbt retry state prepared successfully")
        print("========================================")

        print(
            f"State location: {STATE_VOLUME}"
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