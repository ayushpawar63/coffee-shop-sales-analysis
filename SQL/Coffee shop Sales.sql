CREATE DATABASE coffee_shop_sales;

USE coffee_shop_sales;

CREATE TABLE coffee_sales (
    transaction_id INT,
    transaction_date DATE,
    transaction_time TIME,
    transaction_qty INT,
    store_id INT,
    store_location VARCHAR(100),
    product_id INT,
    unit_price DECIMAL(10,2),
    product_category VARCHAR(100),
    product_type VARCHAR(150),
    product_detail VARCHAR(255)
);

LOAD DATA LOCAL INFILE 'C:/Users/pawar/OneDrive/Desktop/Coffee Shop Sales.csv'
INTO TABLE coffee_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    transaction_id,
    @transaction_date,
    transaction_time,
    transaction_qty,
    store_id,
    store_location,
    product_id,
    unit_price,
    product_category,
    product_type,
    product_detail
)
SET transaction_date = STR_TO_DATE(@transaction_date, '%d-%m-%Y');

SELECT *
FROM coffee_sales
LIMIT 10;

describe coffee_sales;

SELECT
    SUM(unit_price * transaction_qty) AS Total_Sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 1;

SELECT
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS Total_quantity_sold,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
     OVER (ORDER BY MONTH(transaction_date))) /
     LAG(SUM(unit_price * transaction_qty), 1)
     OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM coffee_sales
WHERE MONTH(transaction_date) IN (4, 5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

SELECT
    SUM(transaction_qty) AS Total_quantity_sold
FROM coffee_sales
WHERE MONTH(transaction_date) = 6;

SELECT *
FROM coffee_sales
LIMIT 10;

SELECT
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'k') AS Total_Sales,
    CONCAT(ROUND(SUM(transaction_qty)/1000,1), 'K') AS Total_Quantity_Sold,
    CONCAT(ROUND(COUNT(transaction_id)/1000,1), 'k') AS Total_Orders
FROM coffee_sales
WHERE transaction_date = '2023-05-18';

SELECT
    IF(DAYOFWEEK(transaction_date) IN (1,7),'Weekend','Weekdays') AS Day_type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1), 'k') AS Total_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 2
GROUP BY IF(DAYOFWEEK(transaction_date) IN (1,7),'Weekend','Weekdays');

SELECT
    store_location,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1), 'k') AS Total_sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
group by store_location
ORDER BY Total_sales DESC;

SELECT
    DAY(transaction_date) AS Day_of_month,
    SUM(unit_price * transaction_qty) AS Total_Sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
group by DAY(transaction_date)
ORDER BY DAY(transaction_date);

SELECT
    day_of_month,
    CASE
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM coffee_sales
    WHERE MONTH(transaction_date) = 5
    GROUP BY DAY(transaction_date)
) AS sales_data
ORDER BY day_of_month;

SELECT * FROM coffee_sales;

SELECT
    product_category,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1), 'k') AS Total_Sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
group by product_category;

SELECT
    product_type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1), 'k') AS Total_Sales
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
group by product_category, product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10;

SELECT
    SUM(unit_price * transaction_qty) AS Total_sales,
    SUM(transaction_qty) AS Total_qty_sold,
    COUNT(*) AS Total_Orders
FROM coffee_sales
WHERE MONTH(transaction_date) = 5
AND DAYOFWEEK(transaction_date) = 1
AND HOUR(transaction_time) = 14;
