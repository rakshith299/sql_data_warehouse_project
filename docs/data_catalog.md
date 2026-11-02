# Overview: 
The gold layer has business-interpretation-ready data. Contains fact and dimension tables 

-----------------------------------------------------------------------------------------------
## 1. gold.dim_customers 

| Column name | Data type | Description |
|---|---|---| 
| customer_key | INT | Surrogate key - uniquely identifies each customer in the dimension customers table |
| customer_id | INT | Numerical ID - unique identifier for each customer |
| customer_key | NVARCHAR(50) | Alfa-numeric identifier to track customer | 
| first_name | NVARCHAR(50) | Customer's first name | 
| last_name | NVARCHAR(50) | Customer's last name | 
| country | NVARCHAR(50) | Customer's country of residence | 
| marital_status | NVARCHAR(50) | Marital status of customer | 
| gender | NVRCHAR(50) | Gender of customer | 
| birthdate | DATE | Birthdate of the customer. Format - (YYYY - MM - DD) |
| create_date | DATE | Date the customer record was first created |


## 2. gold.dim_products 

| Column name | Data type | Description | 
|---|---|---|
