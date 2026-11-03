/*
======================================================
Creating Views for Gold Schema 
======================================================

- If the view already exists, then it's dropped, and then a new one is created 
- Contains fact and dimension tables
- fact_sales is the fact table; dim_customers and dim_products are dimension tables connected though star schema 

- These are business-ready views and can be used for analytics and reporting 
*/
-------------------------------------------------------------------------------------------------------------------


IF OBJECT_ID ('gold.dim_customers', 'U') IS NOT NULL 
  DROP VIEW gold.dim_customers;

GO 

CREATE VIEW gold.dim_customers AS 

SELECT 
	ROW_NUMBER() OVER (ORDER BY ci.cst_id ASC) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.CNTRY AS country,
	ca.BDATE AS birthdate,
	ci.cst_marital_status AS marital_status,
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr 
		ELSE COALESCE(ca.GEN, 'n/a') 
	END AS gender,
	ci.cst_create_date AS create_date
	
	
FROM silver.crm_cust_info AS ci LEFT JOIN silver.erp_CUST_AZ12 AS ca 
	ON ci.cst_key = ca.CID LEFT JOIN silver.erp_LOC_A101 AS la 
	ON ci.cst_key = la.CID

IF OBJECT_ID ('gold.dim_products', 'U') IS NOT NULL 
  DROP VIEW gold.dim_products;

GO 

CREATE VIEW gold.dim_products AS 

SELECT 
	ROW_NUMBER() OVER (ORDER BY pin.prd_start_dt ASC, pin.prd_key ASC) AS product_key,
	pin.prd_id AS product_id,  
	pin.prd_key AS product_number, 
	pin.prd_nm AS product_name,
	pin.cat_id AS category_id,
	pc.CAT AS category,
	pc.SUBCAT AS subcategory,
	pc.MAINTENANCE AS maintenance,
	pin.prd_cost AS cost, 
	pin.prd_line AS product_line,
	pin.prd_start_dt AS start_date

FROM silver.crm_prd_info AS pin LEFT JOIN silver.erp_PX_CAT_G1V2 AS pc ON 
	pin.cat_id = pc.ID 
WHERE pin.prd_end_dt IS NULL 

IF OBJECT_ID ('gold.fact_sales', 'U') IS NOT NULL 
  DROP VIEW gold.fact_sales;

GO 

CREATE VIEW gold.fact_sales AS 

SELECT 
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details AS sd LEFT JOIN gold.dim_products AS pr 
	ON sd.sls_prd_key = pr.product_number LEFT JOIN gold.dim_customers AS cu 
	ON sd.sls_cust_id = cu.customer_id 
