DELETE FROM `{{ params.project_id }}.bronze.user_profiles`
WHERE DATE(_logical_dt) = "{{ ds }}"
;

INSERT `{{ params.project_id }}.bronze.user_profiles` (
    email,
    full_name,
    state,
    birth_date,
    phone_number,

    _id,
    _logical_dt,
    _job_start_dt
)
SELECT
    email,
    full_name,
    state,
    birth_date,
    phone_number,

    GENERATE_UUID() AS _id,
    CAST('{{ dag_run.logical_date }}' AS TIMESTAMP) AS _logical_dt,
    CAST('{{ dag_run.start_date }}'AS TIMESTAMP) AS _job_start_dt
FROM user_profiles_jsonl
;