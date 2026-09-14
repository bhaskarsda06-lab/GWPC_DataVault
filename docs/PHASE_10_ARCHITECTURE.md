# Phase 10 Deployment Architecture

Developer Workstation
        |
        v
Git Repository
        |
        v
CI Validation
  |-- dbt deps
  |-- dbt debug
  |-- dbt parse
  |-- dbt compile
  |-- Phase 8/9 tests
        |
        v
Approved Deployment
        |
        v
Databricks Target
  |-- Staging
  |-- Raw Vault
  |-- Business Vault
        |
        v
Post-Deployment Smoke Tests
        |
        v
Operational Monitoring / Runbook

Secrets are supplied by the deployment environment and are not stored in the repository.
