/*
================================================================================
Stored Procedure: Load Bronze Layer Data
================================================================================
Purpose:
    Loads raw CSV data into Bronze tables with full refresh.

Operations:
    - Truncates each target table.
    - Loads CSV files into tables.
    - For crm_info, uses a temporary staging table to clean empty strings to NULL
================================================================================
*/

-- CALL load_bronze_data();

DELIMITER //
CREATE PROCEDURE load_bronze_data()
BEGIN
    -- Load CRM Customer Info
    TRUNCATE TABLE bronze_crm_info;

    CREATE TEMPORARY TABLE TEMP_crm_info (
        cst_id              VARCHAR(50),
        cst_key             VARCHAR(50),
        cst_firstname       VARCHAR(50),
        cst_lastname        VARCHAR(50),
        cst_marital_status  VARCHAR(50),
        cst_gndr            VARCHAR(50),
        cst_create_date     VARCHAR(50)
    );

    LOAD DATA INFILE 'C:/MySQLData/Uploads/cust_info.csv'
    INTO TABLE TEMP_crm_info
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;

    UPDATE TEMP_crm_info 
    SET 
        cst_id = NULLIF(cst_id, ''),
        cst_key = NULLIF(cst_key, ''),
        cst_firstname = NULLIF(cst_firstname, ''),
        cst_lastname = NULLIF(cst_lastname, ''),
        cst_marital_status = NULLIF(cst_marital_status, ''),
        cst_gndr = NULLIF(cst_gndr, ''),
        cst_create_date = NULLIF(cst_create_date, '');

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

    DROP TEMPORARY TABLE IF EXISTS TEMP_crm_info;

    -- Load Product Info
    TRUNCATE TABLE bronze_prd_info;
    LOAD DATA INFILE 'C:/MySQLData/Uploads/prd_info.csv'
    INTO TABLE bronze_prd_info
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES
    (prd_id, prd_key, prd_nm, @prd_cost, prd_line, prd_start_dt, prd_end_dt)
    SET prd_cost = NULLIF(@prd_cost, '');

    -- Load Sales Details
    TRUNCATE TABLE bronze_sales_details;
    LOAD DATA INFILE 'C:/MySQLData/Uploads/sales_details.csv'
    INTO TABLE bronze_sales_details
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;

    -- Load ERP Location
    TRUNCATE TABLE bronze_erp_loc_a101;
    LOAD DATA INFILE 'C:/MySQLData/Uploads/LOC_A101.csv'
    INTO TABLE bronze_erp_loc_a101
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;

    -- Load ERP Customer
    TRUNCATE TABLE bronze_erp_cust_az12;
    LOAD DATA INFILE 'C:/MySQLData/Uploads/CUST_AZ12.csv'
    INTO TABLE bronze_erp_cust_az12
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;

    -- Load ERP Product Category
    TRUNCATE TABLE bronze_erp_px_cat_g1v2;
    LOAD DATA INFILE 'C:/MySQLData/Uploads/PX_CAT_G1V2.csv'
    INTO TABLE bronze_erp_px_cat_g1v2
    FIELDS TERMINATED BY ','
    IGNORE 1 LINES;
END //

DELIMITER ;
