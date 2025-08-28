/*
================================================================================
Bronze Layer: Table Creation and Data Loading Script
================================================================================
This script performs:
 - Re-creation of bronze schema tables (dropping old ones)
 - Data loading from CSV files using LOAD DATA INFILE
 - Basic data cleanup (NULL for empty strings)
 - Data transformation for date and numeric fields during inserts
================================================================================
*/

/* ----------------------------------------------------------------------------
-- CRM Customer Info Table
---------------------------------------------------------------------------- */

-- Clear existing data for full reload
TRUNCATE TABLE bronze_crm_info;

-- Drop and recreate main table
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

-- Temporary staging table for flexible loading
CREATE TEMPORARY TABLE TEMP_crm_info (
    cst_id              VARCHAR(50),
    cst_key             VARCHAR(50),
    cst_firstname       VARCHAR(50),
    cst_lastname        VARCHAR(50),
    cst_marital_status  VARCHAR(50),
    cst_gndr            VARCHAR(50),
    cst_create_date     VARCHAR(50)
);

-- Load raw CSV data into temp table
LOAD DATA INFILE 'C:/MySQLData/Uploads/cust_info.csv'
INTO TABLE TEMP_crm_info
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

-- Clean empty strings to NULLs in temp table
UPDATE TEMP_crm_info 
SET 
    cst_id = NULLIF(cst_id, ''),
    cst_key = NULLIF(cst_key, ''),
    cst_firstname = NULLIF(cst_firstname, ''),
    cst_lastname = NULLIF(cst_lastname, ''),
    cst_marital_status = NULLIF(cst_marital_status, ''),
    cst_gndr = NULLIF(cst_gndr, ''),
    cst_create_date = NULLIF(cst_create_date, '');

-- Insert cleaned and transformed data into main table
INSERT INTO bronze_crm_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    CAST(cst_id AS SIGNED),
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    STR_TO_DATE(cst_create_date, '%Y-%m-%d')
FROM TEMP_crm_info;

-- Verify inserted data
SELECT * FROM bronze_crm_info;


/* ----------------------------------------------------------------------------
-- Product Info Table
---------------------------------------------------------------------------- */

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

SHOW CREATE TABLE bronze_prd_info;

TRUNCATE TABLE bronze_prd_info;

LOAD DATA INFILE 'C:/MySQLData/Uploads/prd_info.csv'
INTO TABLE bronze_prd_info
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(prd_id, prd_key, prd_nm, @prd_cost, prd_line, prd_start_dt, prd_end_dt)
SET prd_cost = NULLIF(@prd_cost, '');

SELECT * FROM bronze_prd_info;


/* ----------------------------------------------------------------------------
-- Sales Details Table
---------------------------------------------------------------------------- */

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

TRUNCATE TABLE bronze_sales_details;

LOAD DATA INFILE 'C:/MySQLData/Uploads/sales_details.csv'
INTO TABLE bronze_sales_details
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SELECT * FROM bronze_sales_details;


/* ----------------------------------------------------------------------------
-- ERP Location Table
---------------------------------------------------------------------------- */

DROP TABLE IF EXISTS bronze_erp_loc_a101;

CREATE TABLE bronze_erp_loc_a101 (
    cid VARCHAR(50) CHARACTER SET utf8mb4,
    cntry VARCHAR(50) CHARACTER SET utf8mb4
);

TRUNCATE TABLE bronze_erp_loc_a101;

LOAD DATA INFILE 'C:/MySQLData/Uploads/LOC_A101.csv'
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ','
IGNORE 1 LINES;


/* ----------------------------------------------------------------------------
-- ERP Customer Table
---------------------------------------------------------------------------- */

DROP TABLE IF EXISTS bronze_erp_cust_az12;

CREATE TABLE bronze_erp_cust_az12 (
    cid VARCHAR(50) CHARACTER SET utf8mb4,
    bdate VARCHAR(50) CHARACTER SET utf8mb4,
    gen VARCHAR(50) CHARACTER SET utf8mb4
);

TRUNCATE TABLE bronze_erp_cust_az12;

LOAD DATA INFILE 'C:/MySQLData/Uploads/CUST_AZ12.csv'
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ','
IGNORE 1 LINES;


/* ----------------------------------------------------------------------------
-- ERP Product Category Table
---------------------------------------------------------------------------- */

DROP TABLE IF EXISTS bronze_erp_px_cat_g1v2;

CREATE TABLE bronze_erp_px_cat_g1v2 (
    id VARCHAR(50) CHARACTER SET utf8mb4,
    cat VARCHAR(50) CHARACTER SET utf8mb4,
    subcat VARCHAR(50) CHARACTER SET utf8mb4,
    maintenance VARCHAR(50) CHARACTER SET utf8mb4
);

TRUNCATE TABLE bronze_erp_px_cat_g1v2;

LOAD DATA INFILE 'C:/MySQLData/Uploads/PX_CAT_G1V2.csv'
INTO TABLE bronze_erp_px_cat_g1v2
FIELDS TERMINATED BY ','
IGNORE 1 LINES;
