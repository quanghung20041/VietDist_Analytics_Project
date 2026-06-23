
WITH total_rows AS (

    SELECT COUNT(*) AS total_rows
    FROM raw.return_transactions

),

null_check AS (

    SELECT
        'return_id' AS column_name,

        SUM(
            CASE
                WHEN return_id IS NULL
                OR return_id = ''
                THEN 1
                ELSE 0
            END
        ) AS null_count

    FROM raw.return_transactions

    UNION ALL

    SELECT
        'original_order_id',

        SUM(
            CASE
                WHEN original_order_id IS NULL
                OR original_order_id = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.return_transactions

    UNION ALL

    SELECT
        'product_id',

        SUM(
            CASE
                WHEN product_id IS NULL
                OR product_id = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.return_transactions

),

duplicate_check AS (

    SELECT

        return_id,
        original_order_id,
        product_id,

        COUNT(*) AS duplicate_count

    FROM raw.return_transactions

    GROUP BY
        return_id,
        original_order_id,
        product_id

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

