TRUNCATE TABLE SILVER.erp_px_cat_g1v2;
INSERT INTO SILVER.erp_px_cat_g1v2(
ID,
CAT,
SUBCAT,
MAINTENANCE
)
select
Replace(ID, '-', '_')ID,
CAT,
SUBCAT,
MAINTENANCE
from bronze.erp_px_cat_g1v2


select * from silver.erp_px_cat_g1v2