INSERT `my_dataset.sales_cleaned`(client, purchase_date, product, price)
SELECT
  client,
  CAST(purchase_date AS DATE) AS purchase_date,
  product,
  CAST(RTRIM(price, 'USD') AS INTEGER) AS price
FROM `my_dataset.sales_raw`
;
