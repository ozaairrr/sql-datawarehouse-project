/*
================================================================================
Bronze Layer: Table Creation Script
================================================================================
This script creates all Bronze layer tables for raw data ingestion.

- Drops existing tables if they exist.
- Creates tables with appropriate columns and data types.
================================================================================
*/

-- Drop and create CRM Customer Info table
DROP TABLE IF EXISTS bronze_crm_info;
CREATE TABLE bronze_crm_info (
    cst_id              INT,
    cst_key             VARCHAR(50),
    cst_firstname       VARCHAR(50),
    cst_lastname        VARCHAR(50),
    cst_marital_status  VARCHAR(50),
    cst_gndr            VARCHAR(50),
    cst_create_date     DATE
);

-- Drop and create Product Info table
DROP TABLE IF EXISTS bronze_prd_info;
CREATE TABLE bronze_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     INT,
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   VARCHAR(50)
);

-- Drop and create Sales Details table
DROP TABLE IF EXISTS bronze_sales_details;
CREATE TABLE bronze_sales_details (
    sls_ord_num VARCHAR(50) CHARACTER SET utf8mb4,
    sls_prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales VARCHAR(50),
    sls_quantity INT,
    sls_price VARCHAR(50)
);

-- Drop and create ERP Location table
DROP TABLE IF EXISTS bronze_erp_loc_a101;
CREATE TABLE bronze_erp_loc_a101 (
    cid VARCHAR(50) CHARACTER SET utf8mb4,
    cntry VARCHAR(50) CHARACTER SET utf8mb4
);

-- Drop and create ERP Customer table
DROP TABLE IF EXISTS bronze_erp_cust_az12;
CREATE TABLE bronze_erp_cust_az12 (
    cid VARCHAR(50) CHARACTER SET utf8mb4,
    bdate VARCHAR(50) CHARACTER SET utf8mb4,
    gen VARCHAR(50) CHARACTER SET utf8mb4
);

-- Drop and create ERP Product Category table
DROP TABLE IF EXISTS bronze_erp_px_cat_g1v2;
CREATE TABLE bronze_erp_px_cat_g1v2 (
    id VARCHAR(50) CHARACTER SET utf8mb4,
    cat VARCHAR(50) CHARACTER SET utf8mb4,
    subcat VARCHAR(50) CHARACTER SET utf8mb4,
    maintenance VARCHAR(50) CHARACTER SET utf8mb4
);
