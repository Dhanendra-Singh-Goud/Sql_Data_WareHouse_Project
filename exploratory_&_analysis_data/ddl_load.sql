--Recreate and drop  the " DatawarehouseAnalytics" database
IF EXISTS(SELECT 1 FROM sys.databases WHERE NAME = 'DataWareHouseAnalytics')
BEGIN 
   ALTER DATABASE DataWareHouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP DATABASE DataWareHouseAnalytics;
END;
GO


CREATE DATABASE DataWareHouseAnalytics;
GO

--CREATE  SCHEMAS
CREATE SCHEMA gold;
Go
CREATE SCHEMA silver;
Go
CREATE SCHEMA bronze;
GO

IF OBJECT_ID('gold.dim_customer', 'U') IS NOT NULL
  DROP TABLE gold.dim_customer;
CREATE TABLE gold.dim_customer(
customer_key INT,
customer_id INT,
customer_number NVARCHAR(50),
first_Name NVARCHAR(50),
Last_name NVARCHAR(50),
country NVARCHAR(50),
maritial_status NVARCHAR(50),
gender NVARCHAR(50),
birthday DATE,
create_date DATE
);
GO
IF OBJECT_ID('gold.dim_product', 'U') IS NOT NULL
  DROP TABLE gold.dim_product;
CREATE TABLE gold.dim_product(
Product_key INT,
product_id INT,
product_number NVARCHAR(50),
product_name NVARCHAR(50),
category_id NVARCHAR(50),
category NVARCHAR(50),
sub_category NVARCHAR(50),
MAINTENANCE NVARCHAR(50),
product_cost INT,
product_line NVARCHAR(50),
start_date DATE
);
GO
IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
  DROP TABLE gold.fact_sales;
CREATE TABLE gold.fact_sales(
order_number NVARCHAR(50),
product_key INT,
customer_key INT,
order_date DATE,
shipping_date DATE,
due_date DATE,
sales_amount INT,
quantity INT,
price INT
);
GO

TRUNCATE TABLE gold.dim_customer
Go

BULK INSERT gold.dim_customer
FROM 'C:\Users\jai shree mahakal\OneDrive\Desktop\sql-data-warehouse-project\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  TABLOCK
  )
GO

TRUNCATE TABLE gold.dim_product
GO

BULK INSERT gold.dim_product
FROM 'C:\Users\jai shree mahakal\OneDrive\Desktop\sql-data-warehouse-project\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH (
    FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
  );
GO

TRUNCATE TABLE gold.fact_sales
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\jai shree mahakal\OneDrive\Desktop\sql-data-warehouse-project\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH (
   FIRSTROW = 2,
   FIELDTERMINATOR = ',',
   TABLOCK
   )
