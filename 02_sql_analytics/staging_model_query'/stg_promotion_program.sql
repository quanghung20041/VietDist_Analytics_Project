CREATE TABLE staging.stg_promotion_program as
WITH promotion_explode AS (
	SELECT
	promotion_id,
	promotion_name,
	promotion_type,
	target_channel,
	target_region,
	CAST(start_date AS DATE),
	CAST(end_date AS DATE),
	UNNEST(STRING_TO_ARRAY( applicable_products, '|' )) AS applicable_product_id,
	CAST(discount_pct AS INTEGER),
	CAST(min_order_quantity AS INTEGER),
	CAST(budget_vnd AS INTEGER),
	CAST(actual_cost_vnd AS INTEGER),
	status,
	created_by
	FROM raw.promotion_program
)
SELECT
CONCAT(promotion_id,applicable_product_id) AS promotion_program_key,
*
FROM promotion_explode;