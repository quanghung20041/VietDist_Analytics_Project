CREATE TABLE staging.stg_product_master AS
SELECT
product_id,
product_name,
category,
sub_category,
unit,
CAST(unit_price AS INTEGER),
CAST(cost_price AS INTEGER),
CAST(weight_gram AS INTEGER),
status,
CAST(launch_date AS DATE) AS launch_date
FROM raw.product_master;

