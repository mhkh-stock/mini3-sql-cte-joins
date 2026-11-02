"""Build demo.db and run + verify all 10 Mini #3 queries.

Run:  python3 run_queries.py
Writes: data/demo.db, outputs/*.txt (one per query, headers on).
Asserts (exit 1 on failure):
  - base data: 12 customers, 9 products, 32 orders, 52 lines
  - Q01: 2 never-ordered customers; Q02: 1 never-sold product
  - Q03: monthly revenue sums to 346,800 and Jul 2026 = 0
  - Q05: customer totals sum to 346,800
  - Q06: buckets sum to 12 customers
  - Q08: 7 same-city pairs
  - Q09: category shares sum to 100% (within 0.05 rounding)
"""
import sqlite3
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent
fails = []


def check(name, cond, detail=""):
    print(f"{'PASS' if cond else 'FAIL'}: {name} {detail}")
    if not cond:
        fails.append(name)


def main():
    db = BASE / "data" / "demo.db"
    if db.exists():
        db.unlink()
    con = sqlite3.connect(db)
    con.executescript((BASE / "data" / "schema.sql").read_text())
    con.executescript((BASE / "data" / "seed.sql").read_text())
    con.commit()

    counts = dict(zip(
        ["customers", "products", "orders", "lines"],
        [con.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
         for t in ["customers", "products", "orders", "order_items"]]))
    check("base data counts", counts == {"customers": 12, "products": 9,
                                         "orders": 32, "lines": 52}, str(counts))

    results = {}
    for path in sorted((BASE / "sql").glob("*.sql")):
        cur = con.execute(path.read_text())
        cols = [d[0] for d in cur.description]
        rows = cur.fetchall()
        results[path.stem[:2]] = (cols, rows)
        out = BASE / "outputs" / f"{path.stem[:2]}_{path.stem[3:]}.txt"
        with open(out, "w") as f:
            f.write(" | ".join(cols) + "\n")
            for r in rows:
                f.write(" | ".join(str(v) for v in r) + "\n")
        print(f"ran {path.name}: {len(rows)} rows -> {out.name}")

    check("Q01 never-ordered = 2",
          len(results["01"][1]) == 2, str(results["01"][1]))
    check("Q02 never-sold = 1 (Bluetooth Speaker)",
          len(results["02"][1]) == 1
          and results["02"][1][0][1] == "Bluetooth Speaker")
    q03 = results["03"][1]
    check("Q03 monthly sums to 346800",
          sum(r[1] for r in q03) == 346800, f"({sum(r[1] for r in q03)})")
    check("Q03 Jul 2026 = 0",
          dict((r[0], r[1]) for r in q03).get("2026-07") == 0)
    check("Q05 customer totals sum to 346800",
          sum(r[4] for r in results["05"][1]) == 346800)
    check("Q05 covers all 12 customers", len(results["05"][1]) == 12)
    check("Q06 buckets sum to 12",
          sum(r[1] for r in results["06"][1]) == 12,
          str(results["06"][1]))
    check("Q08 same-city pairs = 7", len(results["08"][1]) == 7)
    shares = sum(r[2] for r in results["09"][1])
    check("Q09 shares sum to ~100", abs(shares - 100.0) <= 0.05, f"({shares})")
    check("Q04 first orders = 10", len(results["04"][1]) == 10)
    check("Q10 biggest orders = 10", len(results["10"][1]) == 10)
    con.close()
    print("\nall checks passed" if not fails else f"\n{len(fails)} failures")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
