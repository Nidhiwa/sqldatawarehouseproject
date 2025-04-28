-- Switch to the master database to create a new database
USE master;
GO

-- Create the 'DataWarehouse' database
-- This will create a new database called DataWarehouse, which will be used to store the data.
CREATE DATABASE DataWarehouse;
GO

-- Switch to the newly created 'DataWarehouse' database
USE DataWarehouse;
GO

-- Create Schemas

-- Create the 'bronze' schema
-- This schema will be used to store raw data, typically ingested directly from source systems.
CREATE SCHEMA bronze;
GO

-- Create the 'silver' schema
-- This schema will be used to store cleaned and transformed data, usually after applying business rules.
CREATE SCHEMA silver;
GO

-- Create the 'gold' schema
-- This schema will be used for data that is ready for reporting, analytics, or visualization. It contains aggregated or highly transformed data.
CREATE SCHEMA gold;
GO
