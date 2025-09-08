/*
-------------------------------------------
Create DataBase and Schemas
-------------------------------------------
Script Purpose:
 This script create a new database named "dataWarehouse" after checking if it already exists.
 If the database exists, it is dropped and recreate additionally, the scripts set up three schemas
 within the database: 'bronze', 'silver', 'gold'.

Warning:
       Running this script will drop the etire "datawarehouse' database if it exists.
	   all data in database willbe permamently deleted.
*/

--Drop and recreate the the dataWarehouse database
IF EXISTS (SELECT 1 FROM sys.databases where name = 'DataWareHouse')
BEGIN
   ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP DATABASE DataWarehouse;
end;
Go

--Create the DataWareHouse Database
CREATE DATABASE DataWareHouse;
GO

--Create Schemas of DataWareHouse
CREATE SCHEMA BRONZE;
GO
CREATE SCHEMA SILVER;
GO 
CREATE SCHEMA GOLD;
GO