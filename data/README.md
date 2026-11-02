# Mini #3 — data dictionary (SAMPLE / DEMO only)

Same shop as Mini #1, plus 2 never-ordered customers and 1
never-sold product so the joins pack has real anti-join results.

## customers (12 rows)
- `customer_id` — PK, 1–12
- `name` — fictional person
- `city` — Lahore, Karachi, Islamabad, Faisalabad, Multan,
  Peshawar (11, never ordered), Quetta (12, never ordered)
- `signup_date` — ISO date

## products (9 rows)
- `product_id` — PK, 1–9
- `name`, `category` — Electronics / Furniture / Stationery / Kitchen
- `unit_price` — PKR list price; product 9 (Bluetooth Speaker,
  6,500) never appears in order_items

## orders (32 rows)
- `order_id` — PK, 1–32; `customer_id` → customers
- `order_date` — ISO date, Jan–Jun 2026 (no Jul 2026 orders —
  query 03's spine supplies that month)

## order_items (52 rows)
- `order_item_id` — PK; `order_id` → orders;
  `product_id` → products
- `quantity`, `unit_price_at_sale` — PKR actually charged
  (may differ from list price; totals use the sale price)

## Totals (verified)
- 32 orders, 52 lines, PKR 346,800 — same as Mini #1.
