-----------------------------------------------------------------------------------------------------
-- Initialize variables
-----------------------------------------------------------------------------------------------------

-- Set master key password if needed
-- CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<MASTER KEY>';

-- Connect to synapse's managed identity
CREATE DATABASE SCOPED CREDENTIAL synapse_cred
WITH
    IDENTITY = 'Managed Identity';

-- Set external datasources as a variable
CREATE EXTERNAL DATA SOURCE source_silver
WITH (
    LOCATION = 'https://<storage-account>.dfs.core.windows.net/silver',
    CREDENTIAL = synapse_cred
)
CREATE EXTERNAL DATA SOURCE source_gold
WITH (
    LOCATION = 'https://<storage-account>.dfs.core.windows.net/gold',
    CREDENTIAL = synapse_cred
)

-- Set file format as a variable
CREATE EXTERNAL FILE FORMAT format_parquet
WITH (
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)




-----------------------------------------------------------------------------------------------------
-- Create External Table As Select (CETAS). Here we store the View in the gold folder in our datalake
-----------------------------------------------------------------------------------------------------
-- Note: If you mess up while creating an external table, make sure to 
-- DROP EXTERNAL TABLE <external-table> since external tables are references (abstractions like VIEW)
-- that point to the ACTUAL data, which would be stored in the outside storage container 
-- (in our case, the gold folder in our data lake)

-- Create external table for 'sales'
CREATE EXTERNAL TABLE gold.extsales
WITH (
    LOCATION = 'extsales',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.sales;

-- Create external table for 'calendar'
CREATE EXTERNAL TABLE gold.extcalendar
WITH (
    LOCATION = 'extcalendar',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.calendar;

-- Create external table for 'customers'
CREATE EXTERNAL TABLE gold.extcustomers
WITH (
    LOCATION = 'extcustomers',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.customers;

-- Create external table for 'product-categories'
CREATE EXTERNAL TABLE gold.extproduct_categories
WITH (
    LOCATION = 'extproduct_categories',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.product_categories;

-- Create external table for 'product-subcategories'
CREATE EXTERNAL TABLE gold.extproduct_subcategories
WITH (
    LOCATION = 'extproduct_subcategories',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.product_subcategories;

-- Create external table for 'products'
CREATE EXTERNAL TABLE gold.extproducts
WITH (
    LOCATION = 'extproducts',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.products;

-- Create external table for 'returns'
CREATE EXTERNAL TABLE gold.extreturns
WITH (
    LOCATION = 'extreturns',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.returns;

-- Create external table for 'territories'
CREATE EXTERNAL TABLE gold.extterritories
WITH (
    LOCATION = 'extterritories',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.territories;



