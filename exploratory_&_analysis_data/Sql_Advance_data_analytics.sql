-- Analysis Sales Perfomrance Over Time
select 
DATETRUNC(MONTH,order_date) as yearly,
sum(sales_amount) as total_sales
from GOLD.fact_sales
where order_date is not null
group by DATETRUNC(month,order_date)
order by yearly

--Calculate the total sales per month and 
--the running total of sales over time

WITH running_total AS (
    SELECT
        datetrunc(month, order_date) AS per_month,
        SUM(sales_amount) AS total_sales,
		avg(price) as avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY datetrunc(month, order_date)
   -- order by per_month
)
SELECT
    *,
    SUM(total_sales) OVER (ORDER BY per_month) AS running_total_sales,
	avg(avg_price) over(order by per_month) as avg_running_month
FROM running_total;


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

----------------------------------------------
--Which categories contribute the most to the overall sales ?
with category_sales as (
    select
        p.category,
        sum(f.sales_amount) as total_sales
    from gold.dim_product as p
    join GOLD.fact_sales as f
    on p.Product_key = f.product_key
    group by p.category
)
select
    category,
    total_sales,
	sum(total_sales) over() as overall_sales,
	concat(round((cast(total_sales as float)/sum(total_sales) over() )*100.00,2), '%') as contribution
from category_sales
order by contribution desc

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


/*
==============================================================================
Product Report
==============================================================================
Purpose:
   -This report consolidates key product metrics and behaviors

 Highlights:
    1.Gathers essential fields such as product name,  category, subcategory and cost.
	2. Segments products by revenue to identify High-performers, Mid_performers and Low_performer.
	3. Aggregateproduct-level metrics:
	   -total orders
	   -total sales
	   -total quantity sold
	   -total customers (unique)
	   -lifespan (in months)
	4. Calculates valuable KPIs:
	    -recency(month since last sale)
		-average order revenue 
		-average monthly revenue
	================================================================
	*/
	select * from gold.dim_product
	select * from gold.fact_sales;
	if OBJECT_ID('GOLD.product_report', 'V') is not null
	  DROP VIEW GOLD.product_report
	GO
	Create View Gold.product_report as
	with Base_query as (
	select
	p.product_key,
	p.product_number,
	p.product_name,
	p.category,
	p.sub_category,
	p.product_cost,
	f.order_number,
	f.customer_key,
	f.order_date,
	f.sales_amount,
	f.quantity
	from gold.fact_sales as f
	left join gold.dim_product as p
	on f.product_key = p.Product_key
	where f.order_date is not null
	),

	product_aggregation as(
	select 
	product_key,
	product_number,
	product_name,
	category,
	sub_category,
	count(distinct order_number) as total_order,
	sum(sales_amount) AS total_sales,
	sum(quantity) as total_quantity,
	count(distinct customer_key) as total_customers,
	max(order_date) as last_order_date,
	datediff(month, min(order_date), max(order_Date)) as lifespan,
	round(avg(cast(sales_amount as float)/nullIf(quantity,0)),2) as avg_selling_price
	from Base_query
	group by Product_key,
	product_number,
	product_name,
	category,
	sub_category
	)
	select 
	product_key,
	product_number,
	product_name,
	category,
	sub_category,
	total_customers,
	total_order,
	total_quantity,
	total_sales,
	datediff(month,last_order_date, GETDATE()) as recency,
	case 
	  when total_sales > 50000 then 'High-Performer'
	  when total_sales <= 10000 then 'Mid-Performer'
	  else 'Low-Performer'
	end product_segment,
	lifespan,
  -- Average Order Revenue
	case 
	  when total_sales <= 0 then 0
	  else total_sales/total_order
	end avg_order_revenue,
   --Average MOnthly_revenue
	case
	  when lifespan = 0 then total_sales
	  else total_sales/lifespan
	end avg_monthly_revenue
	from product_aggregation

select * from gold.product_report