CREATE TABLE dwh.dim_date AS
WITH date_table AS (
	SELECT
		GENERATE_SERIES(
			DATE '2022-01-01',
			DATE '2026-12-31',
			INTERVAL '1 day'
		)::DATE AS full_date
)

SELECT
	full_date,
	EXTRACT(DAY FROM full_date) AS day_num,
	EXTRACT(MONTH FROM full_date) AS month_num,
    TO_CHAR(full_date, 'Month') AS month_name,
    EXTRACT(QUARTER FROM full_date) AS quarter_num,
    EXTRACT(YEAR FROM full_date) AS calendar_year,
    (CASE
		WHEN EXTRACT(MONTH FROM full_date) >= 9
		THEN EXTRACT(YEAR FROM full_date)
		ELSE EXTRACT(YEAR FROM full_date) - 1
		END) AS fiscal_year
FROM date_table;
