-- 04 — Each customer's first order (CTE + join back).
-- The pattern to learn: aggregate in a CTE (MIN date per
-- customer), then join back to the orders table to fetch the
-- full row that produced the aggregate. MIN alone can't give you
-- the order_id.
WITH first_dates AS (
    SELECT customer_id, MIN(order_date) AS first_date
    FROM orders
    GROUP BY customer_id
)
SELECT c.name, o.order_id, o.order_date AS first_order_date
FROM first_dates AS f
JOIN orders AS o
  ON o.customer_id = f.customer_id AND o.order_date = f.first_date
JOIN customers AS c ON c.customer_id = f.customer_id
ORDER BY o.order_date;
