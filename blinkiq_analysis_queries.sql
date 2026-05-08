CREATE DATABASE blinkiq;
USE blinkiq	;

CREATE TABLE sales_data (
    row_id INT,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code INT,
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name TEXT,
    sales FLOAT,
    quantity INT,
    discount FLOAT,
    profit FLOAT,
    order_year INT,
    order_month INT,
    profit_margin FLOAT,
    delivery_days INT
);


SELECT * from sales_data
LIMIT 5;

-- TOTAL SALES
SELECT 
ROUND(SUM(sales),2) AS total_sales
	FROM sales_data;
 
 -- TOTAL PROFIT
SELECT 
ROUND(SUM(profit),2) AS total_profit
	FROM sales_data;
    
-- TOTAL ORDERS
SELECT 
COUNT(distinct order_id) AS total_orders
	FROM sales_data;
    
-- AVERAGE ORDER VALUE
SELECT 
ROUND(SUM(sales)/COUNT(DISTINCT order_id),2)
 AS average_order_value
	FROM sales_data;
    
    
-- Category Performance Analysis

SELECT
	category,
    ROUND(SUM(sales),2) AS total_sales,
	ROUND(SUM(profit),2) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_sales DESC;

-- Regional Profitability

SELECT 
    region,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY region
ORDER BY total_profit DESC;

-- Top Customers

SELECT 
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales_data
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Discount Impact Analysis

SELECT 
    discount,
    ROUND(AVG(profit), 2) AS avg_profit
FROM sales_data
GROUP BY discount
ORDER BY discount;

-- Monthly Sales Trend

SELECT 
    order_month,
    ROUND(SUM(sales), 2) AS monthly_sales
FROM sales_data
GROUP BY order_month
ORDER BY order_month;

-- Top Customers Ranking

SELECT
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales,
    RANK() OVER(
        ORDER BY SUM(sales) DESC
    ) AS customer_rank
FROM sales_data
GROUP BY customer_name;


-- Monthly Running Sales Total

SELECT
    order_month,
    ROUND(SUM(sales), 2) AS monthly_sales,

    ROUND(
        SUM(SUM(sales)) OVER(
            ORDER BY order_month
        ),
        2
    ) AS running_total
FROM sales_data
GROUP BY order_month
ORDER BY order_month;


-- Monthly Sales Growth Analysis

WITH monthly_sales AS (

    SELECT
        order_month,
        ROUND(SUM(sales), 2) AS sales
    FROM sales_data
    GROUP BY order_month

)

SELECT
    order_month,
    sales,

    LAG(sales) OVER(
        ORDER BY order_month
    ) AS previous_month_sales,

    ROUND(
        (
            sales -
            LAG(sales) OVER(
                ORDER BY order_month
            )
        )
        /
        LAG(sales) OVER(
            ORDER BY order_month
        ) * 100,
        2
    ) AS growth_percentage

FROM monthly_sales;


-- Most Profitable Products

SELECT
    product_name,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


-- Loss-Making Products

SELECT
    product_name,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 10;


-- Delivery Performance Analytics

SELECT
    ship_mode,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM sales_data
GROUP BY ship_mode
ORDER BY avg_delivery_days;