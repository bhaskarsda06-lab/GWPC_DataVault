# Phase 9 DQ / SLA Matrix

| Area | Critical condition | Action |
|---|---|---|
| Hub HK | Null or duplicate | Stop |
| Link relationship | Orphan | Stop |
| Satellite hashdiff | Null | Stop |
| Reconciliation | Difference above approved threshold | Stop |
| Job failure | Any production task failure | Alert + recovery |
| Runtime | Above approved SLA | Alert |
| Repeated failures | Threshold exceeded | Escalate |
| Schema change | Unapproved | Block deployment |

Actual numeric thresholds must be supplied/approved by the business and
operations teams.
