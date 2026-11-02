-- 02 — Products never sold (LEFT JOIN anti-join, same pattern as 01).
-- A product with no order_items row is dead stock: still in the
-- catalogue, earning nothing.
SELECT p.product_id, p.name, p.category, p.unit_price
FROM products AS p
LEFT JOIN order_items AS oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL
ORDER BY p.product_id;
