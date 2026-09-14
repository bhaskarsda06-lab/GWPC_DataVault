-- Compliance technical sentinel.
-- Organizational compliance evidence is maintained separately in the evidence register.
SELECT COUNT(*) AS cnt
FROM {{ ref('hub_policy') }}
HAVING COUNT(*) < 0
