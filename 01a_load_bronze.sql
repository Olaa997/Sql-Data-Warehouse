/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.


Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_Recruitment';
		TRUNCATE TABLE bronze.crm_Recruitment;
		PRINT '>> Inserting Data Into: bronze.crm_Recruitment';
		BULK INSERT bronze.crm_Recruitment
		FROM 'C:\sql\data\Recruitment.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_Employee_Master';
		TRUNCATE TABLE bronze.crm_Employee_Master;
		PRINT '>> Inserting Data Into: bronze.crm_Employee_Master';
		BULK INSERT bronze.crm_Employee_Master
		FROM 'C:\sql\data\Employee_Master.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_Performance_Timeseries';
		TRUNCATE TABLE bronze.crm_Performance_Timeseries;
		PRINT '>> Inserting Data Into: bronze.crm_Performance_Timeseries';
		BULK INSERT bronze.crm_Performance_Timeseries
		FROM 'C:\sql\data\Performance_Timeseries.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_Lifecycle_Retention';
		TRUNCATE TABLE bronze.crm_Lifecycle_Retention;
		PRINT '>> Inserting Data Into: bronze.crm_Lifecycle_Retention';
		BULK INSERT bronze.crm_Lifecycle_Retention
		FROM 'C:\sql\data\Lifecycle_Retention.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_Monthly_Pulse_Timeseries';
		TRUNCATE TABLE bronze.crm_Monthly_Pulse_Timeseries;
		PRINT '>> Inserting Data Into: bronze.crm_Monthly_Pulse_Timeseries';
		BULK INSERT bronze.crm_Monthly_Pulse_Timeseries
		FROM 'C:\sql\data\Monthly_Pulse_Timeseries.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State:   ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END


EXEC bronze.load_bronze;


SELECT COUNT(*) FROM bronze.crm_Recruitment;
SELECT COUNT(*) FROM bronze.crm_Employee_Master;
SELECT COUNT(*) FROM bronze.crm_Performance_Timeseries;
SELECT COUNT(*) FROM bronze.crm_Lifecycle_Retention;
SELECT COUNT(*) FROM bronze.crm_Monthly_Pulse_Timeseries;

SELECT TOP 5 * FROM bronze.crm_Recruitment;

SELECT COUNT(*) FROM bronze.crm_Recruitment;

SELECT COUNT(*) FROM bronze.crm_Recruitment;
SELECT COUNT(*) FROM bronze.crm_Employee_Master;
SELECT COUNT(*) FROM bronze.crm_Performance_Timeseries;
SELECT COUNT(*) FROM bronze.crm_Lifecycle_Retention;
SELECT COUNT(*) FROM bronze.crm_Monthly_Pulse_Timeseries;
