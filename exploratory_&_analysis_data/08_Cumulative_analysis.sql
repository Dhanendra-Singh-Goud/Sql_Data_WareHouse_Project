/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

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