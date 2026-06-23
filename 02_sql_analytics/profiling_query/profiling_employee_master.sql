
WITH total_rows AS (

    SELECT COUNT(*) AS total_rows
    FROM raw.employee_master

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

    FROM raw.employee_master

    UNION ALL

    SELECT
        'full_name',

        SUM(
            CASE
                WHEN full_name IS NULL
                OR full_name = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.employee_master

    UNION ALL

    SELECT
        'email',

        SUM(
            CASE
                WHEN email IS NULL
                OR email = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.employee_master
    
    UNION ALL

    SELECT
        'resign_date',

        SUM(
            CASE
                WHEN resign_date IS NULL
                OR resign_date = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.employee_master
	
    UNION ALL

    SELECT
        'transfer_note',

        SUM(
            CASE
                WHEN transfer_note IS NULL
                OR transfer_note = ''
                THEN 1
                ELSE 0
            END
        )

    FROM raw.employee_master
),

duplicate_check AS (

    SELECT

        employee_id,
        full_name,
        version,

        COUNT(*) AS duplicate_count

    FROM raw.employee_master

    GROUP BY
        employee_id,
        full_name,
        version

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
