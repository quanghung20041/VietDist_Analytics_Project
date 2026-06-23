CREATE TABLE dwh.dim_employees AS
WITH ordered_versions AS (
	SELECT
		employee_id,
		full_name,
		gender,
		date_of_birth,
		join_date,
		position,
		region,
		team,
		email,
		phone,
		status,
		version,
		effective_date,
		resign_date,
		transfer_note,
		LEAD(effective_date) OVER (
			PARTITION BY employee_id
			ORDER BY effective_date
		) AS next_effective_date
	FROM staging.stg_employee_master
)

SELECT
	CONCAT (employee_id,'_',version) AS employee_version_key,
	employee_id,
	full_name,
	gender,
	date_of_birth,
	join_date,
	position,
	region,
	team,
	email,
	phone,
	status,
	version,
	effective_date AS effective_from,
	(CASE WHEN next_effective_date IS NOT NULL
		THEN next_effective_date - INTERVAL '1 day'
		ELSE NULL
	END)::date AS effective_to,
	resign_date,
	transfer_note,
	(CASE WHEN next_effective_date IS NULL
		THEN TRUE
		ELSE FALSE
	END) AS is_current
FROM ordered_versions;