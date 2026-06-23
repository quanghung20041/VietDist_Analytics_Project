
WITH total_rows AS (

    SELECT COUNT(*) AS total_rows
    FROM raw.promotion_program

),

null_check AS (

    SELECT
        'promotion_id' AS column_name,

        SUM(
            CASE
                WHEN promotion_id IS NULL
                OR promotion_id = ''
                THEN 1
                ELSE 0
            END
        ) AS null_count

    FROM raw.promotion_program

    UNION ALL

    SELECT
        'promotion_name',

        SUM(
            CASE
                WHEN promotion_name IS NULL
                OR promotion_name = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.promotion_program

    UNION ALL

    SELECT
        'promotion_type',

        SUM(
            CASE
                WHEN promotion_type IS NULL
                OR promotion_type = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.promotion_program

),

duplicate_check AS (

    SELECT

        promotion_id,
        promotion_name,
        start_date,
        end_date,

        COUNT(*) AS duplicate_count

    FROM raw.promotion_program

    GROUP BY
        promotion_id,
        promotion_name,
        start_date,
        end_date

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

