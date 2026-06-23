CREATE TABLE staging.stg_employee_master AS
SELECT
employee_id,
full_name,
gender,
CAST(date_of_birth AS DATE),
CAST(join_date AS DATE),
position,
region,
team,
email,
CONCAT('0',phone) AS phone,
status,
version,
CAST(effective_date AS DATE),
CAST(resign_date AS DATE),
transfer_note

FROM raw.employee_master;