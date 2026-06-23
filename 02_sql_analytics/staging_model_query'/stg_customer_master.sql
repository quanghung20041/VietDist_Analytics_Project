CREATE TABLE staging.stg_customer_master AS
SELECT
	customer_id,
	customer_name,
	customer_type,
	channel,
	province,
	region,
	address,
	CONCAT('0',phone),
	tax_code,
	CAST(join_date AS DATE),
	CAST(credit_limit AS INTEGER),
	status
FROM raw.customer_master;
