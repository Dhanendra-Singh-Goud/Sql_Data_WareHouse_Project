CREATE VIEW Gold.dim_customer as
select
Row_number() over(order by ci.cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_Name,
ci.cst_lastname as Last_name,
cl.country as country,
ci.cst_marital_status as maritial_status ,
CASE 
  WHEN ci.cst_gndr != 'n/a' then ci.cst_gndr
  ELSE coalesce(ca.gen, 'n/a')
END as gender,
ca.bdate as birthday,
ci.cst_create_date as create_date
from silver.crm_cust_info as ci
left join silver.erp_cust_AZ12 as ca
on ci.cst_key = ca.cid
left join SILVER.erp_loc_a101 as cl
on ci.cst_key = cl.cid

select * from gold.dim_customer
