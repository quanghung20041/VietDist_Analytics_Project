
WITH total_rows AS (

    SELECT COUNT(*) AS total_rows
    FROM raw.distributor_master

),

null_check AS (

    SELECT
        'distributor_id' AS column_name,

        SUM(
            CASE
                WHEN distributor_id IS NULL
                OR distributor_id = ''
                THEN 1
                ELSE 0
            END
        ) AS null_count

    FROM raw.distributor_master

    UNION ALL

    SELECT
        'distributor_name',

        SUM(
            CASE
                WHEN distributor_name IS NULL
                OR distributor_name = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.distributor_master

),

duplicate_check AS (

    SELECT

        distributor_id,
        distributor_name,
        tax_code,

        COUNT(*) AS duplicate_count

    FROM raw.distributor_master

    GROUP BY
        distributor_id,
        distributor_name,
        tax_code

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
