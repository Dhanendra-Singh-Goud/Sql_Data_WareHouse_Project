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