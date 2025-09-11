CREATE VIEW GOLD.fact_sales as
select
sd.sls_ord_num as order_number,
dp.product_key,
dc.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_Details as sd
left join gold.dim_product as dp
on sd.sls_prd_key = dp.product_number
left join gold.dim_customer as dc
on sd.sls_cust_id = dc.customer_id


