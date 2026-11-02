-- 06 — Customers by order-count bucket (CTE + spine, same idea as 03).
-- Buckets: 0 orders / 1 order / 2–3 orders / 4+ orders. The spine
-- keeps the "1 order" bucket visible even though nobody falls in
-- it — a report that hides empty buckets misleads.
WITH buckets(bucket, sort_key) AS (
    VALUES ('0 orders', 0), ('1 order', 1),
           ('2-3 orders', 2), ('4+ orders', 3)
),
counts AS (
    SELECT customer_id, COUNT(*) AS n_orders
    FROM orders
    GROUP BY customer_id
),
bucketed AS (
    SELECT CASE
               WHEN c.n_orders IS NULL THEN '0 orders'
               WHEN c.n_orders = 1 THEN '1 order'
               WHEN c.n_orders <= 3 THEN '2-3 orders'
               ELSE '4+ orders'
           END AS bucket
    FROM customers AS cu
    LEFT JOIN counts AS c ON c.customer_id = cu.customer_id
)
SELECT b.bucket, COUNT(x.bucket) AS customers
FROM buckets AS b
LEFT JOIN bucketed AS x ON x.bucket = b.bucket
GROUP BY b.bucket, b.sort_key
ORDER BY b.sort_key;
