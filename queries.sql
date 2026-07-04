-- Customer Orders BI Analysis
-- Цель: анализ клиентов, заказов, оплат и ключевых бизнес-метрик


-- 1. Просмотр клиентов

SELECT *
FROM customers;


-- 2. Просмотр заказов

SELECT *
FROM orders;


-- 3. Объединение клиентов и заказов

SELECT
    customers.customer_id,
    customers.customer_name,
    customers.city,
    customers.registration_date,
    orders.order_id,
    orders.order_date,
    orders.amount,
    orders.status
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id;


-- 4. Основные показатели по каждому клиенту

SELECT
    customers.customer_id,
    customers.customer_name,
    customers.city,
    COUNT(orders.order_id) AS orders_count,
    COUNT(CASE WHEN orders.status = 'paid' THEN orders.order_id END) AS paid_orders_count,
    COALESCE(SUM(CASE WHEN orders.status = 'paid' THEN orders.amount END), 0) AS total_revenue,
    COALESCE(AVG(CASE WHEN orders.status = 'paid' THEN orders.amount END), 0) AS average_order_value
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
GROUP BY
    customers.customer_id,
    customers.customer_name,
    customers.city
ORDER BY total_revenue DESC;


-- 5. Выручка по городам

SELECT
    customers.city,
    COUNT(DISTINCT customers.customer_id) AS customers_count,
    COUNT(orders.order_id) AS orders_count,
    COUNT(CASE WHEN orders.status = 'paid' THEN orders.order_id END) AS paid_orders_count,
    COALESCE(SUM(CASE WHEN orders.status = 'paid' THEN orders.amount END), 0) AS total_revenue,
    COALESCE(AVG(CASE WHEN orders.status = 'paid' THEN orders.amount END), 0) AS average_order_value
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
GROUP BY customers.city
ORDER BY total_revenue DESC;


-- 6. Доля оплаченных заказов по городам

SELECT
    customers.city,
    COUNT(orders.order_id) AS orders_count,
    COUNT(CASE WHEN orders.status = 'paid' THEN orders.order_id END) AS paid_orders_count,
    ROUND(
        COUNT(CASE WHEN orders.status = 'paid' THEN orders.order_id END) * 100.0
        / NULLIF(COUNT(orders.order_id), 0),
        2
    ) AS payment_conversion_rate
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
GROUP BY customers.city
ORDER BY payment_conversion_rate DESC;


-- 7. Сегментация заказов по размеру оплаты

SELECT
    order_id,
    customer_id,
    order_date,
    amount,
    status,
    CASE
        WHEN amount >= 1000 THEN 'high'
        WHEN amount >= 500 THEN 'medium'
        ELSE 'low'
    END AS order_segment
FROM orders;


-- 8. Анализ заказов по сегментам

SELECT
    CASE
        WHEN amount >= 1000 THEN 'high'
        WHEN amount >= 500 THEN 'medium'
        ELSE 'low'
    END AS order_segment,
    COUNT(order_id) AS orders_count,
    COUNT(CASE WHEN status = 'paid' THEN order_id END) AS paid_orders_count,
    COALESCE(SUM(CASE WHEN status = 'paid' THEN amount END), 0) AS total_revenue,
    COALESCE(AVG(CASE WHEN status = 'paid' THEN amount END), 0) AS average_order_value
FROM orders
GROUP BY
    CASE
        WHEN amount >= 1000 THEN 'high'
        WHEN amount >= 500 THEN 'medium'
        ELSE 'low'
    END
ORDER BY total_revenue DESC;


-- 9. Активные клиенты

SELECT
    customers.customer_id,
    customers.customer_name,
    customers.city,
    COUNT(orders.order_id) AS orders_count,
    COALESCE(SUM(CASE WHEN orders.status = 'paid' THEN orders.amount END), 0) AS total_revenue
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
GROUP BY
    customers.customer_id,
    customers.customer_name,
    customers.city
HAVING COUNT(orders.order_id) >= 2
ORDER BY total_revenue DESC;


-- 10. Клиенты без заказов

SELECT
    customers.customer_id,
    customers.customer_name,
    customers.city
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
WHERE orders.order_id IS NULL;


-- 11. Итоговая таблица для BI-отчёта

SELECT
    customers.city,
    CASE
        WHEN orders.amount >= 1000 THEN 'high'
        WHEN orders.amount >= 500 THEN 'medium'
        ELSE 'low'
    END AS order_segment,
    COUNT(orders.order_id) AS orders_count,
    COUNT(CASE WHEN orders.status = 'paid' THEN orders.order_id END) AS paid_orders_count,
    COALESCE(SUM(CASE WHEN orders.status = 'paid' THEN orders.amount END), 0) AS total_revenue,
    COALESCE(AVG(CASE WHEN orders.status = 'paid' THEN orders.amount END), 0) AS average_order_value
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
GROUP BY
    customers.city,
    CASE
        WHEN orders.amount >= 1000 THEN 'high'
        WHEN orders.amount >= 500 THEN 'medium'
        ELSE 'low'
    END
ORDER BY
    customers.city,
    total_revenue DESC;
