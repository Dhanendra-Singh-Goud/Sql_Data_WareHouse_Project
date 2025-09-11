TRUNCATE TABLE SILVER.erp_loc_a101
INSERT INTO SILVER.erp_loc_a101(
cid,
country
)
select
REPLACE(cid, '-', '')cid,
CASE
   WHEN TRIM(country)  = 'DE' THEN 'Germany'
   WHEN TRIM(country) in ('US', 'USA') then 'United States'
   WHEN TRIM(country) = '' or country is null then 'n/a'
   ELSE TRIM(country)
end country
from bronze.erp_loc_a101


--select * from SILVER.erp_loc_a101