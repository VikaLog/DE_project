DELETE FROM `{{ params.project_id }}.silver.sales`
WHERE DATE(purchase_date) = "{{ ds }}"
;

INSERT `{{ params.project_id }}.silver.sales` (
    client_id,
    purchase_date,
    product_name,
    price,

    _id,
    _logical_dt,
    _job_start_dt
)
SELECT
    CustomerId                         AS client_id,
    CAST(REPLACE(REPLACE(PurchaseDate, "/", "-"), "Aug", "08") AS DATE)         AS purchase_date,
    Product                            AS product_name,
    CAST(RTRIM(Price, '$, USD') AS INTEGER) AS price,

    _id,
    _logical_dt,
    _job_start_dt
FROM `{{ params.project_id }}.bronze.sales`
WHERE DATE(_logical_dt) = "{{ ds }}"
;