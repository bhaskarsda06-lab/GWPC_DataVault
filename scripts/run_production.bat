@echo off
setlocal

echo ==========================================
echo GWPC Data Vault - Production Run
echo ==========================================

echo [1/3] Parsing dbt project...
dbt parse --target prod
if errorlevel 1 goto :failure

echo [2/3] Building production...
dbt build --target prod
if errorlevel 1 goto :failure

echo [3/3] Running orchestration validation...
dbt test --target prod --select path:tests/orchestration
if errorlevel 1 goto :failure

echo ==========================================
echo PRODUCTION RUN COMPLETED SUCCESSFULLY
echo ==========================================
exit /b 0

:failure
echo ==========================================
echo PRODUCTION RUN FAILED
echo Review logs and orchestration evidence.
echo ==========================================
exit /b 1
