TRUNCATE TABLE SILVER.crm_cust_info
INSERT INTO SILVER.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
) 
select 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE
    WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    else 'n/a'
END cst_marital_status,
CASE 
   WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
   WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
   else 'n/a'
END cst_gndr,
cst_create_date
from (
    SELECT
	*,
    row_number() over(partition by cst_id order by cst_create_date desc) as Flag_last
    from BRONZE.crm_cust_info 
	where cst_id is not null
  ) as t1
	where Flag_last = 1
 

 SELECT * FROM SILVER.crm_cust_info