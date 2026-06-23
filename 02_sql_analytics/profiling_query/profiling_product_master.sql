
WITH total_rows AS (

    SELECT COUNT(*) AS total_rows
    FROM raw.product_master

),

null_check AS (

    SELECT
        'product_id' AS column_name,

        SUM(
            CASE
                WHEN product_id IS NULL
                OR product_id = ''
                THEN 1
                ELSE 0
            END
        ) AS null_count

    FROM raw.product_master

    UNION ALL

    SELECT
        'product_name',

        SUM(
            CASE
                WHEN product_name IS NULL
                OR product_name = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.product_master

    UNION ALL

    SELECT
        'category',

        SUM(
            CASE
                WHEN category IS NULL
                OR category = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.product_master

),

duplicate_check AS (

    SELECT

        product_id,
        product_name,
        category,

        COUNT(*) AS duplicate_count

    FROM raw.product_master

    GROUP BY
        product_id,
        product_name,
        category

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
