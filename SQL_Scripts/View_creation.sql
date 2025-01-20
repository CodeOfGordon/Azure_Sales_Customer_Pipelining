-- Calendar view
CREATE VIEW gold.calendar
AS
SELECT *
FROM OPENROWSET (
    BULK 'https://<storage-account>.dfs.core.windows.net/silver/adventureworks-calendar/',
    FORMAT = 'PARQUET'
) as calendar;
GO

-- Customers view
CREATE VIEW gold.customers
AS
SELECT *
FROM OPENROWSET (
    BULK 'https://<storage-account>.dfs.core.windows.net/silver/adventureworks-customers/',
    FORMAT = 'PARQUET'
) as customers;
GO

-- Product Categories view
CREATE VIEW gold.product_categories
AS
SELECT *
FROM OPENROWSET (
    BULK 'https://<storage-account>.dfs.core.windows.net/silver/adventureworks-product-categories/',
    FORMAT = 'PARQUET'
) as product_categories;
GO

-- Product Subcategories view
CREATE VIEW gold.product_subcategories
AS
SELECT *
FROM OPENROWSET (
    BULK 'https://<storage-account>.dfs.core.windows.net/silver/adventureworks-product-subcategories/',
    FORMAT = 'PARQUET'
) as product_subcategories;
GO

-- Products view
CREATE VIEW gold.products
AS
SELECT *
FROM OPENROWSET (
    BULK 'https://<storage-account>.dfs.core.windows.net/silver/adventureworks-products/',
    FORMAT = 'PARQUET'
) as products;
GO

-- Returns view
CREATE VIEW gold.returns
AS
SELECT *
FROM OPENROWSET (
    BULK 'https://<storage-account>.dfs.core.windows.net/silver/adventureworks-returns/',
    FORMAT = 'PARQUET'
) as returns;
GO

-- Sales view
CREATE VIEW gold.sales
AS
SELECT *
FROM OPENROWSET (
    BULK 'https://<storage-account>.dfs.core.windows.net/silver/adventureworks-sales/',
    FORMAT = 'PARQUET'
) as sales;
GO

-- Territories view
CREATE VIEW gold.territories
AS
SELECT *
FROM OPENROWSET (
    BULK 'https://<storage-account>.dfs.core.windows.net/silver/adventureworks-territories/',
    FORMAT = 'PARQUET'
) as territories;
GO
