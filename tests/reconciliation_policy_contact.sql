-- Reconciliation between the Link and its expected source relationship.
WITH source_count AS (
    SELECT COUNT(*) AS cnt
    FROM {{ source('gwpc', 'pc_policycontactrole_curr') }} pcr
    INNER JOIN {{ source('gwpc', 'pc_policyperiod_curr') }} pp
        ON pp.BranchID = pcr.BranchID
    INNER JOIN {{ source('gwpc', 'pc_contact_curr') }} c
        ON pcr.ContactDenorm = c.ID
    WHERE COALESCE(pcr.Retired, 0) = 0
      AND COALESCE(pp.Retired, 0) = 0
      AND COALESCE(c.Retired, 0) = 0
      AND COALESCE(pcr.PublicID, '') <> ''
),
target_count AS (
    SELECT COUNT(*) AS cnt
    FROM {{ ref('link_policy_contact') }}
)
SELECT
    source_count.cnt AS source_count,
    target_count.cnt AS target_count,
    source_count.cnt - target_count.cnt AS difference_count
FROM source_count
CROSS JOIN target_count
WHERE source_count.cnt <> target_count.cnt
