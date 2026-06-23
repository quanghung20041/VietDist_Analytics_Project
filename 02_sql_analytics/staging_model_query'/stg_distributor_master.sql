CREATE TABLE staging.stg_distributor_master AS
SELECT
	distributor_id,
	distributor_name,
	tier,
	channel,
	province,
	region,
	contact_person,
	CONCAT('0',phone),
	email,
	tax_code,
	CAST(join_date AS DATE),
	CAST(credit_limit AS INT),
	status,
	assigned_supervisor_id
FROM raw.distributor_master;
