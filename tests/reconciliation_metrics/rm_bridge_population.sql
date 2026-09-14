-- Phase 9.7: Bridge population must equal the intersection of its two source Links.
WITH expected AS (
    SELECT COUNT(*) cnt
    FROM {{ ref('lnk_policy_account') }} pa
    INNER JOIN {{ ref('lnk_policy_contact_role') }} pc
      ON pa.policypublicid = pc.policypublicid
), actual AS (
    SELECT COUNT(*) cnt FROM {{ ref('bridge_policy_account_contact') }}
)
SELECT expected.cnt expected_count, actual.cnt bridge_count, expected.cnt-actual.cnt difference
FROM expected CROSS JOIN actual
WHERE expected.cnt <> actual.cnt
