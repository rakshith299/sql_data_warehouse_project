/*
=====================================
Load Data to Bronze schema
===================================== 

- Loads data from an external CSV file to the bronze schema table
- This truncates the table first, and bulk inserts the data

- This Stored Procedure does not accept any parameters

To execute: EXEC bronze.load_bronze;
*/
-------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY

		PRINT '===================================';
		PRINT 'Loading tables for bronze layer'; 
		PRINT '===================================';

		PRINT '-----------------------------------';
		PRINT 'Loading tables from crm source sys'; 
		PRINT '-----------------------------------';

			PRINT 'Truncating table: bronze.crm_cust_info';
		
		SET @batch_start_time = GETDATE();
		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_cust_info;

			PRINT 'Bulk Inserting table: bronze.crm_cust_info';

		BULK INSERT bronze.crm_cust_info 

		FROM 'C:\Users\raksh\OneDrive\Desktop\sql server (notes)\data_warehouse_project_extracted\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Time taken to load bronze.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '*********************************************';

			PRINT 'Truncating table: bronze.crm_prd_info';

		SET @start_time = GETDATE(); 

		TRUNCATE TABLE bronze.crm_prd_info;

			PRINT 'Bulk Inserting table: bronze.crm_prd_info';

		BULK INSERT bronze.crm_prd_info 
		FROM 'C:\Users\raksh\OneDrive\Desktop\sql server (notes)\data_warehouse_project_extracted\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE(); 
		PRINT 'Time taken to load bronze.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '*********************************************';

			PRINT 'Truncating table: bronze.crm_sales_details';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_sales_details;

			PRINT 'Bulk Inserting table: bronze.crm_sales_details';

		BULK INSERT bronze.crm_sales_details 
		FROM 'C:\Users\raksh\OneDrive\Desktop\sql server (notes)\data_warehouse_project_extracted\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Time taken to load bronze.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '*********************************************';



		PRINT '-----------------------------------';
		PRINT 'Loading tables from erp source sys'; 
		PRINT '-----------------------------------';

			PRINT 'Truncating table: bronze.erp_CUST_AZ12';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_CUST_AZ12; 

			PRINT 'Bulk Inserting table: bronze.erp_CUST_AZ12';

		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\Users\raksh\OneDrive\Desktop\sql server (notes)\data_warehouse_project_extracted\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0d0a',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT 'Time taken to load bronze.erp_CUST_AZ12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '*********************************************';


			PRINT 'Truncating table: bronze.erp_LOC_A101';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_LOC_A101; 

			PRINT 'Bulk Inserting table: bronze.erp_LOC_A101';

		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\raksh\OneDrive\Desktop\sql server (notes)\data_warehouse_project_extracted\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE(); 
		PRINT 'Time taken to load bronze.erp_LOC_A101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '*********************************************';

			PRINT 'Truncating table: bronze.erp_PX_CAT_G1V2';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2; 

			PRINT 'Bulk Inserting table: bronze.erp_PX_CAT_G1V2';

		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\raksh\OneDrive\Desktop\sql server (notes)\data_warehouse_project_extracted\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		SET @batch_end_time = GETDATE();
		PRINT 'Time taken to load bronze.erp_PX_CAT_G1V2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '*********************************************';
		PRINT 'Total bronze layer tables loading time: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';

	END TRY 
	BEGIN CATCH 

		PRINT '==================================';
		PRINT 'Error occured during loading tables to bronze layer';
		PRINT 'Error message:' + ERROR_MESSAGE();
		PRINT 'Error message:' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error message:' + CAST(ERROR_STATE() AS NVARCHAR); 
		PRINT '==================================';

	END CATCH

END

