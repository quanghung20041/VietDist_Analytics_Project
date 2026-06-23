CREATE TABLE staging.stg_sales_targets_versioned AS
WITH ranked_versions AS (
    SELECT
		sales_target_key,
		plan_version,
		effective_from,
		effective_to,
		employee_id,
		employee_name,
		region,
		team,
		year,
		month,
		target_revenue,
		target_quantity,
		target_new_customers,
		ROW_NUMBER() OVER (
			PARTITION BY
				employee_id,
				year,
				month
			ORDER BY effective_from DESC
		) AS rn
	FROM staging.stg_sales_target_versions)

SELECT
	sales_target_key,
	plan_version,
	effective_from,
	effective_to,
	employee_id,
	employee_name,
	region,
	team,
	year,
	month,
	target_revenue,
	target_quantity,
	target_new_customers
FROM ranked_versions
WHERE rn = 1;
