CREATE TABLE staging.stg_sales_target_versions AS
SELECT
	CONCAT(employee_id, '_', month, '_', year,'_', plan_version) AS sales_target_key,
	plan_version,
	CAST(effective_from AS DATE),
	CAST(effective_to AS DATE),
	employee_id,
	employee_name,
	region,
	team,
	CAST(year AS INTEGER),
	CAST(month AS INTEGER),
	CAST(target_revenue AS INTEGER),
	CAST(target_quantity AS INTEGER),
	CAST(target_new_customers AS INTEGER)
FROM raw.sales_target_versions;