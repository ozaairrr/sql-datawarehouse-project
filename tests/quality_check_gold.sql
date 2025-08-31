/*
===============================================================================
Quality Checks for Gold Layer (MySQL)
===============================================================================
Purpose:
    Validate surrogate key uniqueness and referential integrity in Gold layer views.
    Investigate any discrepancies reported by these checks.
===============================================================================
*/

-- ====================================================================
-- Check uniqueness of cust_key in gold_dim_customers
-- Expectation: No duplicates should be returned
SELECT 
    cust_key,
    COUNT(*) AS duplicate_count
FROM gold_dim_customers
GROUP BY cust_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Check uniqueness of product_key in gold_dim_products
-- Expectation: No duplicates should be returned
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold_dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Check referential integrity between gold_fact_sales and dimension views
-- Expectation: No rows where product_key or cust_key in fact table are missing in dimensions
SELECT f.*
FROM gold_fact_sales f
LEFT JOIN gold_dim_customers c ON f.cust_key = c.cust_key
LEFT JOIN gold_dim_products p ON f.product_key = p.product_key
WHERE c.cust_key IS NULL OR p.product_key IS NULL;

