/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/
/*Segment product into cost ranges and
 count how many product fall into each segment*/
 with product_segemts as(
 select
 Product_key,
 product_name,
 product_cost,
 case
 when product_cost < 100 then 'below 100'
 when product_cost between 100 and 500 then '100-500'
 when product_cost between 500 and 1000 then '500-1k'
 else 'above 1k'
 end cost_range
 from GOLD.dim_product
 )
 select
 cost_range,
 count(product_key) as total_product
 from product_segemts
 group by cost_range
 order by total_product desc
 ;

 -----------------------------------------------------------
 /*
 Group customers into three segments based on their spending behavior:
     -VIP:Customers with at least 12 months of history and spending more than $5,000
	 -Regular: Customers with at least 12 months of history but spending $5000 and less than
	 -New: customers with a lifespan less than 12 months
	and find the total number of customers by each group
*/
with customer_segment as(
select
c.customer_key,
CONCAT(c.first_Name, ' ', c.Last_name) AS customer_name,
sum(f.sales_amount) as total_spending,
MIN(f.order_date) as first_order,
Max(f.order_date) as last_order,
DATEDIFF(month, MIN(f.order_date),max(f.order_date)) as lifeSpan
from GOLD.fact_sales as f
left join GOLD.dim_customer as c
on f.customer_key = c.customer_key
group by c.customer_key, c.first_Name, c.Last_name
)

select
customer_category,
count(customer_key) as Total_customer
from 
(
  select
  customer_key,
  customer_name,
  total_spending,
  lifeSpan,
  case
     when lifeSpan >= 12 and total_spending > 5000 then 'VIP'
     when lifeSpan >= 12 and total_spending <=5000 then 'Regular'
     else 'New Customer'
  end customer_category
  from customer_segment
)t
group by customer_category
;