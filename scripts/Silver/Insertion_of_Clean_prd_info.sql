TRUNCATE TABLE SILVER.crm_prd_info
INSERT INTO SILVER.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5),'-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) as prd_key,
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
	   WHEN 'M' THEN 'Mountain'
	   WHEN 'S' THEN 'Other Sales'
	   WHEN 'R' THEN 'Road'
	   WHEN 'T' THEN 'Touring'
	   ELSE 'n/a'
	END prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 AS DATE) as prd_end_dt
FROM BRONZE.crm_prd_info

--select * from SILVER.crm_prd_info