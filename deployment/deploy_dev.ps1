$ErrorActionPreference = "Stop"

Write-Host "=== GWPC_DataVault DEV Deployment ==="

dbt deps --target dev
if ($LASTEXITCODE -ne 0) { throw "dbt deps failed." }

dbt build --target dev
if ($LASTEXITCODE -ne 0) { throw "dbt build failed." }

Write-Host "DEV DEPLOYMENT: PASSED"
