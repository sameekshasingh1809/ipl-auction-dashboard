# IPL Auction & Team Performance Dashboard

An interactive dashboard analyzing 10 years of IPL player auctions (2013–2022) — built to answer a simple question: **how do franchises actually spend, and where does the money go?**

---

## What it does

- **Franchise spend** — total auction investment per team across 10 seasons
- **Role budget allocation** — how each franchise splits spend across Batsmen, Bowlers, All-Rounders, and Wicket-Keepers
- **Season-over-season inflation** — league-wide average price trend, 2013–2022
- **Marquee buys** — the 10 most expensive single-season purchases
- **Player auction history** — search any player to see their price trajectory across seasons and franchises
- **Biggest movers** — the largest price jumps and drops for players re-entering the auction
- **Team spending DNA** — radar comparison of role-allocation strategy between any two franchises
- **Spend-rank heatmap** — each franchise's spending rank by season, at a glance
- **Indian vs. overseas price inflation** — average price trend split by player origin

All charts are filterable by **season**, **franchise**, and **role**.

---

## Dataset

- **969 player-auction records**, 2013–2022
- **15 franchises** (including rebranded lineages, e.g. Delhi Daredevils → Delhi Capitals)
- **Columns:** player, role, amount, team, year, origin (Indian/Overseas)
- Source: [IPL Player Auction Dataset](https://www.kaggle.com/datasets/kalilurrahman/ipl-player-auction-dataset-from-start-to-now), Kaggle

**Scope note:** this dataset covers only players who went under the hammer at auction. Franchise retentions — players kept season after season without re-entering the auction (e.g. MS Dhoni, Virat Kohli, Ravindra Jadeja) — aren't recorded here, so they don't appear in any of the analysis. The dashboard flags this directly where relevant (e.g. the player search).

---

## Tech stack

- **SQL** (SQLite) — see [`analysis.sql`](./analysis.sql) for the full query set
- **JavaScript + Chart.js** — client-side filtering and interactive charts
- **HTML/CSS** — no framework, single-file dashboard

## SQL techniques used

The analysis in `analysis.sql` covers:
- Aggregations and `GROUP BY` across team/season/role
- **Window functions** — `LAG()` for season-over-season price change, `SUM() OVER (PARTITION BY ...)` for each role's share of a team's total budget
- **Subqueries** — both `WHERE ... IN (SELECT ...)` and derived-table patterns to isolate repeat-auction players and spend volatility

---

## Key findings

- **Royal Challengers Bangalore** and **Sunrisers Hyderabad** lead total auction spend across the decade (₹271 Cr and ₹231 Cr respectively)
- **All-rounders** command the highest average price of any role — franchises consistently pay a premium for players who solve two problems at once
- **Harshal Patel's** 2018→2022 re-auction jump (₹20L → ₹10.75 Cr, +5,275%) is the single biggest price swing in the dataset
- **Jaydev Unadkat** has been bought by 6 different franchises — the most of any player in the dataset
- Overseas players are fewer in number but consistently priced higher per player than Indian players

---

## Running it locally

This is a single self-contained HTML file — no build step, no dependencies to install.

```bash
git clone https://github.com/sameekshasingh1809/ipl-auction-dashboard.git
cd ipl-auction-dashboard
open index.html   # or just double-click the file
```

To explore the SQL directly:
```bash
sqlite3 ipl.db < analysis.sql
```

---

## Author

**Sameeksha Singh** — B.Tech CSE, Graphic Era Deemed University
[LinkedIn](https://linkedin.com/in/sameekshasingh) · sameekshasingh1809@gmail.com
