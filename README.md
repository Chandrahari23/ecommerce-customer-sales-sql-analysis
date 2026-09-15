Business-focused e-commerce sales, customer, profitability, delivery and returns analysis using MySQL.
# E-Commerce Customer & Sales Intelligence — SQL Analysis

## 📌 Project Overview

This project analyzes a realistic e-commerce dataset using **MySQL** to generate business insights across sales, profitability, customers, products, delivery operations, shipping performance, and returns.

The objective is to transform transactional data into actionable insights that can help an e-commerce business improve:

- Revenue
- Profitability
- Customer retention
- Product performance
- Delivery performance
- Return management
- Overall operational efficiency

This repository represents the **SQL analysis phase** of a larger E-Commerce Customer & Sales Intelligence analytics project.

---

## 🎯 Business Objective

The primary objective is to analyze e-commerce transactions and answer important business questions such as:

- How much revenue and profit does the company generate?
- How is sales performance changing over time?
- Which product categories generate the most revenue and profit?
- Which products generate high sales but low or negative profit?
- How does discounting affect profitability?
- How many customers are repeat customers?
- Who are the most valuable customers?
- Which customers are at risk of being lost?
- Which shipping modes perform best?
- What is the late delivery rate?
- What is the product return rate?
- What are the major reasons for product returns?
- Which business areas require management attention?
- What actions can improve revenue, profitability, customer retention, and operations?

---

# 🗂️ Dataset

The project uses four related tables covering customer information, products, transactions, and delivery/return operations.

The dataset contains approximately **24,000 records across four tables** and covers the period from **January 2024 to December 2025**.

---

## 1. Customers

Contains customer-level information.

### Important Columns

- `customer_id`
- `customer_name`
- `gender`
- `age`
- `region`
- `state`
- `city`
- `signup_date`

**Records:** 5,000 customers

---

## 2. Products

Contains product and pricing information.

### Important Columns

- `product_id`
- `product_name`
- `category`
- `subcategory`
- `brand`
- `unit_cost`
- `list_price`

**Records:** 300 products

---

## 3. Orders

Contains transactional sales information.

### Important Columns

- `order_id`
- `order_date`
- `customer_id`
- `product_id`
- `quantity`
- `discount_pct`
- `shipping_mode`
- `payment_method`
- `sales_amount`
- `shipping_cost`
- `profit`
- `order_status`

**Records:** 12,000 orders

---

## 4. Order Delivery & Returns

Contains delivery and product-return information.

### Important Columns

- `order_id`
- `delivery_date`
- `delivery_days`
- `delivery_status`
- `return_status`
- `return_reason`
- `refund_amount`

**Records:** 12,000 order-level records

---

# 🔗 Database Relationships

```text
Customers
    │
    │ customer_id
    ▼
Orders
    │
    │ product_id
    ▼
Products

Orders
    │
    │ order_id
    ▼
Order Delivery & Returns

Relationships
customers.customer_id → orders.customer_id
products.product_id → orders.product_id
orders.order_id → order_delivery_returns.order_id

All relationships were validated during data preparation.

🧹 Data Preparation & Quality

Before performing the SQL analysis, the dataset was cleaned and validated.

The preparation process included:

Handling missing values
Standardizing text fields
Converting dates and numeric fields into appropriate formats
Checking duplicate IDs
Validating primary keys
Checking foreign-key relationships
Handling missing customer demographic information
Handling missing payment information
Handling missing delivery and return information
Validating referential integrity

Data Quality Results
| Table                    | Raw Records | Clean Records |
| ------------------------ | ----------: | ------------: |
| Customers                |       5,000 |         5,000 |
| Products                 |         300 |           300 |
| Orders                   |      12,000 |        12,000 |
| Order Delivery & Returns |      12,000 |        12,000 |
All major foreign-key relationships were validated successfully with zero orphan records.

Detailed data preparation and validation files are available in the documentation folder.

🛠️ Tools & Technologies
MySQL
MySQL Workbench
SQL
GitHub
Data Cleaning & Validation
Business Analytics
📊 SQL Analysis Performed
1. Executive KPI Analysis

Calculated key business KPIs including:

Total Orders
Units Sold
Total Revenue
Total Profit
Average Order Value (AOV)
Profit Margin
Total Customers
Repeat Customers
Repeat Purchase Rate
Average Delivery Days
Late Delivery Rate
Return Rate
2. Sales Analysis

Analyzed:

Yearly revenue
Yearly profit
Year-over-year revenue growth
Year-over-year profit growth
Monthly revenue trends
Category revenue
Category profitability
Product-level performance
3. Product & Profitability Analysis

Analyzed:

Top products by revenue
Top products by profit
High-revenue but low-profit products
Negative-profit products
Category-level profitability
Product profit margins

This analysis helps identify products that generate strong sales but may require pricing, cost, or discount strategy changes.

4. Discount & Profitability Analysis

Analyzed the relationship between discount levels and profitability.

Discount bands used:

No Discount
1–10%
11–20%
21–30%
30%+

The analysis showed a clear decline in observed profit margin as discount levels increased.

Note: discount_pct is stored as a decimal proportion in the database. For example, 0.10 represents a 10% discount.

5. Customer Analysis

Analyzed:

Purchasing customers
Orders per customer
One-time customers
Repeat customers
Repeat purchase rate
Top customers by revenue
Customer revenue segments
6. RFM Customer Segmentation

Customer behavior was analyzed using RFM analysis.

Recency

How recently the customer made a purchase.

Frequency

How frequently the customer purchased.

Monetary Value

How much revenue the customer generated.

The analysis classified customers into segments including:

Champions
Loyal Customers
Potential Loyalists
New Customers
At Risk
Lost Customers

This segmentation can support targeted retention, reactivation, and loyalty campaigns.

7. Delivery & Shipping Analysis

Analyzed:

Delivery status
Average delivery time
Shipping mode performance
Late delivery rate
Delivery efficiency

Shipping modes analyzed:

Same Day
Express
Standard
8. Returns Analysis

Analyzed:

Return rate
Number of returned orders
Refund impact
Return reasons
Returns by product category

Major return reasons included:

Quality Issue
Damaged
Changed Mind
Wrong Item
Late Delivery
📈 Key Business Findings
1. Strong Overall Profitability

Across 2024 and 2025, the company generated approximately:

₹3.76 Crore Revenue
₹1.01 Crore Profit
26.78% Profit Margin

This indicates a healthy overall profitability position.

2. Revenue Growth Is Relatively Slow

Revenue increased from:

2024: ₹1.86 Crore
2025: ₹1.90 Crore

This represents approximately 2.11% year-over-year revenue growth.

Profit increased by approximately 4.04%, indicating that profit grew faster than revenue during the period.

3. Repeat Customers Represent a Major Opportunity

The analysis identified:

3,921 purchasing customers
2,552 repeat customers
1,369 one-time customers
65.09% repeat purchase rate

The business already has a strong repeat-customer base, creating an opportunity to further improve customer lifetime value through targeted retention strategies.

4. Home & Kitchen Leads Revenue

Among the major product categories:
| Category       |  Revenue |   Profit | Profit Margin |
| -------------- | -------: | -------: | ------------: |
| Home & Kitchen | ₹1.11 Cr | ₹27.98 L |        25.16% |
| Electronics    | ₹88.03 L | ₹25.28 L |        28.71% |
| Fashion        | ₹85.04 L | ₹21.91 L |        25.76% |
| Sports         | ₹59.15 L | ₹16.38 L |        27.69% |
| Beauty         | ₹32.40 L |  ₹9.11 L |        28.13% |
Home & Kitchen is the largest revenue-generating category, while Electronics has a stronger profit margin.

5. Heavy Discounts Reduce Profitability

Profit margin decreases significantly as discount levels increase.
| Discount Band | Orders |  Revenue | Profit Margin |
| ------------- | -----: | -------: | ------------: |
| No Discount   |  1,462 | ₹50.43 L |        35.40% |
| 1–10%         |  5,587 | ₹1.84 Cr |        29.60% |
| 11–20%        |  3,868 | ₹1.14 Cr |        22.23% |
| 21–30%        |  1,083 | ₹28.10 L |        11.28% |
| 30%+          |      0 |       ₹0 |             — |

The observed profit margin falls from 35.40% with no discount to 11.28% at 21–30% discounting.

This suggests that aggressive discounting should be carefully controlled and targeted.

6. Delivery Performance Requires Attention

The analysis shows:

11,521 delivered orders
4,608 late orders
40.00% late delivery rate
5.01 average delivery days

Delivery performance is therefore one of the major operational areas requiring improvement.

Shipping Mode Observation
| Shipping Mode | Average Delivery Days | Late Delivery Rate |
| ------------- | --------------------: | -----------------: |
| Same Day      |                  2.02 |             71.78% |
| Express       |                  3.74 |             59.21% |
| Standard      |                  5.79 |             29.38% |
Although Same Day and Express have shorter average delivery times, their observed late-delivery rates are substantially higher. This indicates a potential issue with aggressive delivery commitments or service-level execution that requires further operational investigation.

7. Returns Have a Significant Financial Impact

The overall return rate is approximately:

8.68%

Major return reasons include:

Quality Issues
Damaged Products
Changed Mind
Wrong Item
Late Delivery

The largest return categories by refund impact include Electronics and Home & Kitchen.

Reducing preventable returns can improve both customer satisfaction and profitability.

8. Customer Segmentation Reveals Retention Opportunities

The RFM analysis identified:
| RFM Segment         | Customers |
| ------------------- | --------: |
| Potential Loyalists |     1,144 |
| Champions           |       809 |
| Lost Customers      |       728 |
| Loyal Customers     |       525 |
| At Risk             |       400 |
| New Customers       |       315 |
The relatively large Potential Loyalist and At Risk/Lost groups provide opportunities for targeted retention and reactivation campaigns.

💡 Top 5 Business Recommendations
1. Reduce Excessive Discounting

Introduce minimum-margin thresholds for promotions and prioritize targeted discounts instead of broad high-percentage discounts.

Particular attention should be given to discounts above 20%, where the observed profit margin falls significantly.

2. Improve Delivery Performance

Investigate the causes of late deliveries by analyzing:

Shipping mode
Carrier performance
Warehouse operations
Region
Delivery SLAs
Operational delays

The unusually high late-delivery rates for Same Day and Express orders should receive particular attention.

Improving delivery reliability could reduce customer dissatisfaction and prevent delivery-related returns.

3. Target At-Risk and Lost Customers

Use RFM segmentation to create targeted campaigns for:

At Risk customers
Lost Customers
Potential Loyalists

Champions and Loyal Customers can be targeted with loyalty programs, personalized offers, and retention strategies.

4. Reduce Preventable Returns

Focus on:

Product quality checks
Better packaging
Accurate product descriptions
Correct order fulfillment
Quality monitoring

Quality issues and damaged products should receive particular attention.

5. Optimize the Product Portfolio

Identify products with:

High revenue but low profit
Negative profit
High return rates
Strong profitability

Management can review pricing, discounts, sourcing costs, and product strategy for underperforming products.

🔍 Key SQL Concepts Demonstrated

This project demonstrates practical SQL skills including:

SELECT
WHERE
GROUP BY
HAVING
ORDER BY
Aggregate Functions
CASE
JOIN
INNER JOIN
LEFT JOIN
Common Table Expressions (CTEs)
Window Functions
NTILE()
Date Functions
Conditional Aggregation
Subqueries
KPI Calculations
Customer Segmentation
RFM Analysis
Business-focused SQL Analysis

📁 Project Structure

ecommerce-customer-sales-sql-analysis/
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_delivery_returns.csv
│
├── documentation/
│   ├── data_dictionary.csv
│   ├── cleaning_log.csv
│   ├── data_quality_report.csv
│   └── referential_integrity_report.csv
│
├── sql/
│   └── ecommerce_analysis.sql
│
├── README.md
└── .gitignore

🎓 Skills Demonstrated

Through this project, I demonstrated:

SQL data analysis
Relational database concepts
Data cleaning and validation
Business KPI development
Customer analytics
Product profitability analysis
RFM segmentation
Operational analytics
Data-driven problem solving
Business insight generation
Data-driven recommendations





