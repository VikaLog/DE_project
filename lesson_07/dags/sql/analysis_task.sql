-- В якому штаті було куплено найбільше телевізорів покупцями від 20 до 30 років за першу декаду вересня?

SELECT
    upe.state,
    count(sales.client_id) AS tv_count
FROM
    `de-07-logvinova-viktoriia.gold.user_profiles_enriched` AS upe
INNER JOIN (
      SELECT
          s.client_id
      FROM
          `de-07-logvinova-viktoriia.silver.sales` AS s
      WHERE s.product_name = "TV"
      AND s.purchase_date >= "2022-09-01"
      AND s.purchase_date <= "2022-09-10"
      ) AS sales
    ON sales.client_id = upe.client_id
WHERE DATE_DIFF(CURRENT_DATE(),upe.birth_date, YEAR)>=20
AND DATE_DIFF(CURRENT_DATE(),upe.birth_date, YEAR)<=30
GROUP BY upe.state
ORDER BY tv_count desc
LIMIT 1
;

--Answer: Iowa - 183