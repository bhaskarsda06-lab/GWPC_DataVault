# Security Review Checklist

## Identity
- [ ] Production job uses approved non-human identity
- [ ] Individual developer credential is not used for unattended production jobs
- [ ] Identity ownership is documented

## Access
- [ ] Catalog grants reviewed
- [ ] Vault schema grants reviewed
- [ ] Staging schema grants reviewed
- [ ] Production object grants reviewed
- [ ] Consumer access is read-only where appropriate
- [ ] Write/DDL privileges are restricted

## Secrets
- [ ] Credentials are managed by approved secret management
- [ ] No secrets committed to Git
- [ ] No secrets in SQL/YAML
- [ ] No secrets in logs
- [ ] Previously exposed credentials are rotated

## Governance
- [ ] Production and development catalogs are separated
- [ ] Ownership documented
- [ ] Change-control process documented
- [ ] Audit evidence retained
- [ ] Access review cadence defined
