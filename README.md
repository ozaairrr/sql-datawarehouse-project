# Data Warehouse Project
Welcome to the Data Warehouse and Analytics Project repository! 🚀

## 🧾 Project Overview
This project implements a multi-layered data warehouse following the **Medallion Architecture** (Bronze, Silver, and Gold layers). It covers complete data lifecycle from ingestion to analytics-ready dimensional models.


## 🎯 Business Problem
Organizations often struggle with fragmented data scattered across multiple systems (CRM, ERP, sales platforms), making it difficult to:
- Get a unified view of customers, products, and sales performance
- Ensure data quality and consistency across different sources
- Enable efficient business intelligence and reporting
- Make data-driven decisions with confidence

**The Challenge:** Raw data from CRM and ERP systems contained inconsistencies, missing values, different formats, and quality issues that prevented effective analytics and reporting.

## 💡 Solution Delivered
This project implements a **modern data warehouse architecture** that solves these problems by:

1. **Centralizing Data**: Consolidating customer, product, and sales data from multiple source systems into a single, reliable data warehouse
2. **Ensuring Data Quality**: Implementing comprehensive data cleaning, validation, and standardization processes
3. **Creating Analytics-Ready Models**: Building dimensional models (star schema) with surrogate keys for efficient reporting
4. **Automating ETL Processes**: Providing repeatable, automated data transformation workflows
5. **Enabling Self-Service Analytics**: Creating business-friendly views that analysts can easily query

## 🏗️ Layers and Structure
- **Bronze Layer:** Raw source data ingestion and storage with minimal processing
- **Silver Layer:** Cleansed, standardized, and enriched data for further analysis
- **Gold Layer:** Curated, business-friendly dimensional views and fact tables for reporting and analytics
  - `gold_dim_customers` - Customer dimension with demographic data
  - `gold_dim_products` - Product dimension with category information
  - `gold_fact_sales` - Sales fact table with all transactional metrics

## 📊 Data Warehouse Architecture
The following diagram illustrates the overall data architecture of the project, including the Bronze, Silver, and Gold layers and the data flow between them:

![Data Warehouse Architecture](https://github.com/ozaairrr/sql-datawarehouse-project/blob/a3ee8cd032fc6667783eceb8328a75c2270a695f/docs/data_architecture.png)

## ✨ Key Features
- **Automated ETL procedures** from Bronze to Silver layer using stored procedures
- **Comprehensive data quality checks** for each layer to ensure data integrity
- **Surrogate keys and dimensional modeling** in Gold layer for optimal analytics performance
- **Data standardization** for gender, marital status, product categorization, and date formats
- **MySQL views** for simplified access to analytical data
- **Full data lineage** tracking from source to analytical models

## 🛠️ Technologies Used
- **Database**: MySQL 8.0
- **Language**: SQL
- **Architecture**: Medallion (Bronze-Silver-Gold) layers
- **ETL Method**: Stored procedures and views
- **Documentation**: Markdown, Draw.io diagrams
- **Data Quality**: Custom SQL validation scripts

## 🚀 How to Use
1. **Setup**: Create database schema and run Bronze layer DDL scripts
2. **Data Loading**: Execute `load_bronze_data()` procedure to load raw data files into Bronze tables
3. **Transformation**: Run `silver_load_procedure()` to populate Silver layer with cleaned data
4. **Analytics**: Query Gold layer views (`gold_dim_customers`, `gold_dim_products`, `gold_fact_sales`) for reporting
5. **Quality Assurance**: Execute provided data quality check scripts to validate data integrity

## 🎗️ Project Structure
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

## 📈 Project Outcome & Business Impact
The completed data warehouse solution delivers measurable business value:

### **Technical Achievements:**
- **Unified Data Model**: Successfully integrated customer, product, and sales data from multiple sources
- **Data Quality Improvement**: Implemented validation rules that catch and correct data inconsistencies
- **Performance Optimization**: Created surrogate keys and optimized dimensional models for fast query performance
- **Automation**: Built repeatable ETL processes reducing manual data processing time

### **Business Benefits:**
- **360° Customer View**: Complete customer profiles combining CRM demographics with ERP transaction history
- **Product Analytics**: Comprehensive product performance analysis with proper categorization
- **Sales Insights**: Clean, consistent sales metrics enabling accurate reporting and forecasting
- **Data Confidence**: Quality checks ensure business users can trust the data for decision-making

### **Deliverables:**
- Production-ready Bronze tables storing raw data from CRM and ERP systems
- Cleaned and standardized Silver tables with validated business rules
- Analytics-optimized Gold layer views ready for BI tools and reporting
- Automated ETL procedures ensuring consistent, reliable data processing
- Comprehensive data quality framework maintaining data integrity

This project demonstrates production-level data engineering skills and modern data warehouse best practices suitable for enterprise environments.

## ⭐ About Me
I am Ozair, a BCA graduate passionate about data analytics and engineering. I enjoy building practical projects that solve real-world business problems and demonstrate modern data engineering practices. This project showcases my ability to design and implement end-to-end data solutions following industry best practices.

## 🔮 Future Enhancements
- Implement incremental data loading for better scalability
- Add automated data profiling and anomaly detection
- Integrate with modern BI tools (Power BI, Tableau)
- Implement real-time streaming data capabilities
- Add advanced error handling and monitoring

## 🤝 Contributing
Contributions are welcome! Feel free to open issues or submit pull requests to improve this data warehouse solution.

## 📫 Connect with Me
🔗 [LinkedIn - Shaikh Mohammad Ozair](https://www.linkedin.com/in/shaikh-mohammad-ozair-connect/)

