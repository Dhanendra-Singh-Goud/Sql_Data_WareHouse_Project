/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

--Analysing the yearly performance ofproduct
--by comparing each product's sales to both its average sales performance
--and the previous year sales

with Avg_yearly as (
select
year(f.order_date) as yearly,
p.product_name,
sum(sales_amount) as current_sales
from GOLD.fact_sales as f
left join GOLD.dim_product as p
on f.product_key = p.Product_key
where f.order_date is not null
group by year(f.order_date), p.product_name
)

select 
yearly,
product_name,
current_sales,
avg(current_sales) over(partition by product_name) as avg_sales,
current_sales - avg(current_sales) over(partition by product_name) as avg_sales,
case 
  when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'above avg'
  when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'below avg'
  else 'avg'
end avg_change,
LAG(current_sales) over(partition by product_name order by yearly) as previous_sales,
current_sales - LAG(current_sales) over(partition by product_name order by yearly) as diff_btw_sales,
case 
  when current_sales - LAG(current_sales) over(partition by product_name order by yearly) > 0 then 'Increase'
  when current_sales -LAG(current_sales) over(partition by product_name order by yearly) < 0 then 'Decrease'
  else 'No change'
end status
from Avg_yearly;