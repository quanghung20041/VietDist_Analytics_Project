WITH total_rows AS (

    SELECT COUNT(*) AS total_rows
    FROM raw.sales_target_versions

),

null_check AS (

    SELECT
        'employee_id' AS column_name,

        SUM(
            CASE
                WHEN employee_id IS NULL
                OR employee_id = ''
                THEN 1
                ELSE 0
            END
        ) AS null_count

    FROM raw.sales_target_versions

    UNION ALL

    SELECT
        'target_revenue',

        SUM(
            CASE
                WHEN target_revenue IS NULL
                OR target_revenue = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.sales_target_versions

    UNION ALL

    SELECT
        'month',

        SUM(
            CASE
                WHEN month IS NULL
                OR month = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.sales_target_versions
    
     UNION ALL

    SELECT
        'year',

        SUM(
            CASE
                WHEN year IS NULL
                OR year = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.sales_target_versions

),

duplicate_check AS (

    SELECT

        employee_id,
        year,
        month,
        plan_version,

        COUNT(*) AS duplicate_count

    FROM raw.sales_target_versions

    GROUP BY
        employee_id,
        year,
        month,
        plan_version

    HAVING COUNT(*) > 1

)

SELECT

    nc.column_name,
    tr.total_rows,
    nc.null_count,

    ROUND(
        100.0 * nc.null_count / tr.total_rows,
        2
    ) AS null_percentage,

    (
        SELECT COUNT(*)
        FROM duplicate_check
    ) AS total_duplicate_rows

FROM null_check AS nc

CROSS JOIN total_rows AS tr;
