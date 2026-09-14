# Phase 6 DQ Catalog

| ID | Check | Severity | Expected |
|---|---|---|---|
| DQ-HUB-001 | Hub account HK not null | Critical | 0 failures |
| DQ-HUB-002 | Hub contact HK not null | Critical | 0 failures |
| DQ-HUB-003 | Hub policy HK not null | Critical | 0 failures |
| DQ-HUB-004 | Hub HK duplicate | Critical | 0 duplicates |
| DQ-LNK-001 | Link parent HK integrity | Critical | 0 orphans |
| DQ-LNK-002 | Link HK duplicate | Critical | 0 duplicates |
| DQ-SAT-001 | Satellite HK not null | Critical | 0 failures |
| DQ-SAT-002 | Satellite hashdiff not null | Critical | 0 failures |
| DQ-SAT-003 | Satellite HK+hashdiff duplicate | Critical | 0 duplicates |
| REC-HUB-001 | Account source/target population | Critical | Difference = 0 |
| REC-HUB-002 | Contact source/target population | Critical | Difference = 0 |
| REC-HUB-003 | Policy source/target population | Critical | Difference = 0 |
| REC-LNK-001 | Policy-contact source/target population | Critical | Difference = 0 |

Severity and thresholds should be expanded with business-approved rules
before production go-live.
