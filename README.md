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

