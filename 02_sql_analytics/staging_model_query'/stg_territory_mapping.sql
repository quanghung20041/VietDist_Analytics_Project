CREATE TABLE staging.stg_territory_mapping AS
SELECT
territory_id,
employee_id,
customer_id,
region,
team,
CAST(effective_date AS DATE),
CAST(expiry_date AS DATE),
version
FROM raw.territory_mapping;
