# ☕ Coffee Shop Sales Analysis

An end-to-end sales analysis using MySQL, SQL, Power BI, and DAX to turn coffee shop transactions into findings about revenue, products, and busy periods.

![Coffee Shop Sales dashboard preview](Screenshots/COFFEE%20SHOP%20SALES%20DASHBOARD.jpg)

## Project overview

The project imports transaction records into MySQL, cleans and analyzes them with SQL, then presents the results in an interactive Power BI dashboard. The report covers overall sales, product and category performance, monthly trends, and day and hour patterns.

## Dataset

The source is Maven Analytics' [Coffee Shop Sales dataset](https://www.mavenanalytics.io/data-playground?accessType=open&page=2&pageSize=20), transaction records for a fictional New York City coffee shop chain.

| Detail | Value |
|---|---|
| Rows | 149,116 transaction records |
| Period | January 1–June 30, 2023 |
| Locations | Astoria, Hell's Kitchen, and Lower Manhattan |
| Fields | 11 source columns |

The table created by the SQL script contains these source columns:

| Column | Description |
|---|---|
| `transaction_id` | Transaction identifier |
| `transaction_date` | Transaction date |
| `transaction_time` | Transaction time |
| `transaction_qty` | Number of items in the transaction |
| `store_id` | Store identifier |
| `store_location` | Store location |
| `product_id` | Product identifier |
| `unit_price` | Price per item |
| `product_category` | Product category |
| `product_type` | Product type |
| `product_detail` | Product description |

Revenue is calculated as `transaction_qty × unit_price`; it is not a separate source column. The source CSV is not included in this repository. The SQL import statement currently points to a local file path, so update that path to the location of your downloaded CSV before running it.

## Business questions and findings

The Power BI dashboard reports **$698.8K in sales**, **149,116 transactions**, and **214,470 items sold** for the six-month period. Findings below use the dashboard and the Maven source dataset.

| Business question | Finding |
|---|---|
| What is the overall sales performance? | $698,812.33 in sales across 149,116 transaction records, with 214,470 items sold. |
| Which products contribute the most revenue? | Barista Espresso is the leading product type by revenue at about $91.4K. |
| Which product categories perform best? | Coffee leads with about $269,952 (38.6% of revenue); Tea is the next largest category. |
| What are the busiest days and hours? | Demand is concentrated in the morning, with the peak around 10 AM; Friday is among the busiest days. |
| How does performance vary across months? | Sales rise from about $81.7K in January to $166.5K in June, roughly doubling over the period, with a dip in February. |
| Which products may need attention? | Review low-volume menu lines against their margins and availability before reducing or replacing them; this sales dataset does not include cost or profit. |
| What actions can improve decisions? | Align morning staffing and replenishment with the rush, protect stock of leading coffee items, and test targeted offers in weaker periods. |

These are descriptive findings from a six-month dataset, not a forecast or a measure of profit.

## Dashboard

The Power BI report is available as [`Coffee Sales Project.pbix`](Coffee%20Sales%20Project.pbix). Download it and open it in Power BI Desktop to explore the report. The screenshot above provides a quick preview on GitHub without requiring Power BI Desktop.

## Key SQL queries

The full script is [`SQL/Coffee shop Sales.sql`](SQL/Coffee%20shop%20Sales.sql). These examples show the main calculations used in the analysis.

### Monthly sales and quantity

```sql
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS sales_month,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(*) AS total_orders
FROM coffee_sales
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY sales_month;
```

Aggregates sales, item quantity, and transaction records by month.

### Month-over-month sales change

```sql
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m') AS sales_month,
        SUM(unit_price * transaction_qty) AS total_sales
    FROM coffee_sales
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
),
sales_with_previous_month AS (
    SELECT
        sales_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sales_month) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_sales - previous_month_sales, 2) AS sales_change,
    ROUND(100 * (total_sales - previous_month_sales)
          / NULLIF(previous_month_sales, 0), 2) AS sales_change_pct
FROM sales_with_previous_month
ORDER BY sales_month;
```

Uses `LAG` to compare each month with the prior month.

### Sales by product category

```sql
SELECT
    product_category,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_sales
FROM coffee_sales
GROUP BY product_category
ORDER BY total_sales DESC;
```

Ranks categories by revenue to identify the strongest contributors.

### Sales by hour

```sql
SELECT
    HOUR(transaction_time) AS sales_hour,
    COUNT(*) AS transaction_count,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_sales
FROM coffee_sales
GROUP BY HOUR(transaction_time)
ORDER BY sales_hour;
```

Summarizes transactions and sales by hour to support staffing and replenishment decisions.

## Core DAX measures

The Power BI file contains the interactive report. These core measures express the dashboard KPIs using the `coffee_sales` table created in the SQL script.

```DAX
Total Sales =
SUMX(
    coffee_sales,
    coffee_sales[transaction_qty] * coffee_sales[unit_price]
)

Total Orders =
DISTINCTCOUNT(coffee_sales[transaction_id])

Total Quantity Sold =
SUM(coffee_sales[transaction_qty])

Average Order Value =
DIVIDE([Total Sales], [Total Orders])
```

- **Total Sales** multiplies item quantity by unit price for each transaction row and sums the result.
- **Total Orders** counts unique transaction IDs.
- **Total Quantity Sold** sums the item quantities.
- **Average Order Value** divides sales by the number of orders and safely handles a zero denominator.

## Tools

| Tool | Purpose |
|---|---|
| MySQL / SQL | Database setup, data preparation, and sales analysis |
| Power BI | Interactive dashboard and visual analysis |
| DAX | KPI and business metric calculations |
| GitHub | Source control and project documentation |

## Project workflow

Raw transaction data → MySQL import → data cleaning and validation → SQL analysis → Power BI model → DAX measures → dashboard → findings and recommendations.

