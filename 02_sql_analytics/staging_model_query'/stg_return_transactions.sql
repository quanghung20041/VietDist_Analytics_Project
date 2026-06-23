CREATE TABLE staging.stg_return_transactions AS
SELECT
return_id,
original_order_id,
CAST(return_date AS DATE),
CAST(return_month AS INT),
customer_id,
employee_id,
product_id,
region,
province,
CAST(return_quantity AS INTEGER),
CAST(unit_price AS INTEGER),
CAST(return_amount AS INTEGER),
return_reason,
status
FROM raw.return_transactions;
