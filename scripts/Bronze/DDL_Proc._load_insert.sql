EXEC BRONZE.load_bronze;

CREATE OR ALTER PROCEDURE BRONZE.load_bronze
AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	SET @batch_start_time = GETDATE();
    BEGIN TRY
        PRINT '=============================================';
        PRINT 'LOADING OF BRONZE LAYER';
        PRINT '=============================================';

        PRINT '---------------------------------------------';
        PRINT 'LOADING CRM TABLE';
        PRINT '---------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: BRONZE.crm_cust_info';
        TRUNCATE TABLE BRONZE.crm_cust_info;

        PRINT '>> INSERTING INTO TABLE: BRONZE.crm_cust_info';
        BULK INSERT BRONZE.crm_cust_info
        FROM 'C:\Users\jai shree mahakal\OneDrive\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION (crm_cust_info): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' SECONDS';

        -- Repeat similar steps for other tables

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: BRONZE.crm_prd_info';
        TRUNCATE TABLE BRONZE.crm_prd_info;

        PRINT '>> INSERTING INTO TABLE: BRONZE.crm_prd_info';
        BULK INSERT BRONZE.crm_prd_info
        FROM 'C:\Users\jai shree mahakal\OneDrive\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION (crm_prd_info): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' SECONDS';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: BRONZE.crm_sales_details';
        TRUNCATE TABLE BRONZE.crm_sales_details;

        PRINT '>> INSERTING INTO TABLE: BRONZE.crm_sales_details';
        BULK INSERT BRONZE.crm_sales_details
        FROM 'C:\Users\jai shree mahakal\OneDrive\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION (crm_sales_details): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' SECONDS';

		PRINT '---------------------------------------------';
        PRINT 'LOADING CRM TABLE';
        PRINT '---------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: BRONZE.erp_cust_AZ12';
        TRUNCATE TABLE BRONZE.erp_cust_AZ12;

        PRINT '>> INSERTING INTO TABLE: BRONZE.erp_cust_AZ12';
        BULK INSERT BRONZE.erp_cust_AZ12
        FROM 'C:\Users\jai shree mahakal\OneDrive\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION (erp_cust_AZ12): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' SECONDS';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: BRONZE.erp_loc_a101';
        TRUNCATE TABLE BRONZE.erp_loc_a101;

        PRINT '>> INSERTING INTO TABLE: BRONZE.erp_loc_a101';
        BULK INSERT BRONZE.erp_loc_a101
        FROM 'C:\Users\jai shree mahakal\OneDrive\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION (erp_loc_a101): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' SECONDS';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING TABLE: BRONZE.erp_px_cat_g1v2';
        TRUNCATE TABLE BRONZE.erp_px_cat_g1v2;

        PRINT '>> INSERTING INTO TABLE: BRONZE.erp_px_cat_g1v2';
        BULK INSERT BRONZE.erp_px_cat_g1v2
        FROM 'C:\Users\jai shree mahakal\OneDrive\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> LOAD DURATION (erp_px_cat_g1v2): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(50)) + ' SECONDS';

    END TRY
    BEGIN CATCH
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE';
        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
    END CATCH
	SET  @batch_end_time = GETDATE();
	PRINT('>> THE ENTIRE PROCESS COMPLETE');
	PRINT('>> LOADING DURATION TIME : '+ CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) as NVARCHAR(50)))+'SECONDS'
END

  