@echo off
echo ===== GWPC Data Vault Phase 1 Verification =====
git --version
python --version
pip --version
databricks --version
dbt --version
echo.
git status
echo.
echo Phase 1 local verification finished.
pause
