# Alert Matrix

| Signal | Severity | Action |
|---|---|---|
| Production job failure | P1 | Stop/handoff + incident |
| Data-quality test failure | P1/P2 | Stop handoff + investigate |
| Reconciliation mismatch | P1/P2 | Stop handoff + investigate |
| Hub critical-key null | P1 | Stop handoff |
| Bridge key null | P1 | Stop handoff |
| Duplicate bridge key | P1 | Stop handoff |
| Repeated retry | P1 | Escalate |
| Performance threshold breach | P2 | Investigate |
| Non-critical warning | P3 | Record/investigate |

The exact routing destination should be supplied by the organization's alerting platform.
