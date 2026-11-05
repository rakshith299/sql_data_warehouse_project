# **Data Warehouse Project**

  This project demonstrates a data warehouse built for business-ready analytics. 

-------------------------------------------------------------------------------------------------

## 📌 **Overview** 

This Project involves:

#### * Data Architecture: 
  Used the Medallion Architecture: Bronze, Silver, and Gold layers 
#### * ETL Pipelines: 
  Extract, Transform, and Load data from source systems to the data warehouse
#### * Data modelling: 
  Developing fact and dimension tables that are optimized for analytical queries

-------------------------------------------------------------------------------------------------

## 🧰 **Project requirement** 

#### **Objective**
  Develop a modern data warehouse using SQL Server to consolidate sales analytics, which is enabled for analytical reporting 

#### **Specifications** 

#### * Data Sources: Import Data from source systems (ERP and CRM) as CSV files
#### * Data quality: Clean and resolve data quality issues  
#### * Integration: Combine both source files into a single user-friendly data model 
#### * Scope: Historisation data is not required; focus on the latest data

-------------------------------------------------------------------------------------------------

## **Data Warehouse Architecture** 

![Data Warehouse Architecture](docs/Medallion%20Data%20Architecture.drawio.png)

-------------------------------------------------------------------------------------------------

## 📁 **Repository Structure** 

```

sql_data_warehouse_project/
│
├── datasets/
│   └──source_crm
│   └──source_erp
│ 
├── docs/
│   └── Medallion Data Architecture.png
│   └── Data flow Diagram.png 
│   └── data_catalog.md
│   └── entity relation table.png    
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── LICENSE
└── README.md

```

---------------------------------------------------------------------------------------------------


