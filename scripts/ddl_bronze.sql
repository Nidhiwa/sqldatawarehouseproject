
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
        FROM '/mnt/data/source_crm/cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

TRUNCATE TABLE bronze.crm_prd_info;
PRINT '>> Inserting Data Into: bronze.crm_prd_info';
BULK INSERT bronze.crm_prd_info
		FROM '/mnt/data/source_crm/prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
TRUNCATE TABLE bronze.crm_sales_details;
PRINT '>> Inserting Data Into: bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
		FROM '/mnt/data/source_crm/sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
TRUNCATE TABLE bronze.erp_loc_a101;
PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
		FROM '/mnt/data/source_erp/loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
TRUNCATE TABLE bronze.erp_cust_az12;
PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
		FROM '/mnt/data/source_erp/cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

TRUNCATE TABLE bronze.erp_px_cat_g1v2;
PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
		FROM '/mnt/data/source_erp/px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
        END

Exec bronze.load_bronze
