IF OBJECT_ID('BRONZE.crm_cust_info', 'U') IS NOT NULL
   DROP TABLE BRONZE.crm_cust_info;
CREATE TABLE BRONZE.crm_cust_info(
  cst_id INT,
  cst_key NVARCHAR(50),
  cst_firstname NVARCHAR(50),
  cst_lastname NVARCHAR(50),
  cst_marital_status NVARCHAR(50),
  cst_gndr NVARCHAR(20),
  cst_create_date DATE
  );
IF OBJECT_ID('BRONZE.crm_prd_info', 'U') IS NOT NULL
   DROP TABLE BRONZE.crm_prd_info;
CREATE TABLE BRONZE.crm_prd_info(
  prd_id INT,
  prd_key NVARCHAR(50),
  prd_nm NVARCHAR(50),
  prd_cost FLOAT,
  prd_line NVARCHAR(50),
  prd_start_dt	DATETIME,
  prd_end_dt DATETIME
  );
IF OBJECT_ID('BRONZE.crm_sales_retails', 'U')IS NOT NULL
   DROP TABLE BRONZE.crm_sales_retails;
CREATE TABLE BRONZE.crm_sales_retails(
  sls_ord_num NVARCHAR(50),
  sls_prd_key NVARCHAR(50),
  sls_cust_id INT,
  sls_order_dt INT,
  sls_ship_dt INT,
  sls_due_dt INT,
  sls_sales INT,
  sls_quantity INT,
  sls_price INT
  );
IF OBJECT_ID('BRONZE.erp_cust_AZ12', 'U') IS NOT NULL
    DROP TABLE BRONZE.erp_cust_AZ12;
CREATE TABLE BRONZE.erp_cust_AZ12(
   cid NVARCHAR(50),
   bdate DATE,
   gen NVARCHAR(50)
  );
IF OBJECT_ID('BRONZE.erp_loc_a101', 'U') IS NOT NULL
   DROP TABLE BRONZE.erp_loc_a101;
CREATE TABLE BRONZE.erp_loc_a101(
   cid NVARCHAR(50),
   country NVARCHAR(50)
 );
IF OBJECT_ID('BRONZE.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE BRONZE.erp_px_cat_g1v2;
CREATE TABLE BRONZE.erp_px_cat_g1v2(
 ID NVARCHAR(50),
 CAT NVARCHAR(50),
 SUBCAT NVARCHAR(50),
 MAINTENANCE NVARCHAR(50)
 );