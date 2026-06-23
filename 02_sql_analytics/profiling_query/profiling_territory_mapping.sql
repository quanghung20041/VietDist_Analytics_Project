
WITH total_rows AS (

    SELECT COUNT(*) AS total_rows
    FROM raw.territory_mapping

),

null_check AS (

    SELECT
        'territory_id' AS column_name,

        SUM(
            CASE
                WHEN territory_id IS NULL
                OR territory_id = ''
                THEN 1
                ELSE 0
            END
        ) AS null_count

    FROM raw.territory_mapping

    UNION ALL

    SELECT
        'employee_id',

        SUM(
            CASE
                WHEN employee_id IS NULL
                OR employee_id = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.territory_mapping

    UNION ALL

    SELECT
        'customer_id',

        SUM(
            CASE
                WHEN customer_id IS NULL
                OR customer_id = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.territory_mapping

),

duplicate_check AS (

    SELECT

        territory_id,
        employee_id,
        customer_id,

        COUNT(*) AS duplicate_count

    FROM raw.territory_mapping

    GROUP BY
        territory_id,
        employee_id,
        customer_id

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

