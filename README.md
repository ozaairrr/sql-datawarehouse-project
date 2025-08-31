# Data Warehouse Project
- Welcome to the Data Warehouse and Analytics Project repository! 🚀
## 🧾Project Overview
This project implements a multi-layered data warehouse following the Bronze, Silver, and Gold architecture. It covers data ingestion, cleansing, transformation, and dimensional modeling to provide clean, consistent, and analytics-ready data.

## Layers and Structure
- **Bronze Layer:** Raw source data ingestion and storage with minimal processing.
- **Silver Layer:** Cleansed, standardized, and enriched data for further analysis.
- **Gold Layer:** Curated, business-friendly dimensional views and fact tables for reporting and analytics. [dimcustomers, dimproducts, factsales]

## Key Features
- Automated ETL procedures from Bronze to Silver layer.
- Comprehensive data quality checks for each layer.
- Use of surrogate keys and dimensional modeling in Gold layer.
- Data standardization for gender, marital status, product categorization, and dates.
- Use of MySQL views for simplified access to analytical data.

## How to Use
1. Load raw data files into the Bronze tables.
2. Run the stored procedure `silver_load_procedure()` to populate Silver layer.
3. Use the Gold layer views for analytics and reporting.
4. Execute provided SQL scripts for data quality verification.

## 🎗️Project Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
```

## Project Outcome
The completed project delivers a data warehouse solution that provides:

- Reliable raw data storage in Bronze tables.
- Cleaned and standardized datasets in Silver tables.
- Business-ready dimensional models with surrogate keys accessible via Gold layer views.
- Automated, repeatable ETL processes ensuring data integrity.
- Data quality checks ensuring accuracy and consistency for analytical confidence.

This project demonstrates a production-appropriate architecture and practical SQL skills suitable for real-world data engineering and analytics tasks.

## ⭐ About Me
I am Ozair, a BCA graduate passionate about data engineering and data analytics. I enjoy building practical projects to sharpen my skills and solve real-world data problems.


