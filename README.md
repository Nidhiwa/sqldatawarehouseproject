# Welcome to the Data Warehouse and Analytics Project Repository!🚀 #

This project showcases a complete end-to-end data warehousing and analytics solution — from building a robust data warehouse to delivering meaningful insights.

## Building the Data Warehouse (Data Engineering) ##

**Objective:**
Design and develop a modern data warehouse using SQL Server to consolidate sales data, supporting analytical reporting and better decision-making.

**Specifications:**

**Data Sources:** Load data from two source systems (ERP and CRM), provided in CSV format.

**Data Quality:** Perform data cleansing and address any quality issues before analysis.

**Integration:** Merge both sources into a unified, user-friendly data model optimized for analytical queries.

**Scope:** Focus solely on the latest dataset; historical tracking of changes is not required.

**Documentation:** Deliver clear documentation of the data model to assist both business users and analytics teams.







## Data Architecture ##
## 🏅 Medallion Architecture Overview ##

![image](https://github.com/user-attachments/assets/fc4f6a13-11e3-4a68-8bcc-0301e487e8d1)


**Bronze Layer:**

Purpose: Ingests raw data from various sources without any transformations.
Characteristics:

- Stores data in its original format, preserving the raw state.
- Serves as the single source of truth, maintaining data fidelity.
- Enables reprocessing and auditing by retaining all historical data.
- Typical Data Sources: Cloud storage, Kafka, Salesforce, etc.

**Silver Layer:**

Purpose: Performs data cleaning and validation.
Characteristics:

- Deduplicates and standardizes data.
- Joins data from multiple sources to create enriched datasets.
- Structures data into a more refined format suitable for analysis.

Use Cases: Data analysts and data scientists utilize this layer for in-depth analysis and model building.

**Gold Layer:**

Purpose: Provides aggregated and business-level data.
Characteristics:

- Contains curated datasets optimized for business intelligence and reporting.
- Applies business logic and calculations to support decision-making.
- Offers a "single version of the truth" for stakeholders.

Use Cases: Business analysts, executives, and decision-makers rely on this layer for insights and reporting.

## Project Overview ##

This project includes:

**Data Architecture:** Building a modern data warehouse using the Medallion Architecture with Bronze, Silver, and Gold layers.

**ETL Pipelines:** Extracting, transforming, and loading data from source systems into the data warehouse.

**Data Modeling:** Designing fact and dimension tables optimized for efficient analytical queries.

**Analytics & Reporting:** Developing SQL-based reports and dashboards to deliver actionable insights.


## About Me 👩‍💻 ##

Hi, I'm Nidhi!
I'm passionate about data engineering, analytics, and building scalable data solutions. With a strong background in **SQL, Python, and cloud technologies**, I enjoy designing modern data architectures and transforming raw data into actionable insights.

This repository is part of my journey to showcase real-world **data engineering projects, following industry best practices like Medallion Architecture, ETL pipeline development, and analytics-ready data modeling.**
I'm continuously learning and expanding my skills in big data, data warehousing, and business intelligence tools like Power BI.

Feel free to explore my work — and if you'd like to collaborate or connect, let's chat! 🚀


