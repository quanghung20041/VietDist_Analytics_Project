WITH total_rows AS (
    SELECT
        COUNT(*) AS total_rows
    FROM raw.sales_transactions
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
    FROM raw.sales_transactions
    
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
    FROM raw.sales_transactions

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
    FROM raw.sales_transactions

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
    FROM raw.sales_transactions
),

duplicate_check AS (
    SELECT
        order_id,
        order_date,
        customer_id,
        employee_id,
        product_id,
        quantity,
        net_amount,
        COUNT(*) AS duplicate_count
    FROM raw.sales_transactions
    GROUP BY
        order_id,
        order_date,
        customer_id,
        employee_id,
        product_id,
        quantity,
        net_amount
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
