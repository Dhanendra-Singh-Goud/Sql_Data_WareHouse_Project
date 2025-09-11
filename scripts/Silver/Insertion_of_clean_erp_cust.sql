TRUNCATE TABLE SILVER.erp_cust_AZ12
INSERT INTO SILVER.erp_cust_AZ12(
cid,
bdate,
gen
)
select
CASE 
  WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
  ELSE cid
END cid,
CASE 
    WHEN bdate > GETDATE() THEN NULL
	ELSE bdate
END bdate,
CASE 
   WHEN UPPER(TRIM(gen)) IN ('M', 'Male') then 'Male'
   WHEN UPPER(TRIM(gen)) IN ('F', 'Female') then 'Female'
   else 'n/a'
END gen
from BRONZE.erp_cust_AZ12

select * from SILVER.erp_cust_AZ12