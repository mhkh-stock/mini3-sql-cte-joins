-- 01 — Customers who never ordered (LEFT JOIN anti-join).
-- The pattern to learn: LEFT JOIN keeps every customer, and
-- IS NULL keeps only the ones with no matching order. An INNER
-- JOIN here would silently drop exactly the people you want.
SELECT c.customer_id, c.name, c.city, c.signup_date
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;
