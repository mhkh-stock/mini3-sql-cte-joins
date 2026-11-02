-- 03 — Monthly revenue, including months with zero sales.
-- The pattern to learn: build a months "spine" in a CTE first,
-- then LEFT JOIN the real revenue onto it. Grouping the orders
-- table alone can never show July, because July has no rows.
WITH months(month) AS (
    VALUES ('2026-01'), ('2026-02'), ('2026-03'), ('2026-04'),
           ('2026-05'), ('2026-06'), ('2026-07')
),
monthly AS (
    SELECT substr(o.order_date, 1, 7) AS month,
           SUM(oi.quantity * oi.unit_price_at_sale) AS revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    GROUP BY month
)
SELECT m.month,
       COALESCE(mo.revenue, 0) AS revenue_pkr
FROM months AS m
LEFT JOIN monthly AS mo ON mo.month = m.month
ORDER BY m.month;
