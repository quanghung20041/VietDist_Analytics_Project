CREATE TABLE dwh.mart_sales_vs_target AS

WITH first_customer_orders AS (

    SELECT

        customer_id,

        MIN(order_date)
        AS first_order_date

    FROM dwh.fact_sales

    GROUP BY customer_id

),
	
actual_sales AS (

    SELECT

        fs.employee_id,


        EXTRACT(YEAR FROM fs.order_date)
        AS year,


        EXTRACT(MONTH FROM fs.order_date)
        AS month,


        SUM(fs.net_amount)
        AS actual_revenue,


        SUM(fs.quantity)
        AS actual_quantity,


        COUNT(DISTINCT fs.order_id)
        AS total_orders,


        COUNT(

            DISTINCT CASE

                WHEN fs.order_date = fco.first_order_date

                THEN fs.customer_id

            END

        ) AS actual_new_customers

    FROM dwh.fact_sales fs


    LEFT JOIN first_customer_orders fco

        ON fs.customer_id = fco.customer_id


    GROUP BY

        fs.employee_id,

        EXTRACT(YEAR FROM fs.order_date),

        EXTRACT(MONTH FROM fs.order_date)

),

targets AS (

    SELECT

        employee_id,

        employee_name,

        region,

        team,

        year,

        month,

        plan_version,

        target_revenue,

        target_quantity,

        target_new_customers

    FROM staging.stg_sales_targets_versioned

)

SELECT

    t.employee_id,

    t.employee_name,

    t.region,

    t.team,

    t.year,

    t.month,

    t.plan_version,

    t.target_revenue,

    t.target_quantity,

    t.target_new_customers,

    COALESCE(a.actual_revenue, 0)
    AS actual_revenue,


    COALESCE(a.actual_quantity, 0)
    AS actual_quantity,


    COALESCE(a.total_orders, 0)
    AS total_orders,

	actual_new_customers,

    ROUND(

        (

            100.0 *

            COALESCE(a.actual_revenue, 0)

            / NULLIF(t.target_revenue, 0)

        )::NUMERIC,

        2

    ) AS percent_revenue_achieve,

    ROUND(

        (

            100.0 *

            COALESCE(a.actual_quantity, 0)

            / NULLIF(t.target_quantity, 0)

        )::NUMERIC,

        2

    ) AS percent_quantity_achieve

FROM targets t


LEFT JOIN actual_sales a

    ON t.employee_id = a.employee_id

    AND t.year = a.year

    AND t.month = a.month;

