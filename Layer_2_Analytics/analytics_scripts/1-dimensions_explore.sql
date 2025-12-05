/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country 
FROM gold_dim_customers
ORDER BY country;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category, 
    sub_category, 
    product_name 
FROM gold_dim_products
ORDER BY category, sub_category, product_name;
