IF OBJECT_ID('SILVER.crm_cust_info', 'U') IS NOT NULL
   DROP TABLE SILVER.crm_cust_info;
CREATE TABLE SILVER.crm_cust_info(
  cst_id INT,
  cst_key NVARCHAR(50),
  cst_firstname NVARCHAR(50),
  cst_lastname NVARCHAR(50),
  cst_marital_status NVARCHAR(50),
  cst_gndr NVARCHAR(20),
  cst_create_date DATE,
  dwh_create_date DATETIME2 DEFAULT GETDATE()
  );
IF OBJECT_ID('SILVER.crm_prd_info', 'U') IS NOT NULL
   DROP TABLE SILVER.crm_prd_info;
CREATE TABLE SILVER.crm_prd_info(
  prd_id INT,
  cat_id NVARCHAR(50),
  prd_key NVARCHAR(50),
  prd_nm NVARCHAR(50),
  prd_cost FLOAT,
  prd_line NVARCHAR(50),
  prd_start_dt	DATETIME,
  prd_end_dt DATETIME,
  dwh_create_date DATETIME2 DEFAULT GETDATE()
  );
IF OBJECT_ID('SILVER.crm_sales_Details', 'U')IS NOT NULL
   DROP TABLE SILVER.crm_sales_Details;
CREATE TABLE SILVER.crm_sales_Details(
  sls_ord_num NVARCHAR(50),
  sls_prd_key NVARCHAR(50),
  sls_cust_id INT,
  sls_order_dt DATE,
  sls_ship_dt DATE,
  sls_due_dt DATE,
  sls_sales INT,
  sls_quantity INT,
  sls_price INT,
  dwh_create_date DATETIME2 DEFAULT GETDATE()
  );
IF OBJECT_ID('SILVER.erp_cust_AZ12', 'U') IS NOT NULL
    DROP TABLE SILVER.erp_cust_AZ12;
CREATE TABLE SILVER.erp_cust_AZ12(
   cid NVARCHAR(50),
   bdate DATE,
   gen NVARCHAR(50),
  dwh_create_date DATETIME2 DEFAULT GETDATE()
  );
IF OBJECT_ID('SILVER.erp_loc_a101', 'U') IS NOT NULL
   DROP TABLE SILVER.erp_loc_a101;
CREATE TABLE SILVER.erp_loc_a101(
   cid NVARCHAR(50),
   country NVARCHAR(50),
  dwh_create_date DATETIME2 DEFAULT GETDATE()
 );
IF OBJECT_ID('SILVER.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE SILVER.erp_px_cat_g1v2;
CREATE TABLE SILVER.erp_px_cat_g1v2(
 ID NVARCHAR(50),
 CAT NVARCHAR(50),
 SUBCAT NVARCHAR(50),
 MAINTENANCE NVARCHAR(50),
 dwh_create_date DATETIME2 DEFAULT GETDATE()
 );
