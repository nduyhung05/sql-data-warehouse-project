/*
=====================================================================================================
Store Procedure: Load Bronze Layer (soruce)
=====================================================================================================
Script Purpose:
    This store procedure loads data into the "bronze" schema from external CSV files
    It performs the following action:
    - Truncate the table before loading data
    - Uses the 'BULK INSERT' to load data from csv Files to bronze table 

Parameters:
    None
    This store procedure does not accept any parameters or return any values

Usage Example:
    EXEC.load_bronze;
=====================================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME
	BEGIN TRY
		PRINT '============================================'
		PRINT 'Loading Bronze Layer'
		PRINT '============================================'

		PRINT '--------------------------------------------'
		PRINT 'Load CUST Table'
		PRINT '--------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table:	bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT 'Inserting Data into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Code\Data Warehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Load Durration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' secs';
		PRINT '>> --------------'

		PRINT '--------------------------------------------'
		PRINT 'Load PRD Table'
		PRINT '--------------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: '
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT 'Inserting Data into: '
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Code\Data Warehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		
		PRINT '--------------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: '
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT 'Inserting Data into: '
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Code\Data Warehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)

		PRINT 'Load CRM Table'
		
		PRINT '--------------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: '
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT 'Inserting Data into: '
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Code\Data Warehouse\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		
		PRINT '--------------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: '
		TRUNCATE TABLE bronze.erp_loc_a101
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Code\Data Warehouse\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		
		PRINT '--------------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: '
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Code\Data Warehouse\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
	END TRY
	BEGIN CATCH
		PRINT '============================================'
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'ERROR' + ERROR_MESSAGE()
		PRINT 'ERROR MESSAGE: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'ERROR MESSAGE: ' + CAST(ERROR_STATE() AS NVARCHAR)
		PRINT '============================================'
	END CATCH
END
