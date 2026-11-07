-- 09 — Revenue share per category (CTE + cross-join to grand total).
-- The pattern to learn: compute the grand total once in a CTE,
-- then join it (one row, no key) to every category row so each
-- share divides by the same denominator. Unrounded shares sum to
-- exactly 100%; the 2-decimal display rounds to 100.01%.
WITH category_revenue AS (
    SELECT p.category,
           SUM(oi.quantity * oi.unit_price_at_sale) AS revenue
    FROM order_items AS oi
    JOIN products AS p ON p.product_id = oi.product_id
    GROUP BY p.category
),
grand AS (
    SELECT SUM(revenue) AS total FROM category_revenue
)
SELECT cr.category, cr.revenue AS revenue_pkr,
       ROUND(100.0 * cr.revenue / g.total, 2) AS share_pct
FROM category_revenue AS cr
CROSS JOIN grand AS g
ORDER BY cr.revenue DESC;
