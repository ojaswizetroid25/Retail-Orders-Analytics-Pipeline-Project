-- 1. TOP 10 HIGHEST REVENUE PRODUCTS
SELECT TOP 10 
    product_id, SUM(sale_price) as total_sales
FROM df_orders 
GROUP BY product_id 
ORDER BY total_sales DESC;

-- 2. TOP 5 PRODUCTS PER REGION (Window Function)
WITH ranked_products AS (
    SELECT region, product_id, SUM(sale_price) as sales,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sale_price) DESC) as rn
    FROM df_orders 
    GROUP BY region, product_id
)
SELECT * FROM ranked_products WHERE rn <= 5;

-- 3. MONTH-OVER-MONTH GROWTH 2022 vs 2023
SELECT 
    MONTH(order_date) as month,
    SUM(CASE WHEN YEAR(order_date)=2022 THEN sale_price ELSE 0 END) as sales_2022,
    SUM(CASE WHEN YEAR(order_date)=2023 THEN sale_price ELSE 0 END) as sales_2023
FROM df_orders 
GROUP BY MONTH(order_date);

-- 4. HIGHEST SELLING MONTH PER CATEGORY
WITH monthly_sales AS (
    SELECT category, FORMAT(order_date, 'yyyy-MM') as year_month, 
           SUM(sale_price) as sales,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(sale_price) DESC) as rn
    FROM df_orders 
    GROUP BY category, FORMAT(order_date, 'yyyy-MM')
)
SELECT * FROM monthly_sales WHERE rn = 1;

-- 5. SUBCATEGORY PROFIT GROWTH 2023 vs 2022
WITH yearly_profit AS (
    SELECT sub_category,
           SUM(CASE WHEN YEAR(order_date)=2022 THEN profit ELSE 0 END) as profit_2022,
           SUM(CASE WHEN YEAR(order_date)=2023 THEN profit ELSE 0 END) as profit_2023
    FROM df_orders 
    GROUP BY sub_category
)
SELECT TOP 1 sub_category, 
       ((profit_2023 - profit_2022) * 100.0 / profit_2022) as growth_pct
FROM yearly_profit 
ORDER BY growth_pct DESC;

-- 6. OVERALL TOTALS
SELECT COUNT(*) as total_orders, 
       SUM(sale_price) as total_revenue,
       SUM(profit) as total_profit
FROM df_orders;

