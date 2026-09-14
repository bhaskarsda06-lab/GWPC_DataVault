# SLA Breach Response

## If runtime exceeds the approved SLA

1. Confirm whether data volume increased.
2. Check warehouse availability and utilization.
3. Identify the slowest model(s).
4. Check for retries or transient failures.
5. Check whether a full refresh occurred unexpectedly.
6. Compare with recent successful runs.
7. Classify as data-volume, infrastructure, query/model, or scheduling issue.
8. Record the incident/change reference if required.
9. Correct the root cause.
10. Revalidate the full production workflow.

Do not increase warehouse size blindly. Record the reason and expected benefit before a capacity change.
