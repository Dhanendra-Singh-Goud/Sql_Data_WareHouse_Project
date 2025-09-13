/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
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