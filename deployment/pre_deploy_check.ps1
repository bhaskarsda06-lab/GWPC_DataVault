$ErrorActionPreference = "Stop"

Write-Host "=== GWPC_DataVault Phase 10 Pre-Deployment Check ==="

if (-not (Get-Command dbt -ErrorAction SilentlyContinue)) {
    throw "dbt executable was not found. Activate the project virtual environment."
}

Write-Host "`n[1/4] dbt debug"
dbt debug --target dev
if ($LASTEXITCODE -ne 0) { throw "dbt debug failed." }

Write-Host "`n[2/4] dbt parse"
dbt parse --target dev
if ($LASTEXITCODE -ne 0) { throw "dbt parse failed." }

Write-Host "`n[3/4] dbt compile"
dbt compile --target dev
if ($LASTEXITCODE -ne 0) { throw "dbt compile failed." }

Write-Host "`n[4/4] Phase 9 regression"
dbt test --select path:tests/unit_logic path:tests/reconciliation_metrics path:tests/referential_integrity path:tests/e2e_regression --target dev
if ($LASTEXITCODE -ne 0) { throw "Phase 9 regression validation failed." }

Write-Host "`nPRE-DEPLOYMENT CHECK: PASSED"
