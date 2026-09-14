# Production Recovery Checklist

## Detection
- [ ] Alert received
- [ ] Run ID captured
- [ ] Failed step identified
- [ ] Failure time captured

## Classification
- [ ] Infrastructure
- [ ] Authentication
- [ ] dbt compilation/deployment
- [ ] Data quality
- [ ] Reconciliation
- [ ] Referential integrity
- [ ] Performance

## Recovery
- [ ] Downstream handoff paused if required
- [ ] Logs preserved
- [ ] Root cause identified
- [ ] Approved corrective action applied
- [ ] Targeted validation passed
- [ ] Production build/test passed where required
- [ ] Phase 10.4 smoke tests passed
- [ ] Phase 10.5 operational tests passed

## Closure
- [ ] Incident reference updated
- [ ] Root cause documented
- [ ] Corrective action documented
- [ ] Final validation evidence attached
- [ ] Operational owner approved closure
