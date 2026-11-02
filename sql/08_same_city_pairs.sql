-- 08 — Customer pairs in the same city (self-join).
-- The pattern to learn: join a table to itself with two aliases,
-- and use a.customer_id < b.customer_id so each pair appears
-- once (A,B) and never (B,A) or (A,A).
SELECT a.name AS customer_a, b.name AS customer_b, a.city
FROM customers AS a
JOIN customers AS b
  ON b.city = a.city AND b.customer_id > a.customer_id
ORDER BY a.city, a.name;
