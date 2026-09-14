@echo off
setlocal

echo Running Phase 11 orchestration validation...
dbt test --target prod --select path:tests/orchestration

if errorlevel 1 (
  echo ORCHESTRATION VALIDATION FAILED
  exit /b 1
)

echo ORCHESTRATION VALIDATION PASSED
exit /b 0
