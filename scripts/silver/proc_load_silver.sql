/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Purpose:
    Performs the ETL process to populate Silver layer tables from Bronze layer.
    Includes data cleansing, transformation, and standardization.
    
Actions:
    - Truncates Silver tables before loading (full refresh).
    - Inserts cleaned and transformed data from Bronze tables.
    - Handles date conversions, null corrections, and standardized values.

Usage:
    CALL silver_load_procedure();
===============================================================================
*/
DELIMITER //
CREATE PROCEDURE silver_load_procedure()
BEGIN
    -- Load silver_crm_cust_info with latest customer records and cleaned attributes
    TRUNCATE TABLE silver_crm_cust_info;
    INSERT INTO silver_crm_cust_info
    (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname) as cst_firstname,
        TRIM(cst_lastname) as cst_lastname,
        CASE 
            WHEN TRIM(cst_marital_status) = 'M' THEN 'Married'
            WHEN TRIM(cst_marital_status) = 'S' THEN 'Single'
            ELSE 'N/A'
        END cst_marital_status,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            ELSE 'N/A'
        END cst_gndr,
        cst_create_date
    FROM
    (
        SELECT *,
        ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag
        FROM bronze_crm_cust_info
    ) t 
    WHERE flag = 1;

    -- Load silver_crm_prd_info with product info and normalized categories
    TRUNCATE TABLE silver_crm_prd_info;
    INSERT INTO silver_crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
        SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
        prd_nm,
        IFNULL(prd_cost, 0) AS prd_cost,
        CASE
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,
        prd_start_dt,
        CAST(DATE_SUB(LEAD(prd_start_dt, 1) OVER (PARTITION BY prd_key ORDER BY prd_start_dt), INTERVAL 1 DAY) AS DATE) AS prd_end_dt
    FROM bronze_crm_prd_info;

    -- Load silver_crm_sales_details with cleansed and validated sales data
    TRUNCATE TABLE silver_crm_sales_details;
    INSERT INTO silver_crm_sales_details
    (
        sls_ord_num, 
        sls_prd_key, 
        sls_cust_id,  
        sls_order_dt, 
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE
            WHEN sls_order_dt = 0 THEN NULL
            WHEN LENGTH(sls_order_dt) != 8 THEN NULL
            ELSE CAST(sls_order_dt AS DATE)
        END sls_order_dt,
        CASE
            WHEN sls_ship_dt = 0 THEN NULL
            WHEN LENGTH(sls_ship_dt) != 8 THEN NULL
            ELSE CAST(sls_ship_dt AS DATE)
        END sls_ship_dt,
        CASE
            WHEN sls_due_dt = 0 THEN NULL
            WHEN LENGTH(sls_due_dt) != 8 THEN NULL
            ELSE CAST(sls_due_dt AS DATE)
        END sls_due_dt,
        CASE 
            WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * sls_price THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END sls_sales,
        sls_quantity,
        CASE 
            WHEN sls_price IS NULL THEN sls_sales / sls_quantity
            WHEN sls_price <= 0 THEN sls_sales / sls_quantity
            ELSE sls_price
        END sls_price
    FROM bronze_crm_sales_details;

    -- Load silver_erp_cust_az12 with transformed customer demographic data
    TRUNCATE TABLE silver_erp_cust_az12;
    INSERT INTO silver_erp_cust_az12
    (
        cid, 
        bdate,
        gen
    )
    SELECT 
        CASE 
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4)
            ELSE cid
        END cid,
        CASE 
            WHEN STR_TO_DATE(bdate, '%d-%m-%Y') > CURRENT_DATE() THEN NULL
            ELSE STR_TO_DATE(bdate, '%d-%m-%Y')
        END bdate,
        CASE
            WHEN UPPER(TRIM(REPLACE(gen,'\r',''))) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(REPLACE(gen,'\r',''))) IN ('M','MALE') THEN 'Male'
            ELSE 'n/a'
        END AS gen
    FROM bronze_erp_cust_az12;

    -- Load silver_erp_loc_a101 with cleaned location data
    TRUNCATE TABLE silver_erp_loc_a101;
    INSERT INTO silver_erp_loc_a101 
    (cid, cntry)
    SELECT
        REPLACE(cid,'-','') as cid,
        CASE 
            WHEN TRIM(REPLACE(cntry,'\r',''))='DE' THEN 'Germany'
            WHEN TRIM(REPLACE(cntry,'\r','')) IN('US','USA') THEN 'United States'
            WHEN TRIM(REPLACE(cntry,'\r',''))='' OR cntry IS NULL THEN 'n/a'
            ELSE cntry
        END cntry
    FROM bronze_erp_loc_a101;

    -- Append silver_erp_px_cat_g1v2 from bronze without transformation
    INSERT INTO silver_erp_px_cat_g1v2 (
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM bronze_erp_px_cat_g1v2;
END //
DELIMITER ;
