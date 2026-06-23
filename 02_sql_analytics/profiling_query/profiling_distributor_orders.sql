
WITH total_rows AS (

    SELECT COUNT(*) AS total_rows
    FROM raw.distributor_orders

),

null_check AS (

    SELECT
        'order_id' AS column_name,

        SUM(
            CASE
                WHEN order_id IS NULL
                OR order_id = ''
                THEN 1
                ELSE 0
            END
        ) AS null_count

    FROM raw.distributor_orders

    UNION ALL

    SELECT
        'distributor_id',

        SUM(
            CASE
                WHEN distributor_id IS NULL
                OR distributor_id = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.distributor_orders

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

    FROM raw.distributor_orders

),

duplicate_check AS (

    SELECT

        order_id,
        distributor_id,
        product_id,
        qty_ordered,

        COUNT(*) AS duplicate_count

    FROM raw.distributor_orders

    GROUP BY
        order_id,
        distributor_id,
        product_id,
        qty_ordered

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
