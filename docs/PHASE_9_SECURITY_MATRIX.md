# Phase 9 Security Matrix

| Principal | DEV | TEST | PROD |
|---|---|---|---|
| Developers | Develop/test | Read/validate | No direct write |
| CI/CD service principal | Deploy | Deploy | Deploy |
| Job Run As service principal | Execute | Execute | Execute |
| Data engineering readers | Read | Read | Read |
| Production support | Read/operate | Read/operate | Controlled job/run access |

The exact grants must be approved against the enterprise IAM model.

## Production rule

Humans should not routinely run production transformations using personal
credentials.

The production Job Run As identity should be a service principal.
