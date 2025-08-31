
/*
===============================================================================
Quality Checks for Silver Layer
===============================================================================
Purpose:
    Validate data consistency, accuracy, and standardization in Silver layer tables.
    Identify nulls, duplicates, invalid dates, whitespace issues, and data inconsistencies.
    Address all issues found before progressing to Gold layer.
===============================================================================
*/

-- ====================================================================
-- Checking silver_crm_cust_info
-- ====================================================================

-- Check NULLs or duplicate cst_id (primary key)
SELECT 
    cst_id,
    COUNT(*) AS cnt
FROM silver_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces in cst_key
SELECT 
    cst_key
FROM silver_crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Check distinct values in cst_marital_status
SELECT DISTINCT 
    cst_marital_status
FROM silver_crm_cust_info;

-- ====================================================================
-- Checking silver_crm_prd_info
-- ====================================================================

-- Check NULLs or duplicate prd_id
SELECT 
    prd_id,
    COUNT(*) AS cnt
FROM silver_crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces in prd_nm
SELECT 
    prd_nm
FROM silver_crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULL or negative prd_cost
SELECT 
    prd_cost
FROM silver_crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check distinct prd_line values
SELECT DISTINCT 
    prd_line
FROM silver_crm_prd_info;

-- Check for invalid date order: prd_end_dt < prd_start_dt
SELECT * 
FROM silver_crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking silver_crm_sales_details
-- ====================================================================

-- Check for invalid sls_due_dt dates (non-date or out of expected range)
-- MySQL doesn’t have LEN(), use LENGTH() and date validations on DATE type
SELECT 
    sls_due_dt
FROM silver_crm_sales_details
WHERE sls_due_dt IS NULL 
    OR sls_due_dt < '1900-01-01' 
    OR sls_due_dt > '2050-01-01';

-- Check invalid date order: sls_order_dt > sls_ship_dt or > sls_due_dt
SELECT *
FROM silver_crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Check consistency: sales = quantity * price, no nulls or negative values
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price
FROM silver_crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Checking silver_erp_cust_az12
-- ====================================================================

-- Birthdates range check (between 1924-01-01 and current date)
SELECT DISTINCT 
    bdate
FROM silver_erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > CURDATE();

-- Distinct gender values
SELECT DISTINCT 
    gen
FROM silver_erp_cust_az12;

-- ====================================================================
-- Checking silver_erp_loc_a101
-- ====================================================================

-- Distinct country values for consistency check
SELECT DISTINCT 
    cntry
FROM silver_erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking silver_erp_px_cat_g1v2
-- ====================================================================

-- Check for unwanted spaces in category fields
SELECT * 
FROM silver_erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Distinct maintenance field values
SELECT DISTINCT 
    maintenance
FROM silver_erp_px_cat_g1v2;
