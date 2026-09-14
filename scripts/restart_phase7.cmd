@echo off
REM Phase 7 - Restart helper
REM This command prints the SQL/query guidance. Actual production restart
REM must be executed through the approved Databricks Job mechanism.

echo Phase 7 restart procedure
echo.
echo 1. Capture the failed Databricks run ID.
echo 2. Query sql/restart_controller.sql with the correct catalog/schema/run ID.
echo 3. Identify the first non-SUCCESS stage.
echo 4. Fix code/configuration through Git.
echo 5. CI validate and deploy.
echo 6. Resume from the identified stage using the approved job parameter.
echo.
