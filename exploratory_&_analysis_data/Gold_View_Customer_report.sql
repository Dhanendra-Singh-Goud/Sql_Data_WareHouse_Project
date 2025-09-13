/*
===========================================================================
Customer Report 
===========================================================================
Purpose:
     - This Report consolidates key customer metrics and behaviors

HighLights:
   1. Gathers Essential field such as names, ages and transaction details.
   2. Segments customers into categories(VIP, Regular, New Customers) and age group.
   3. Aggregates customer-level metrics:
      -total orders
	  -total sales
	  -total quantity purchased
	  -total products
	  lifespan(in months)
	4. Calculate valuable KPIs:
	    -recent (month since last order)
		-Average order value
		-average month spend
========================================================================================
*/

--First of all we create a base table which contain all those 
--column which required further to create a report
IF OBJECT_ID('GOLD.customer_report', 'V') is not null
   DROP VIEW GOLD.customer_report;
GO 

CREATE VIEW GOLD.customer_report as
with base_query as (
select
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_Name, ' ', c.Last_name)as customer_name,
datediff(year, birthday, getdate()) as age
from GOLD.fact_sales as f
left join GOLD.dim_customer as c
on f.customer_key = c.customer_key
where f.order_date is not null
),

Customer_aggregation as(
select
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number) as total_order,
sum(sales_amount)as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_product,
Max(order_date) as last_order_date,
DATEDIFF(month, MIN(order_date), max(order_date)) as Lifespan
from base_query
group by customer_key,
customer_number,
customer_name,
age
)
select
customer_key,
customer_number,
customer_name,
age,
case
when age < 30 then 'below 30'
when age between 30 and 40 then '30-40'
when age between 40 and 50 then '40-50'
when age between 50 and 75 then '50-75'
else 'above 75'
end age_group,
case
when Lifespan > 12 and total_sales > 5000 then 'VIP'
when Lifespan >= 12 and total_sales <= 5000 then 'Regular'
else 'New Customer'
end customer_category,
last_order_date,
DATEDIFF(month, last_order_date, GETDATE()) as recency,
total_order,
total_sales,
total_quantity,
total_product,
Lifespan,
--Compute Average order value
case
 when total_sales = 0 then 0
 else total_sales/total_order
end avg_order_value,
case
  when Lifespan = 0 then total_sales
  else total_sales/Lifespan
end as avg_monthly_spend
from Customer_aggregation
;
GO
--select * from gold.customer_report

