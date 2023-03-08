TRUNCATE TABLE  `{{ params.project_id }}.silver.user_profiles`
;

INSERT `{{ params.project_id }}.silver.user_profiles` (
    email,
    first_name,
    last_name,
    state,
    birth_date,
    phone_number,

    _id,
    _logical_dt,
    _job_start_dt
)
SELECT
    email,
    SPLIT(full_name, ' ')[offset(0)]  AS first_name,
    SPLIT(full_name, ' ')[offset(1)]  AS last_name,
    state,
    CAST(birth_date AS DATE)          AS birth_date,
    phone_number,

    _id,
    _logical_dt,
    _job_start_dt
FROM `{{ params.project_id }}.bronze.user_profiles`
;