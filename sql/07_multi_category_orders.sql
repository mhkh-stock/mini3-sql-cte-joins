-- 07 — Orders spanning more than one category (CTE + HAVING + join).
-- A basket that mixes categories is a cross-sell that already
-- happened — the shop's best bundling evidence.
WITH order_categories AS (
    SELECT oi.order_id,
           COUNT(DISTINCT p.category) AS category_count
    FROM order_items AS oi
    JOIN products AS p ON p.product_id = oi.product_id
    GROUP BY oi.order_id
    HAVING COUNT(DISTINCT p.category) > 1
)
SELECT o.order_id, c.name AS customer, o.order_date,
       oc.category_count
FROM order_categories AS oc
JOIN orders AS o ON o.order_id = oc.order_id
JOIN customers AS c ON c.customer_id = o.customer_id
ORDER BY o.order_id;
