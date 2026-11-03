# Overview: 
The gold layer has business-interpretation-ready data. Contains fact and dimension tables 

-----------------------------------------------------------------------------------------------
## 1. gold.dim_customers 

| Column name | Data type | Description |
|---|---|---| 
| customer_key | INT | Surrogate key - uniquely identifies each customer in the dimension customers table |
| customer_id | INT | Numerical ID - unique identifier for each customer |
| customer_key | NVARCHAR(50) | Alpha-numeric identifier to track customer | 
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
| product_key | INT | Surrogate key - uniquely identifies each product in the dimension products table | 
| product_id | INT | Unique identifier within the table to track each product |
| product_number | NVARCHAR(50) | Alpha-numeric identifier for each product | 
| product_name | NVARCHAR(50) | Name of the product | 
| category_id | NVARCHAR(50) | A unique identifier for product's category | 
| category | NVARCHAR(50) | Name of the category to which a product belongs | 
| subcategory | NVARCHAR(50) | Name of the subcategory to which a product belongs | 
| maintenance_required | NVARCHAR(50) | Tells if maintenance is required or not | 
| cost | INT | Price of the product |
| product_line | NVARCHAR(50) | Tells us under which product_line does a product come | 
| start_date | DATE | The date when the product was added to the database |


## 3. gold.fact_sales 

| Column name | Data type | Description | 
|---|---|---| 
| order_number | NVARCHAR(50) | Unique Alpha-numeric idebtifier for each_order | 
| product_key | INT | Surrogate column linking to Products dimension table | 
| customer_key | INT | Surrogate column linking to Customers dimension table |
| order_date | DATE | Date when order was placed | 
| shipping_date | DATE | Date when order was shipped to customer | 
| due_date | DATE | Date when the payment is due | 
| sales_amount | INT | Total monetary value of sales | 
| quantity | INT | No.of units booked | 
| price | INT | Price of each unit |


