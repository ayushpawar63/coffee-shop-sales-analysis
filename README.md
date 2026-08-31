# Coffee Shop Sales Analysis

A practical sales analysis project using **MySQL, SQL, Power BI, and DAX** to explore coffee shop transaction data and turn it into a business-focused dashboard.

## Business Problem

The objective of this project was to understand coffee shop sales performance and answer practical business questions such as:

- How are sales, orders, and quantity sold changing over time?
- Which product categories and products contribute most to sales?
- How do store locations compare?
- Which days and hours generate higher sales?
- How does performance change from one month to another?
- How do weekday and weekend sales compare?

The dashboard is intended to make these questions easier to explore instead of relying on manual analysis of individual transactions.

## Dataset

- Approximately **150,000 transaction records**
- Transaction-level sales data
- Date and time information
- Store and store location
- Product, product category, product type, and product detail
- Transaction quantity and unit price

## Tools Used

- **MySQL / SQL** – data loading, preparation, KPI calculations, and analysis
- **Power BI** – data modeling, visualization, and interactive reporting
- **DAX** – dynamic measures and month-over-month comparisons

## SQL Analysis

The SQL work includes:

- Creating the database and sales table
- Loading CSV data into MySQL
- Converting transaction dates into the required date format
- Calculating total sales, quantity sold, and orders
- Product and category sales analysis
- Store-location sales analysis
- Weekday vs. weekend analysis
- Day-level and time-based analysis
- Month-over-month comparison using the `LAG()` window function
- Above/below-average daily sales classification using a windowed `AVG()` calculation

## Power BI Dashboard

The Power BI report contains analysis for:

- Total Sales
- Total Orders
- Total Quantity Sold
- Sales trends
- Product category performance
- Top 10 products
- Store-wise sales performance
- Weekday vs. weekend sales
- Sales by day and hour
- Interactive month filtering
- Custom tooltips

## DAX

Dynamic measures were created for the main KPIs and month-over-month performance, including:

- Total Sales
- Total Orders
- Total Quantity Sold
- Month-over-Month Sales Growth / Difference
- Month-over-Month Orders Growth / Difference
- Month-over-Month Quantity Growth / Difference

## Project Workflow

```text
Transaction Data
      ↓
MySQL / SQL Analysis
      ↓
Data Modeling
      ↓
DAX Measures
      ↓
Power BI Dashboard
      ↓
Business Analysis
```

## Repository Structure

```text
coffee-shop-sales-analysis/
│
├── README.md
├── SQL/
│   └── Coffee shop Sales.sql
├── PowerBI/
│   └── Coffee Sales Project.pbix
└── Screenshots/
    └── dashboard.png
```

## Note

The Power BI report is provided as a `.pbix` file. To open and interact with the report, use **Power BI Desktop**.

The original transaction dataset is not included in this repository. The SQL script contains the database/table definition and data-loading logic used during the project.
