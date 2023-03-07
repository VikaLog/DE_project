-- DELETE FROM `{{ params.project_id }}.silver.sales`
-- WHERE DATE(purchase_date) = "{{ ds }}"
-- ;

INSERT `{{ params.project_id }}.silver.sales` (
    client,
    purchase_date,
    product,
    price,

    _id,
    _logical_dt,
    _job_start_dt
)
SELECT
    client,
    CAST(purchase_date AS DATE) AS purchase_date,
    product,
    CAST(RTRIM(price, 'USD') AS INTEGER) AS price,

    _id,
    _logical_dt,
    _job_start_dt
FROM `{{ params.project_id }}.bronze.sales`
WHERE DATE(_logical_dt) = "{{ ds }}"
;