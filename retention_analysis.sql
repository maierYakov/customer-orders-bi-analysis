-- Retention Analysis
-- Анализ повторных покупок клиентов

WITH paid_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS order_number
    FROM orders
    WHERE status = 'paid'
),

customer_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_paid_order_date,
        MAX(order_date) AS last_paid_order_date,
        COUNT(order_id) AS paid_orders_count,
        SUM(amount) AS total_revenue,
        AVG(amount) AS average_order_value
    FROM paid_orders
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    co.first_paid_order_date,
    co.last_paid_order_date,
    COALESCE(co.paid_orders_count, 0) AS paid_orders_count,
    COALESCE(co.total_revenue, 0) AS total_revenue,
    COALESCE(co.average_order_value, 0) AS average_order_value,
    CASE
        WHEN co.paid_orders_count IS NULL THEN 'no_paid_orders'
        WHEN co.paid_orders_count = 1 THEN 'one_time_customer'
        WHEN co.paid_orders_count >= 2 THEN 'repeat_customer'
    END AS retention_segment
FROM customers c
LEFT JOIN customer_orders co
    ON c.customer_id = co.customer_id
ORDER BY total_revenue DESC;
