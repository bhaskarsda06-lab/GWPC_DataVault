# End-to-End Orchestration Design

## Layers

### Layer 1 — Source readiness
The source ingestion process confirms that the expected source batch is ready.

### Layer 2 — dbt
dbt executes the dependency graph:
- staging
- hubs
- links
- satellites
- Business Vault
- bridges
- tests

### Layer 3 — Production controls
Existing Phase 10 suites validate:
- smoke
- operations
- recovery
- security/governance
- audit/lineage
- SLA/performance
- DR readiness

### Layer 4 — Evidence
The orchestration platform stores execution metadata and logs.

## Control boundaries

The orchestration layer should not duplicate business logic already encoded in dbt models.

The scheduler controls:
- when to run
- what environment to run
- dependencies
- retries
- timeout
- notifications
- concurrency

dbt controls:
- transformation dependency graph
- model execution
- tests
- data transformation logic

## No secrets

Connection credentials should be supplied by the organization's approved secret/identity mechanism.
