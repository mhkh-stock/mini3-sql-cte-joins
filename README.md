# Mini #3 — SQL CTEs & Joins Pack

**SAMPLE / DEMO data only.** Fictional shop, fictional people, fictional orders.
Never claimed as real client or real business data.

The other half of the entry-level SQL test, after Mini #1's window
functions: CTEs, `INNER` / `LEFT` joins, anti-joins, self-joins, and
the "aggregate before you join" discipline. One business question
per file, one pattern named per file.

## Demo dataset

Same shop as Mini #1, extended for joins: 12 customers (2 never
ordered) · 9 products (1 never sold) · 32 orders · 52 order lines ·
Jan–Jun 2026, plus a zero-sales Jul 2026 in query 03's spine ·
PKR 346,800 total revenue — identical to Mini #1's verified total,
so the two packs reconcile with each other.
Schema: `data/schema.sql` · Seed: `data/seed.sql` · Dictionary:
`data/README.md` · Built database: `data/demo.db` (rebuild any time
with `python3 run_queries.py`, which also verifies every query).

## How to run (3 steps)

1. `cd mini3-sql-cte-joins`
2. `python3 run_queries.py` — builds `data/demo.db`, runs all 10
   queries, writes `outputs/*.txt`, and asserts the checks below
3. Run any query by hand, e.g.
   `sqlite3 -header -column data/demo.db < sql/01_customers_never_ordered.sql`

Requires Python 3 + SQLite (standard library only). Verified on
SQLite 3.45.1.

## Queries

| File | Business question | Teaches | Verified output |
|---|---|---|---|
| `sql/01_customers_never_ordered.sql` | Who signed up but never bought? | LEFT JOIN anti-join (`IS NULL`) | 2 rows: Hira Shah (Peshawar), Danish Iqbal (Quetta) |
| `sql/02_products_never_sold.sql` | Which catalogue items earn nothing? | Same anti-join, other side | 1 row: Bluetooth Speaker |
| `sql/03_monthly_revenue_with_zero_months.sql` | What did each month earn, including dead months? | Months "spine" CTE + LEFT JOIN | 7 rows; Jul 2026 = 0; months sum to 346,800 |
| `sql/04_first_order_per_customer.sql` | What was each customer's first order? | Aggregate in CTE, join back for the full row | 10 rows, one per ordering customer |
| `sql/05_customer_order_summary.sql` | How much has each customer spent in total? | Aggregate before joining; LEFT JOIN keeps zero-spenders | 12 rows; #1 Ayesha Khan PKR 56,700; sum 346,800 |
| `sql/06_customers_by_order_bucket.sql` | How many customers are one-time, repeat, loyal? | Bucket CTE + spine (empty buckets stay visible) | 0 orders: 2, 1 order: 0, 2–3 orders: 7, 4+ orders: 3 |
| `sql/07_multi_category_orders.sql` | Which baskets mix categories? | CTE + `HAVING COUNT(DISTINCT …) > 1` | 15 orders |
| `sql/08_same_city_pairs.sql` | Which customers share a city? | Self-join with `a.id < b.id` (no duplicates, no self-pairs) | 7 pairs |
| `sql/09_category_revenue_share.sql` | What share of revenue is each category? | CTE grand total + CROSS JOIN | 4 rows; Kitchen 30.57%, Furniture 30.45%, Electronics 29.99%, Stationery 9.00%; rounded shares sum to 100.01% |
| `sql/10_biggest_order_per_customer.sql` | What was each customer's biggest single order? | MAX in CTE, join back for the order | 10 rows; biggest: Usman Tariq, order 11, PKR 20,400 |

## Verification (done before delivery)

- All 10 files execute against `data/demo.db` with no errors
  (one real bug found and fixed during verification: query 06 used
  `COUNT(*)` on a LEFT JOIN, which counted the NULL row and showed
  the empty "1 order" bucket as 1 — fixed to `COUNT(x.bucket)`,
  buckets now sum to exactly 12).
- Reconciliation: total revenue 346,800 = monthly sum 346,800 =
  customer sum 346,800 = Mini #1's verified total.
- Query 05 agrees with Mini #1 query 06 on every customer total
  and on the #1 customer.
- Verified outputs are saved in `outputs/` (one `.txt` per query);
  `run_queries.py` re-asserts all of the above on every run.
  (Query 09's rounded shares sum to 100.01%, not exactly 100% —
  rounding only; the check allows ±0.05.)

## Limits

- SAMPLE / DEMO data only — fictional shop, Jan–Jun 2026 plus a
  zero-sales Jul 2026 supplied by query 03's spine, SQLite only.
- Queries 04 and 10 join an aggregate back to its source rows with
  no tie-breaker: this data has no ties (no customer has two orders
  on the same earliest date, or two orders with the same biggest
  total), so each returns exactly 10 rows — but on tied data the
  join-back would return both tied rows.
- Query 06's "1 order" bucket is empty in this data (0 customers);
  the spine keeps it visible on purpose, so the report shows the
  gap instead of hiding it.
- Query 09's per-category shares are rounded to 2 decimals, so the
  displayed shares sum to 100.01%; the unrounded shares sum to
  exactly 100%.

## Note for the publisher

No GitHub repo was created and nothing was pushed, per the task —
the GitHub App cannot create repos, so this mini stays built
locally, verified and ready until its repo exists.
