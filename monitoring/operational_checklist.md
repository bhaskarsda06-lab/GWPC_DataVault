# Production Operational Checklist

## Before job
- [ ] Correct Git commit deployed
- [ ] `dbt debug --target prod` passed
- [ ] `dbt deps --target prod` passed
- [ ] `dbt parse --target prod` passed
- [ ] Databricks production warehouse available
- [ ] Credentials available through approved secret management

## During job
- [ ] dbt build started
- [ ] No unexpected connection failures
- [ ] No compilation failures
- [ ] Model execution monitored
- [ ] Test execution monitored

## After job
- [ ] dbt build completed successfully
- [ ] Operational tests passed
- [ ] Row counts reviewed
- [ ] Critical-key checks passed
- [ ] Bridge relationship checks passed
- [ ] Logs retained
- [ ] Run status recorded

## Incident
- [ ] Failure classified
- [ ] Failed logs preserved
- [ ] Retry decision documented
- [ ] Root cause assigned
- [ ] Corrective action recorded
