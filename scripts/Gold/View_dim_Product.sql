Create View Gold.dim_product as
select 
Row_number() over(order by pn.prd_start_dt, pn.prd_key ) as Product_key,
pn.prd_id as product_id,
pn.prd_key as product_number,
pn.prd_nm as product_name,
pn.cat_id as category_id,
pc.CAT as category,
pc.SUBCAT as sub_category,
pc.MAINTENANCE,
pn.prd_cost as product_cost,
pn.prd_line as product_line,
pn.prd_start_dt as start_date
from SILVER.crm_prd_info as pn 
left join silver.erp_px_cat_g1v2 as pc
on pn.cat_id = pc.ID
where pn.prd_end_dt is null

select * from GOLD.dim_product
select * from GOLD.dim_customer
