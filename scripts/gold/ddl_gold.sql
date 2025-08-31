/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold_dim_customers
-- =============================================================================
-- Adds a surrogate key with ROW_NUMBER for unique customer keys
-- Joins CRM customer info with ERP customer demographic and location data
CREATE VIEW gold_dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY cst_id) AS cust_key,  -- Surrogate key for customer dimension
	ci.cst_id AS customer_id,                       -- Original customer ID from CRM
	ci.cst_key AS customer_number,                  -- Customer key identifier
	ci.cst_firstname AS firstname,                  -- Customer first name
	ci.cst_lastname AS lastname,                    -- Customer last name
	ci.cst_marital_status AS marital_status,       -- Marital status from CRM
	la.cntry AS country,                            -- Customer country from ERP location data
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr   -- Use gender from CRM if available
        ELSE COALESCE(ca.gen, 'n/a')                  -- Otherwise, fall back to ERP gender or 'n/a'
	END gender,
	ca.bdate AS birthdate,                          -- Customer birthdate from ERP demographic data
	ci.cst_create_date AS create_date               -- Customer record creation date from CRM
FROM silver_crm_cust_info ci
LEFT JOIN silver_erp_cust_az12 ca ON ci.cst_key = ca.cid   -- Join with ERP customer demographics
LEFT JOIN silver_erp_loc_a101 la ON ci.cst_key = la.cid;   -- Join with ERP location info

-- =============================================================================
-- Create Dimension: gold_dim_products
-- =============================================================================
-- Adds surrogate key product_key for unique products
-- Joins product master with product category details from ERP
-- Filters out historical/inactive products (where prd_end_dt is NOT NULL)
CREATE VIEW gold_dim_products AS 
SELECT 
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,  -- Surrogate product key
	pn.prd_id AS product_id,                 -- Original product ID
	pn.prd_key AS product_number,            -- Product key identifier
	pn.prd_nm AS product_name,               -- Product name
	pn.cat_id AS category_id,                -- Product category ID
	pc.cat AS category,                      -- Product category name
	pc.subcat AS sub_category,               -- Product sub-category
	pc.maintenance,                         -- Maintenance info from ERP
	pn.prd_cost AS cost,                     -- Product cost
	pn.prd_line AS product_line,             -- Product line classification
	pn.prd_start_dt AS start_date            -- Product effective start date
FROM silver_crm_prd_info pn
LEFT JOIN silver_erp_px_cat_g1v2 pc ON pn.cat_id = pc.id  -- Join with ERP product categories
WHERE pn.prd_end_dt IS NULL;                                -- Include only active products


-- =============================================================================
-- Create Fact Table: gold_fact_sales
-- =============================================================================
-- Combines sales transaction details with customer and product dimensions
-- Provides key metrics: sales amount, quantity, price, and relevant dates
CREATE VIEW gold_fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,             -- Sales order number
    pr.product_key,                             -- Surrogate product key from product dimension
    cu.cust_key,                               -- Surrogate customer key from customer dimension
    sd.sls_order_dt AS order_date,             -- Order date
    sd.sls_ship_dt AS shipping_date,           -- Shipping date
    sd.sls_due_dt AS due_date,                  -- Due date for payment
    sd.sls_sales AS sales_amount,               -- Total sales amount
    sd.sls_quantity AS quantity,                 -- Quantity sold
    sd.sls_price AS price                        -- Sales price per unit
FROM silver_crm_sales_details sd
LEFT JOIN gold_dim_products pr ON sd.sls_prd_key = pr.product_number   -- Join with product dimension
LEFT JOIN gold_dim_customers cu ON sd.sls_cust_id = cu.customer_id;    -- Join with customer dimension
