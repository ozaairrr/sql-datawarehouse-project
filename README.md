# Data Warehouse Project

## Project Overview
This project implements a multi-layered data warehouse following the Bronze, Silver, and Gold architecture. It covers data ingestion, cleansing, transformation, and dimensional modeling to provide clean, consistent, and analytics-ready data.

## Layers and Structure
- **Bronze Layer:** Raw source data ingestion and storage with minimal processing.
- **Silver Layer:** Cleansed, standardized, and enriched data for further analysis.
- **Gold Layer:** Curated, business-friendly dimensional views and fact tables for reporting and analytics.

## Key Features
- Automated ETL procedures from Bronze to Silver layer.
- Comprehensive data quality checks for each layer.
- Use of surrogate keys and dimensional modeling in Gold layer.
- Data standardization for gender, marital status, product categorization, and dates.
- Use of MySQL views for simplified access to analytical data.

## Technologies Used
- MySQL 8.0 for database management and SQL querying.
- SQL scripts for ETL and data quality checks.
- Stored procedures to automate data transformations.

## How to Use
1. Load raw data files into the Bronze tables.
2. Run the stored procedure `silver_load_procedure()` to populate Silver layer.
3. Use the Gold layer views for analytics and reporting.
4. Execute provided SQL scripts for data quality verification.

## Project Structure
/sql
├── bronze_layer.sql
├── silver_layer.sql
├── gold_layer_views.sql
├── silver_load_procedure.sql
└── data_quality_checks.sql
/README.md

## Future Improvements
- Implement incremental loading strategies for scalability.
- Add indexing and partitioning for performance optimization.
- Enhance error handling and logging during ETL.
- Expand quality checks with automated alerts.

## Contribution
Contributions are welcome. Feel free to open issues or pull requests for improvements or bug fixes.

## Contact
For questions or feedback, contact Ozair.

