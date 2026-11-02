-- 10 — Each customer's biggest single order (CTE + join back).
-- Same shape as 04, different aggregate: MAX order total per
-- customer, joined back to fetch the order that produced it.
WITH order_totals AS (
    SELECT order_id,
           SUM(quantity * unit_price_at_sale) AS order_total
    FROM order_items
    GROUP BY order_id
),
max_orders AS (
    SELECT o.customer_id, MAX(ot.order_total) AS max_total
    FROM orders AS o
    JOIN order_totals AS ot ON ot.order_id = o.order_id
    GROUP BY o.customer_id
)
SELECT c.name, o.order_id, o.order_date, ot.order_total AS biggest_order_pkr
FROM max_orders AS mo
JOIN orders AS o ON o.customer_id = mo.customer_id
JOIN order_totals AS ot ON ot.order_id = o.order_id
                         AND ot.order_total = mo.max_total
JOIN customers AS c ON c.customer_id = mo.customer_id
ORDER BY biggest_order_pkr DESC;
