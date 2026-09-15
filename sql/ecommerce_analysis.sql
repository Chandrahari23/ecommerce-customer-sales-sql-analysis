-- =====================================================
-- E-COMMERCE CUSTOMER & SALES INTELLIGENCE
-- FINAL SQL BUSINESS ANALYSIS
-- =====================================================

USE ecommerce_analytics;


-- =====================================================
-- 1. DATABASE & TABLE VALIDATION
-- =====================================================

-- Verify available tables
SHOW TABLES;

-- Check table structures
DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE order_delivery_returns;

-- Verify row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers
UNION ALL
SELECT 'products', COUNT(*)
FROM products
UNION ALL
SELECT 'orders', COUNT(*)
FROM orders
UNION ALL
SELECT 'order_delivery_returns', COUNT(*)
FROM order_delivery_returns;


-- =====================================================
-- 2. EXECUTIVE KPIs
-- =====================================================

-- Core Sales KPIs
SELECT
    COUNT(order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(sales_amount), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(sales_amount) / COUNT(order_id), 2) AS average_order_value,
    ROUND(SUM(profit) / SUM(sales_amount) * 100, 2) AS profit_margin
FROM orders;


-- Delivery & Return KPIs
SELECT
    ROUND(
        AVG(
            CASE
                WHEN delivery_status IN ('On Time', 'Late')
                THEN delivery_days
            END
        ), 2
    ) AS average_delivery_days,

    ROUND(
        SUM(
            CASE
                WHEN delivery_status = 'Late'
                THEN 1
                ELSE 0
            END
        )
        /
        SUM(
            CASE
                WHEN delivery_status IN ('On Time', 'Late')
                THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS late_delivery_rate,

    ROUND(
        SUM(
            CASE
                WHEN return_status = 'Returned'
                THEN 1
                ELSE 0
            END
        )
        / COUNT(*) * 100,
        2
    ) AS return_rate,

    ROUND(
        SUM(
            CASE
                WHEN return_status = 'Returned'
                THEN refund_amount
                ELSE 0
            END
        ),
        2
    ) AS total_refunds
FROM order_delivery_returns;


-- =====================================================
-- 3. SALES TREND ANALYSIS
-- =====================================================

-- Revenue by Year
SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_revenue
FROM orders
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- Revenue & Profit by Year
SELECT
    YEAR(order_date) AS order_year,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(sales_amount), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- Monthly Revenue Trend
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    ROUND(SUM(sales_amount), 2) AS total_revenue
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;


-- =====================================================
-- 4. CATEGORY PERFORMANCE
-- =====================================================

-- Revenue by Category
SELECT
    p.category,
    ROUND(SUM(o.sales_amount), 2) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Revenue, Profit & Margin by Category
SELECT
    p.category,
    ROUND(SUM(o.sales_amount), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit,
    ROUND(
        SUM(o.profit) / SUM(o.sales_amount) * 100,
        2
    ) AS profit_margin
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- =====================================================
-- 5. PRODUCT PERFORMANCE
-- =====================================================

-- Top 10 Products by Revenue
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS units_sold,
    ROUND(SUM(o.sales_amount), 2) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC
LIMIT 10;


-- Top 10 Products by Profit
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS units_sold,
    ROUND(SUM(o.sales_amount), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_profit DESC
LIMIT 10;


-- High-Revenue Products with Non-Positive Profit
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS units_sold,
    ROUND(SUM(o.sales_amount), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit,
    ROUND(
        SUM(o.profit) / SUM(o.sales_amount) * 100,
        2
    ) AS profit_margin
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
HAVING
    SUM(o.sales_amount) > 10000
    AND SUM(o.profit) <= 0
ORDER BY total_revenue DESC;


-- =====================================================
-- 6. DISCOUNT & PROFITABILITY
-- =====================================================

-- Discount Impact on Profitability
-- discount_pct is stored as a decimal:
-- 0.10 = 10%, 0.20 = 20%, etc.

SELECT
    CASE
        WHEN discount_pct = 0 THEN 'No Discount'
        WHEN discount_pct <= 0.10 THEN '1-10%'
        WHEN discount_pct <= 0.20 THEN '11-20%'
        WHEN discount_pct <= 0.30 THEN '21-30%'
        ELSE '30%+'
    END AS discount_band,

    COUNT(order_id) AS total_orders,

    ROUND(SUM(sales_amount), 2) AS total_revenue,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) / SUM(sales_amount) * 100,
        2
    ) AS profit_margin

FROM orders

GROUP BY
    CASE
        WHEN discount_pct = 0 THEN 'No Discount'
        WHEN discount_pct <= 0.10 THEN '1-10%'
        WHEN discount_pct <= 0.20 THEN '11-20%'
        WHEN discount_pct <= 0.30 THEN '21-30%'
        ELSE '30%+'
    END

ORDER BY MIN(discount_pct);


-- =====================================================
-- 7. CUSTOMER ANALYSIS
-- =====================================================

-- Number of Purchasing Customers
SELECT
    COUNT(DISTINCT customer_id) AS purchasing_customers
FROM orders;


-- Orders per Customer
SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;


-- One-Time vs Repeat Customers
SELECT
    CASE
        WHEN total_orders = 1
            THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,

    COUNT(*) AS customer_count

FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) AS customer_orders

GROUP BY
    CASE
        WHEN total_orders = 1
            THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END;


-- Repeat Purchase Rate
SELECT
    COUNT(
        CASE
            WHEN total_orders > 1 THEN 1
        END
    ) AS repeat_customers,

    COUNT(*) AS total_customers,

    ROUND(
        COUNT(
            CASE
                WHEN total_orders > 1 THEN 1
            END
        )
        / COUNT(*) * 100,
        2
    ) AS repeat_purchase_rate

FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) AS customer_orders;


-- Top 10 Customers by Revenue
SELECT
    o.customer_id,
    c.customer_name,
    c.city,
    c.state,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.sales_amount), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY
    o.customer_id,
    c.customer_name,
    c.city,
    c.state
ORDER BY total_revenue DESC
LIMIT 10;


-- Customer Revenue Segmentation
SELECT
    CASE
        WHEN total_revenue < 5000
            THEN 'Low Value'
        WHEN total_revenue < 15000
            THEN 'Medium Value'
        WHEN total_revenue < 30000
            THEN 'High Value'
        ELSE 'Very High Value'
    END AS customer_segment,

    COUNT(*) AS customer_count,

    ROUND(SUM(total_revenue), 2) AS segment_revenue

FROM (
    SELECT
        customer_id,
        SUM(sales_amount) AS total_revenue
    FROM orders
    GROUP BY customer_id
) AS customer_revenue

GROUP BY
    CASE
        WHEN total_revenue < 5000
            THEN 'Low Value'
        WHEN total_revenue < 15000
            THEN 'Medium Value'
        WHEN total_revenue < 30000
            THEN 'High Value'
        ELSE 'Very High Value'
    END

ORDER BY segment_revenue DESC;


-- =====================================================
-- 8. RFM CUSTOMER SEGMENTATION
-- =====================================================

-- RFM Base
WITH rfm_base AS (
    SELECT
        customer_id,

        DATEDIFF(
            '2025-12-31',
            MAX(order_date)
        ) AS recency_days,

        COUNT(order_id) AS frequency,

        ROUND(
            SUM(sales_amount),
            2
        ) AS monetary_value

    FROM orders

    GROUP BY customer_id
)

SELECT *
FROM rfm_base;


-- RFM Scoring
WITH rfm_base AS (
    SELECT
        customer_id,
        DATEDIFF(
            '2025-12-31',
            MAX(order_date)
        ) AS recency_days,
        COUNT(order_id) AS frequency,
        ROUND(SUM(sales_amount), 2) AS monetary_value
    FROM orders
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary_value,

        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS monetary_score

    FROM rfm_base
)

SELECT
    *,
    CONCAT(
        recency_score,
        frequency_score,
        monetary_score
    ) AS rfm_score

FROM rfm_scores;


-- RFM Customer Segmentation
WITH rfm_base AS (
    SELECT
        customer_id,
        DATEDIFF(
            '2025-12-31',
            MAX(order_date)
        ) AS recency_days,
        COUNT(order_id) AS frequency,
        ROUND(SUM(sales_amount), 2) AS monetary_value
    FROM orders
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS m_score

    FROM rfm_base
)

SELECT
    customer_id,
    recency_days,
    frequency,
    monetary_value,
    r_score,
    f_score,
    m_score,

    CASE
        WHEN r_score >= 4
             AND f_score >= 4
             AND m_score >= 4
            THEN 'Champions'

        WHEN r_score >= 3
             AND f_score >= 4
            THEN 'Loyal Customers'

        WHEN r_score >= 4
             AND f_score <= 2
            THEN 'New Customers'

        WHEN r_score <= 2
             AND f_score >= 3
             AND m_score >= 3
            THEN 'At Risk'

        WHEN r_score <= 2
             AND f_score <= 2
             AND m_score <= 2
            THEN 'Lost Customers'

        ELSE 'Potential Loyalists'
    END AS customer_segment

FROM rfm_scores;


-- RFM Segment Counts
WITH rfm_base AS (
    SELECT
        customer_id,
        DATEDIFF(
            '2025-12-31',
            MAX(order_date)
        ) AS recency_days,
        COUNT(order_id) AS frequency,
        ROUND(SUM(sales_amount), 2) AS monetary_value
    FROM orders
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS r_score,

        NTILE(5) OVER (
            ORDER BY frequency
        ) AS f_score,

        NTILE(5) OVER (
            ORDER BY monetary_value
        ) AS m_score

    FROM rfm_base
),

segmented_customers AS (
    SELECT
        *,
        CASE
            WHEN r_score >= 4
                 AND f_score >= 4
                 AND m_score >= 4
                THEN 'Champions'

            WHEN r_score >= 3
                 AND f_score >= 4
                THEN 'Loyal Customers'

            WHEN r_score >= 4
                 AND f_score <= 2
                THEN 'New Customers'

            WHEN r_score <= 2
                 AND f_score >= 3
                 AND m_score >= 3
                THEN 'At Risk'

            WHEN r_score <= 2
                 AND f_score <= 2
                 AND m_score <= 2
                THEN 'Lost Customers'

            ELSE 'Potential Loyalists'
        END AS customer_segment

    FROM rfm_scores
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count

FROM segmented_customers

GROUP BY customer_segment

ORDER BY customer_count DESC;


-- =====================================================
-- 9. DELIVERY & SHIPPING ANALYSIS
-- =====================================================

-- Delivery Status Overview
SELECT
    delivery_status,
    COUNT(*) AS order_count
FROM order_delivery_returns
GROUP BY delivery_status;


-- Average Delivery Time
SELECT
    ROUND(
        AVG(delivery_days),
        2
    ) AS average_delivery_days
FROM order_delivery_returns
WHERE delivery_status IN ('On Time', 'Late');


-- Shipping Mode Performance
SELECT
    o.shipping_mode,

    COUNT(o.order_id) AS total_orders,

    ROUND(
        AVG(d.delivery_days),
        2
    ) AS avg_delivery_days,

    SUM(
        CASE
            WHEN d.delivery_status = 'Late'
            THEN 1
            ELSE 0
        END
    ) AS late_orders

FROM orders o

JOIN order_delivery_returns d
    ON o.order_id = d.order_id

WHERE d.delivery_status IN ('On Time', 'Late')

GROUP BY o.shipping_mode

ORDER BY avg_delivery_days;


-- Late Delivery Rate
SELECT
    COUNT(
        CASE
            WHEN delivery_status = 'Late'
            THEN 1
        END
    ) AS late_orders,

    COUNT(
        CASE
            WHEN delivery_status IN ('On Time', 'Late')
            THEN 1
        END
    ) AS delivered_orders,

    ROUND(
        COUNT(
            CASE
                WHEN delivery_status = 'Late'
                THEN 1
            END
        )
        /
        COUNT(
            CASE
                WHEN delivery_status IN ('On Time', 'Late')
                THEN 1
            END
        ) * 100,
        2
    ) AS late_delivery_rate

FROM order_delivery_returns;


-- =====================================================
-- 10. RETURN ANALYSIS
-- =====================================================

-- Overall Return Rate
SELECT
    COUNT(
        CASE
            WHEN return_status = 'Returned'
            THEN 1
        END
    ) AS returned_orders,

    COUNT(*) AS total_orders,

    ROUND(
        COUNT(
            CASE
                WHEN return_status = 'Returned'
                THEN 1
            END
        )
        / COUNT(*) * 100,
        2
    ) AS return_rate

FROM order_delivery_returns;


-- Return Reasons
SELECT
    return_reason,
    COUNT(*) AS returned_orders,
    ROUND(SUM(refund_amount), 2) AS total_refund_amount

FROM order_delivery_returns

WHERE return_status = 'Returned'

GROUP BY return_reason

ORDER BY returned_orders DESC;


-- Return Impact by Category
SELECT
    p.category,

    COUNT(
        CASE
            WHEN d.return_status = 'Returned'
            THEN 1
        END
    ) AS returned_orders,

    ROUND(
        SUM(
            CASE
                WHEN d.return_status = 'Returned'
                THEN d.refund_amount
                ELSE 0
            END
        ),
        2
    ) AS total_refunds

FROM orders o

JOIN products p
    ON o.product_id = p.product_id

JOIN order_delivery_returns d
    ON o.order_id = d.order_id

GROUP BY p.category

ORDER BY total_refunds DESC;


-- =====================================================
-- 11. FINAL BUSINESS INSIGHTS
-- =====================================================

/*
Key findings from the analysis:

1. The business generated strong overall revenue and profit,
   but delivery performance remains a major operational issue.

2. Customer retention is relatively strong, with a significant
   proportion of purchasing customers being repeat customers.

3. Home & Kitchen is the largest revenue-generating category,
   while some other categories achieve stronger profit margins.

4. Higher discount levels are associated with substantially
   lower profit margins.

5. Returns create a significant financial impact, with quality
   issues and damaged products being major return reasons.

6. RFM segmentation identifies Champions, Loyal Customers,
   Potential Loyalists, At-Risk customers and Lost Customers,
   enabling targeted customer strategies.
*/


-- =====================================================
-- 12. BUSINESS RECOMMENDATIONS
-- =====================================================

/*
1. Optimize discount strategies
   - Reduce excessive blanket discounts.
   - Use targeted promotions based on customer value.
   - Protect minimum profit margins.

2. Improve delivery performance
   - Investigate high late-delivery rates.
   - Monitor courier and fulfillment performance.
   - Prioritize SLA improvement for faster shipping modes.

3. Strengthen customer retention
   - Reward Champions and Loyal Customers.
   - Reactivate At-Risk customers.
   - Run targeted win-back campaigns for Lost Customers.

4. Reduce preventable returns
   - Improve quality control and packaging.
   - Investigate products/categories with high return rates.
   - Reduce quality- and damage-related returns.

5. Optimize product profitability
   - Review high-revenue but low/negative-profit products.
   - Reassess pricing, costs and discount levels.
   - Promote products with strong demand and healthy margins.
*/


-- =====================================================
-- END OF SQL ANALYSIS
-- =====================================================