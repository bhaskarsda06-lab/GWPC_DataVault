-- Phase 9 production DQ threshold configuration.
-- This is configuration metadata; values require business approval.

CREATE TABLE IF NOT EXISTS autdbt_vault_prod.autdbts.dv_dq_rule_config (
    dq_check_id STRING NOT NULL,
    dq_check_name STRING NOT NULL,
    object_name STRING NOT NULL,
    severity STRING NOT NULL,
    enabled BOOLEAN NOT NULL,
    failure_threshold BIGINT,
    threshold_type STRING,
    owner_team STRING,
    sla_minutes INT,
    description STRING,
    effective_from TIMESTAMP NOT NULL,
    effective_to TIMESTAMP,
    created_ts TIMESTAMP NOT NULL
) USING DELTA;

INSERT INTO autdbt_vault_prod.autdbts.dv_dq_rule_config
VALUES
('DQ-HUB-001','Hub account HK not null','hub_account','CRITICAL',true,0,'MAX_FAILURES','DATA_ENGINEERING',60,'No null account HK',current_timestamp(),NULL,current_timestamp()),
('DQ-HUB-002','Hub contact HK not null','hub_contact','CRITICAL',true,0,'MAX_FAILURES','DATA_ENGINEERING',60,'No null contact HK',current_timestamp(),NULL,current_timestamp()),
('DQ-HUB-003','Hub policy HK not null','hub_policy','CRITICAL',true,0,'MAX_FAILURES','DATA_ENGINEERING',60,'No null policy HK',current_timestamp(),NULL,current_timestamp()),
('DQ-LNK-001','Policy-contact orphan check','link_policy_contact','CRITICAL',true,0,'MAX_FAILURES','DATA_ENGINEERING',60,'No orphan relationship',current_timestamp(),NULL,current_timestamp()),
('DQ-SAT-001','Satellite audit columns','SATELLITES','CRITICAL',true,0,'MAX_FAILURES','DATA_ENGINEERING',60,'HK/load/hashdiff required',current_timestamp(),NULL,current_timestamp()),
('REC-HUB-001','Hub source-target reconciliation','RAW_VAULT','CRITICAL',true,0,'MAX_DIFFERENCE','DATA_ENGINEERING',60,'Source and target population must reconcile',current_timestamp(),NULL,current_timestamp());
