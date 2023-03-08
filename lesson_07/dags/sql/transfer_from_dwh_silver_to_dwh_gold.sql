TRUNCATE TABLE  `{{ params.project_id }}.gold.user_profiles_enriched`
;

INSERT `{{ params.project_id }}.gold.user_profiles_enriched` (
    client_id,
    first_name,
    last_name,
    email,
    registration_date,
    state
)
SELECT
    client_id,
    first_name,
    last_name,
    email,
    registration_date,
    state
FROM `{{ params.project_id }}.silver.customers`
;

MERGE INTO `{{ params.project_id }}.gold.user_profiles_enriched` as upe
USING (SELECT * from `{{ params.project_id }}.silver.user_profiles`) as us_prof
    ON (upe.email = us_prof.email)
WHEN MATCHED THEN
    UPDATE SET
          upe.first_name = us_prof.first_name,
          upe.last_name = us_prof.last_name,
          upe.state = us_prof.state,
          upe.birth_date = us_prof.birth_date,
          upe.phone_number = us_prof.phone_number
;