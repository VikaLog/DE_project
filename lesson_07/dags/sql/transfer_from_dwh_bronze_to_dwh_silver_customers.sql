TRUNCATE TABLE `{{ params.project_id }}.silver.customers`
;

INSERT `{{ params.project_id }}.silver.customers` (
    first_name,
    last_name,
    email,
    registration_date,
    state,
    client_id,

    _logical_dt,
    _job_start_dt
)
SELECT
    FirstName                                    AS first_name,
    LastName                                     AS last_name,
    Email                                        AS email,
    CAST(RegistrationDate AS DATE)               AS registration_date,
    State                                        AS state,
    MIN(Id)                                      AS client_id,

    CAST('{{ dag_run.logical_date }}' AS TIMESTAMP) AS _logical_dt,
    CAST('{{ dag_run.start_date }}'AS TIMESTAMP) AS _job_start_dt

FROM `{{ params.project_id }}.bronze.customers`
GROUP BY first_name, last_name, email, registration_date, state
;


