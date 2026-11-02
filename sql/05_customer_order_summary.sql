-- 05 — Full customer summary, including never-ordered customers.
-- The pattern to learn: aggregate order lines per order first
-- (one row per order), then per customer, then LEFT JOIN onto
-- customers — so the two never-ordered customers appear with
-- zeros instead of vanishing.
WITH order_totals AS (
    SELECT order_id,
           SUM(quantity * unit_price_at_sale) AS order_total
    FROM order_items
    GROUP BY order_id
),
customer_totals AS (
    SELECT o.customer_id,
           COUNT(o.order_id) AS order_count,
           SUM(ot.order_total) AS total_spent
    FROM orders AS o
    JOIN order_totals AS ot ON ot.order_id = o.order_id
    GROUP BY o.customer_id
)
SELECT c.customer_id, c.name, c.city,
       COALESCE(ct.order_count, 0) AS order_count,
       COALESCE(ct.total_spent, 0) AS total_spent_pkr
FROM customers AS c
LEFT JOIN customer_totals AS ct ON ct.customer_id = c.customer_id
ORDER BY total_spent_pkr DESC;
