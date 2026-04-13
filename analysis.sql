-- Business Problem:
-- Which categories generate profit vs just revenue?

SELECT 
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / SUM(sales), 2) AS profit_margin
FROM superstore
GROUP BY category
ORDER BY profit_margin DESC;

-- Insight:
-- High sales doesn't always mean high profitability.

-- Business Problem:
-- Find sub-categories with high sales but negative profit

SELECT 
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY sub_category
HAVING SUM(sales) > 50000 
   AND SUM(profit) < 0
ORDER BY total_sales DESC;

-- Insight:
-- These areas are generating revenue but losing money.

-- Business Problem:
-- How does discount affect profitability?

SELECT 
    discount,
    COUNT(*) AS total_orders,
    ROUND(AVG(profit), 2) AS avg_profit
FROM superstore
GROUP BY discount
ORDER BY discount;

-- Insight:
-- Higher discounts often reduce profitability.

-- Business Problem:
-- Identify top revenue-generating customers (top 20%)

WITH customer_sales AS (
    SELECT 
        customer_name,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY customer_name
),
ranked_customers AS (
    SELECT 
        customer_name,
        total_sales,
        NTILE(5) OVER (ORDER BY total_sales DESC) AS percentile_group
    FROM customer_sales
)
SELECT *
FROM ranked_customers
WHERE percentile_group = 1;

-- Insight:
-- Small group of customers drives most revenue.

-- Business Problem:
-- Understand customer retention behavior

SELECT 
    CASE 
        WHEN COUNT(DISTINCT order_id) = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS num_customers
FROM superstore
GROUP BY customer_name;

-- Insight:
-- Helps evaluate customer loyalty.

-- Business Problem:
-- Which regions are causing losses?

SELECT 
    region,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY region
ORDER BY total_profit ASC;

-- Insight:
-- Regions with negative profit need attention.

-- Business Problem:
-- Identify orders with multiple products

SELECT 
    order_id,
    COUNT(DISTINCT product_name) AS product_count
FROM superstore
GROUP BY order_id
HAVING COUNT(DISTINCT product_name) > 3;

-- Insight:
-- Indicates bulk buying behavior.

-- Business Problem:
-- Which regions have slow delivery?

SELECT 
    region,
    AVG(ship_date - order_date) AS avg_delivery_days
FROM superstore
GROUP BY region
ORDER BY avg_delivery_days DESC;

-- Insight:
-- Higher delivery time = operational inefficiency.

-- Business Problem:
-- Who brings the most profit (not just revenue)?

SELECT 
    customer_name,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;

-- Insight:
-- Focus retention efforts on these customers.
-- Business Problem:
-- Identify seasonal sales patterns

SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY month
ORDER BY total_sales DESC;

-- Insight:
-- Helps plan inventory and marketing.

-- Business Problem:
-- Are categories overly dependent on discounts?

SELECT 
    category,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY category;

-- Insight:
-- High discount + low profit = bad strategy.

-- Business Problem:
-- Track profit growth over time

SELECT 
    order_date,
    SUM(profit) AS daily_profit,
    SUM(SUM(profit)) OVER (ORDER BY order_date) AS cumulative_profit
FROM superstore
GROUP BY order_date;

-- Insight:
-- Shows business growth trajectory.

-- Business Problem:
-- Identify worst-performing sub-categories

SELECT 
    sub_category,
    SUM(profit) AS total_loss
FROM superstore
GROUP BY sub_category
ORDER BY total_loss ASC
LIMIT 5;

-- Insight:
-- Candidates for removal or strategy change.

-- Business Problem:
-- Compare performance across customer segments

SELECT 
    segment,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY segment;

-- Insight:
-- Helps target profitable segments.

-- Business Problem:
-- Identify transactions that hurt business

SELECT 
    order_id,
    sales,
    discount,
    profit
FROM superstore
WHERE discount > 0.3 
  AND profit < 0;

-- Insight:
-- These orders should be minimized.
