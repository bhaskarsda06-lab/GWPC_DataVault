# Phase 1 - Installation

1. Install Git for Windows.
   Verify: `git --version`

2. Install Python 3.x and select "Add Python.exe to PATH".
   Verify: `python --version` and `pip --version`

3. Install VS Code.
   Recommended extensions: Python, YAML, GitHub Actions, SQL, Databricks.

4. Install the current Databricks CLI from the official Databricks documentation.
   Verify: `databricks --version`

5. Create the local project:
   ```
   cd C:\
   mkdir GWPC_DataVault
   cd GWPC_DataVault
   ```

6. Initialize Git:
   ```
   git init
   git branch -M main
   ```

7. Create and activate Python environment:
   ```
   python -m venv .venv
   .venv\Scripts\activate
   ```

8. Install project packages:
   ```
   python -m pip install --upgrade pip
   pip install -r requirements.txt
   ```

9. Verify:
   ```
   dbt --version
   databricks --version
   ```

10. Create a private GitHub repository named `GWPC_DataVault`.
