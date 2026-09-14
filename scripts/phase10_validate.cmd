@echo off
setlocal

echo ============================================================
echo GWPC Data Vault Phase 10 - Local Validation
echo ============================================================

where python >nul 2>&1
if errorlevel 1 (
  echo ERROR: Python not found.
  exit /b 1
)

where dbt >nul 2>&1
if errorlevel 1 (
  echo ERROR: dbt CLI not found.
  exit /b 1
)

echo.
echo [1/6] dbt deps
call dbt deps
if errorlevel 1 exit /b 1

echo.
echo [2/6] dbt parse
call dbt parse --target dev
if errorlevel 1 exit /b 1

echo.
echo [3/6] dbt compile
call dbt compile --target dev
if errorlevel 1 exit /b 1

echo.
echo [4/6] Hub tests
call dbt test --select tag:hub --target dev
if errorlevel 1 exit /b 1

echo.
echo [5/6] Link tests
call dbt test --select tag:link --target dev
if errorlevel 1 exit /b 1

echo.
echo [6/6] Satellite tests
call dbt test --select tag:satellite --target dev
if errorlevel 1 exit /b 1

echo.
echo ============================================================
echo PASS: Static dbt validation completed.
echo ============================================================
exit /b 0
