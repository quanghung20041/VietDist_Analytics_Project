CREATE TABLE dwh.fact_sales AS

SELECT
	sales_transaction_key,
	order_id,
	order_date,
	customer_id,
	employee_id,
	product_id,
	quantity,
	unit_price,
	discount_pct,
	discount_amount,
	gross_amount,
	net_amount,
	delivery_status,
	payment_method,
	payment_status
FROM staging.stg_sales_transactions;