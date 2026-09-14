# Audit Evidence Guide

## Automatically testable evidence
- production object accessibility
- critical key integrity
- audit timestamp population
- duplicate detection
- relationship population
- environment resolution

## Process/administrative evidence
- deployment approval
- change ticket
- access approval
- security review
- incident approval/closure
- evidence retention approval

Keep these categories separate.

## Evidence naming convention

Recommended:

```text
YYYYMMDD_<environment>_<phase>_<evidence-type>_<git-commit>
```

Never include secrets in evidence filenames or contents.
