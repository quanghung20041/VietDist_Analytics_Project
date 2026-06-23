# DATA PROFILING REPORT

# 1. sales_transactions

## Total Rows

* 119,101 rows

## Null Analysis

| column_name | null_count | null_percentage |
|---|---|---|
| order_id | 0 | 0.00 |
| customer_id | 0 | 0.00 |
| employee_id | 0 | 0.00 |
| product_id | 0 | 0.00 |

## Duplicate Analysis

* 0 duplicated row

# 2. sales_target_versions

## Total Rows

* 1,950 rows

## Null Analysis
| column_name | null_count | null_percentage |
|---|---|---|
| employee_id | 0 | 0.00 |
| target_revenue | 0 | 0.00 |
| month | 0 | 0.00 |
| year | 0 | 0.00 |

## Duplicate Analysis

* 0 duplicated row

# 3. customer_master

## Total Rows

* 2,000 rows 

## Null Analysis
| column_name | null_count | null_percentage |
|---|---|---|
| customer_id | 0 | 0.00 |
| customer_type | 0 | 0.00 |
| channel | 0 | 0.00 |
| tax_code | 1,035 | 51.75 |

## Duplicate Analysis

* 0 duplicated row

## Cleaning Suggestion
* The null value of tax_code can be overlooked because the customer may not have requested a tax invoice.

# 4. product_master

## Total Rows

* 100 rows

## Null Analysis
| column_name | null_count | null_percentage |
|---|---|---|
| product_id | 0 | 0.00 |
| product_name | 0 | 0.00 |
| category | 0 | 0.00 |

## Duplicate Analysis

* 0 duplicated row

# 5. distributor_orders

## Total Rows

* 35,945 rows

## Null Analysis
| column_name | null_count | null_percentage |
|---|---|---|
| order_id | 0 | 0.00 |
| distributor_id | 0 | 0.00 |
| product_id | 0 | 0.00 |

## Duplicate Analysis

* 0 duplicated row

# 6. distributor_master

## Total Rows

* 138 rows

## Null Analysis
| column_name | null_count | null_percentage |
|---|---|---|
| distributor_id | 0 | 0.00 |
| distributor_name | 0 | 0.00 |

## Duplicate Analysis

* 0 duplicated row

# 7. employee_master

## Total Rows

* 228 rows

## Null Analysis
| column_name | null_count | null_percentage |
|---|---|---|
| employee_id | 0 | 0.00 |
| full_name | 0 | 0.00 |
| email | 0 | 0.00 |
| status | 0 | 0.00 |
| resign_date | 220 | 96.49 |
| transfer_note | 223 | 97.81|

## Duplicate Analysis

* 0 duplicated row

## Cleaning Suggestion
* The null data in 'resign_date' and 'transfer_note' can be ignore because it does not affect the analysis.

# 8. territory_mapping

## Total Rows

* 1,843 rows

## Null Analysis
| column_name | null_count | null_percentage |
|---|---|---|
| territory_id | 0 | 0.00 |
| employee_id | 0 | 0.00 |
| customer_id | 0 | 0.00 |

## Duplicate Analysis

* 0 duplicated row

# 9. return_transactions

## Total Rows

* 3,665 rows

## Null Analysis
| column_name | null_count | null_percentage |
|---|---|---|
| return_id | 0 | 0.00 |
| original_order_id | 0 | 0.00 |
| product_id | 0 | 0.00 |

## Duplicate Analysis

* 0 duplicated row

# 10. promotion_program

## Total Rows

* 40 rows

## Null Analysis
| column_name | null_count | null_percentage |
|---|---|---|
| promotion_id | 0 | 0.00 |
| promotion_name | 0 | 0.00 |
| promotion_type | 0 | 0.00 |

## Duplicate Analysis

* 0 duplicated row

## Other
* The column applicable_products contains multiple product's IDs concatenated by symbol "|"

## Cleaning Suggestion
* Split 'applicable_products' column using delimiter "|" and explode into multiple rows.