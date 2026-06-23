WITH total_rows AS (

    SELECT COUNT(*) AS total_rows
    FROM raw.customer_master

),

null_check AS (

    SELECT
        'customer_id' AS column_name,

        SUM(
            CASE
                WHEN customer_id IS NULL
                OR customer_id = ''
                THEN 1
                ELSE 0
            END
        ) AS null_count

    FROM raw.customer_master

    UNION ALL

    SELECT
        'customer_type',

        SUM(
            CASE
                WHEN customer_type IS NULL
                OR customer_type = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.customer_master

    UNION ALL

    SELECT
        'channel',

        SUM(
            CASE
                WHEN channel IS NULL
                OR channel = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.customer_master
    
    UNION ALL

    SELECT
       'tax_code',

       SUM(
            CASE
                WHEN tax_code IS NULL
                OR tax_code = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.customer_master

),

duplicate_check AS (

    SELECT

        customer_id,
        customer_name,
        phone,

        COUNT(*) AS duplicate_count

    FROM raw.customer_master

    GROUP BY
        customer_id,
        customer_name,
        phone

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

