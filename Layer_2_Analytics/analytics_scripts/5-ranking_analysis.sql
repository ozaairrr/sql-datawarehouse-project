/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.
SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER()
    - Clauses: GROUP BY, ORDER BY, LIMIT
===============================================================================
*/
-- Which 5 products are generating the highest revenue? (Simple Ranking)
SELECT 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold_fact_sales f
LEFT JOIN gold_dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Complex but flexible ranking using window functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold_fact_sales f
    LEFT JOIN gold_dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold_fact_sales f
LEFT JOIN gold_dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC
LIMIT 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT 
    c.cust_key,
    c.firstname,
    c.lastname,
    SUM(f.sales_amount) AS total_revenue
FROM gold_fact_sales f
LEFT JOIN gold_dim_customers c
    ON c.cust_key = f.cust_key
GROUP BY 
    c.cust_key,
    c.firstname,
    c.lastname
ORDER BY total_revenue DESC
LIMIT 10;

-- The 3 customers with the fewest orders placed
SELECT 
    c.cust_key,
    c.firstname,
    c.lastname,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold_fact_sales f
LEFT JOIN gold_dim_customers c
    ON c.cust_key = f.cust_key
GROUP BY 
    c.cust_key,
    c.firstname,
    c.lastname
ORDER BY total_orders ASC
LIMIT 3;
