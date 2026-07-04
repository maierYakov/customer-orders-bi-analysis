-- RFM Analysis
-- Анализ клиентов по давности покупки, частоте заказов и сумме оплат

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        MAX(o.order_date) AS last_order_date,
        COUNT(CASE WHEN o.status = 'paid' THEN o.order_id END) AS frequency,
        COALESCE(SUM(CASE WHEN o.status = 'paid' THEN o.amount END), 0) AS monetary
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.city
),

rfm_base AS (
    SELECT
        customer_id,
        customer_name,
        city,
        last_order_date,
        frequency,
        monetary,
        DATE '2026-06-01' - last_order_date AS recency_days
    FROM customer_metrics
),

rfm_segments AS (
    SELECT
        customer_id,
        customer_name,
        city,
        recency_days,
        frequency,
        monetary,
        CASE
            WHEN recency_days <= 30 THEN 3
            WHEN recency_days <= 60 THEN 2
            ELSE 1
        END AS recency_score,
        CASE
            WHEN frequency >= 3 THEN 3
            WHEN frequency = 2 THEN 2
            ELSE 1
        END AS frequency_score,
        CASE
            WHEN monetary >= 2000 THEN 3
            WHEN monetary >= 1000 THEN 2
            ELSE 1
        END AS monetary_score
    FROM rfm_base
)

SELECT
    customer_id,
    customer_name,
    city,
    recency_days,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    CASE
        WHEN recency_score = 3 AND frequency_score = 3 AND monetary_score = 3 THEN 'best_customers'
        WHEN monetary_score = 3 AND frequency_score >= 2 THEN 'high_value_customers'
        WHEN recency_score = 3 AND frequency_score = 1 THEN 'new_customers'
        WHEN recency_score = 1 AND frequency_score >= 2 THEN 'at_risk_customers'
        WHEN frequency_score >= 2 THEN 'loyal_customers'
        ELSE 'regular_customers'
    END AS customer_segment
FROM rfm_segments
ORDER BY monetary DESC;
