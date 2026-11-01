/*
===================================================
Creating a stored Procedure for the silver schema 
===================================================

- We are taking the data from the bronze schema and doing the necessary 
  data cleaning, data standardization, data enrichment, and data transformation
- Then we are loading it to the silver schema 
- It is stored as a stored procedure 

- First, truncate the table and then insert into the silver schema tables 
- We are keeping only the latest records

- To execute: EXEC  silver.load_silver

*/
------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE silver.load_silver AS 

BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 

	BEGIN TRY 

		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();

		PRINT '--------------------------------------'
		PRINT 'truncating table: silver.crm_cust_info'
		PRINT '--------------------------------------'

		TRUNCATE TABLE silver.crm_cust_info;

		PRINT '--------------------------------------'
		PRINT 'Insert table: silver.crm_cust_info'
		PRINT '--------------------------------------'

		INSERT INTO silver.crm_cust_info (
			cst_id, 
			cst_key,
			cst_firstname,
			cst_lastname, 
			cst_marital_status,
			cst_gndr, 
			cst_create_date
		)

		SELECT 
			cst_id,
			cst_key, 
			TRIM(cst_firstname) AS cst_firstname, 
			TRIM(cst_lastname) AS cst_lastname, 

			CASE
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' 
				ELSE 'n/a' 
			END AS cst_marital_status,

			CASE
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' 
				ELSE 'n/a' 
			END AS cst_gndr,
 
			cst_create_date
		FROM (
			SELECT *,
				ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY  cst_create_date DESC) AS rn 
			FROM bronze.crm_cust_info 
		) AS tt 
		WHERE rn = 1

		SET @end_time = GETDATE()

		PRINT '>> Time taken to load data to silver.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '****************************************'

		----------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID ('silver.crm_prd_info','U') IS NOT NULL 
			DROP TABLE silver.crm_prd_info;

		CREATE TABLE silver.crm_prd_info (
			prd_id INT,
			cat_id NVARCHAR(50),
			prd_key NVARCHAR(50),
			prd_nm NVARCHAR(50),
			prd_cost INT, 
			prd_line NVARCHAR(50),
			prd_start_dt DATE, 
			prd_end_dt DATE,

			dwh_create_date DATETIME2 DEFAULT GETDATE()
		);


		----------------------------------------------------------------
		SET @start_time = GETDATE();

		PRINT '--------------------------------------'
		PRINT 'truncating table: silver.crm_prd_info'
		PRINT '--------------------------------------'

		TRUNCATE TABLE silver.crm_prd_info 

		PRINT '--------------------------------------'
		PRINT 'Insert table: silver.crm_prd_info'
		PRINT '--------------------------------------'

		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost, 
			prd_line,
			prd_start_dt, 
			prd_end_dt 

		)

		SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
			prd_nm, 
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE 
				WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
				WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales' 
				WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
				WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring' 
				ELSE 'n/a' 
			END AS prd_line, 
			CAST(prd_start_dt AS DATE) AS prd_start_dt, 
			CAST(DATEADD(DAY, -1, LEAD(prd_start_dt, 1) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)) AS DATE) AS prd_end_dt 
	

		FROM bronze.crm_prd_info 

		SET @end_time = GETDATE();

		PRINT '>> Time taken to load data to silver.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '****************************************'

		-----------------------------------------------------------------------------------------

		IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL 
			DROP TABLE silver.crm_sales_details; 

		CREATE TABLE silver.crm_sales_details (
			sls_ord_num NVARCHAR(50), 
			sls_prd_key NVARCHAR(50), 
			sls_cust_id INT,
			sls_order_dt DATE, 
			sls_ship_dt DATE,
			sls_due_dt DATE,
			sls_sales INT,
			sls_quantity INT,
			sls_price INT,

			dwh_create_date DATETIME2 DEFAULT GETDATE()
		);

		------------------------------------------------
		SET @start_time = GETDATE();

		PRINT '--------------------------------------'
		PRINT 'truncating table: silver.crm_sales_details'
		PRINT '--------------------------------------'

		TRUNCATE TABLE silver.crm_sales_details 

		PRINT '--------------------------------------'
		PRINT 'Insert table: silver.crm_sales_details'
		PRINT '--------------------------------------'

		INSERT INTO silver.crm_sales_details (
			sls_ord_num, 
			sls_prd_key, 
			sls_cust_id,
			sls_order_dt, 
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)

		SELECT 
			sls_ord_num, 
			sls_prd_key, 
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_order_dt AS NVARCHAR(50)) AS DATE) 
			END AS sls_order_dt,

			CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_ship_dt AS NVARCHAR(50)) AS DATE) 
			END AS sls_ship_dt, 

			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_due_dt AS NVARCHAR(50)) AS DATE) 
			END AS sls_due_dt, 

			CASE 
				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
					THEN sls_quantity * ABS(sls_price) 
				ELSE sls_sales 
			END AS sls_sales,

			sls_quantity,

			CASE 
				WHEN sls_price IS NULL OR sls_price <= 0 OR sls_price != sls_sales / sls_quantity 
					THEN sls_sales / NULLIF(sls_quantity, 0) 
				ELSE sls_price 
			END AS sls_price


	
		FROM bronze.crm_sales_details 

		SET @end_time = GETDATE(); 

		PRINT '>> Time taken to load data to silver.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '****************************************'
		-------------------------------------------------------------------------

		SET @start_time = GETDATE();

		PRINT '--------------------------------------'
		PRINT 'truncating table: silver.erp_CUST_AZ12'
		PRINT '--------------------------------------'

		TRUNCATE TABLE silver.erp_CUST_AZ12;

		PRINT '--------------------------------------'
		PRINT 'Insert table: silver.erp_CUST_AZ12'
		PRINT '--------------------------------------'


		INSERT INTO silver.erp_CUST_AZ12 (
			CID, 
			BDATE, 
			GEN
		)

		SELECT 
			CASE 
				WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID)) 
				ELSE CID 
			END AS CID, 

			CASE 
				WHEN BDATE > GETDATE() THEN NULL 
				ELSE BDATE 
			END AS BDATE, 

			CASE 
				WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female' 
				WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male' 
				ELSE 'n/a' 
			END AS GEN 

		FROM bronze.erp_CUST_AZ12 

		SET @end_time = GETDATE();

		PRINT '>> Time taken to load data to silver.erp_CUST_AZ12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '****************************************'
		
		------------------------------------------------------------------------------
		SET @start_time = GETDATE();

		PRINT '--------------------------------------'
		PRINT 'truncating table: silver.erp_loc_A101'
		PRINT '--------------------------------------'

		TRUNCATE TABLE silver.erp_loc_A101; 

		PRINT '--------------------------------------'
		PRINT 'Insert table: silver.erp_loc_A101'
		PRINT '--------------------------------------'


		INSERT INTO silver.erp_loc_A101 (
			CID,
			CNTRY
		)

		SELECT 
			REPLACE(cid, '-', '') AS CID, 
			CASE 
				WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany' 
				WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States' 
				WHEN cntry IS NULL OR cntry = '' THEN 'n/a'
				ELSE cntry 
			END AS CNTRY

		FROM bronze.erp_loc_a101 

		SET @end_time = GETDATE();

		PRINT '>> Time taken to load data to silver.erp_loc_A101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '****************************************'

		------------------------------------------------------------------------------
		SET @start_time = GETDATE();

		PRINT '--------------------------------------'
		PRINT 'truncating table: silver.erp_PX_CAT_G1V2'
		PRINT '--------------------------------------'

		TRUNCATE TABLE silver.erp_PX_CAT_G1V2;

		PRINT '--------------------------------------'
		PRINT 'truncating table: silver.erp_PX_CAT_G1V2'
		PRINT '--------------------------------------'

		INSERT INTO silver.erp_PX_CAT_G1V2 (
			id, 
			cat,
			subcat,
			maintenance
		)

		SELECT 
			id, 
			cat,
			subcat,
			maintenance

		FROM bronze.erp_px_cat_g1v2

		SET @end_time = GETDATE();
		
		PRINT '>> Time taken to load data to silver.erp_PX_CAT_G1V2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '****************************************'

		SET @batch_end_time = GETDATE();

		PRINT '**************'
		PRINT '>> >> Total time to load data from bronze to silver: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '**************'

	END TRY 

	BEGIN CATCH
		PRINT 'Error Message: ' + ERROR_MESSAGE()  
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR) 
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR)
	END CATCH


END

