-- IPL Player Auction & Team Spending Analysis (2013-2022)
-- Dataset: 969 auction records | Columns: player, role, amount, team, year, origin

-- ============================================================
-- 1. Total spend per team, per season (year-over-year budget trend)
-- ============================================================
SELECT
    team,
    year,
    COUNT(*) AS players_bought,
    SUM(amount) AS total_spend,
    ROUND(AVG(amount), 0) AS avg_price_per_player
FROM auctions
GROUP BY team, year
ORDER BY team, year;

-- ============================================================
-- 2. Career auction spend per team (all seasons combined) -- ranks franchises by total investment
-- ============================================================
SELECT
    team,
    COUNT(*) AS total_purchases,
    SUM(amount) AS total_spend,
    ROUND(AVG(amount), 0) AS avg_price,
    MAX(amount) AS highest_single_buy
FROM auctions
GROUP BY team
ORDER BY total_spend DESC;

-- ============================================================
-- 3. Role-wise budget allocation per team -- window function to get each role's
--    share of a team's total spend (used to spot roster imbalance, e.g. overspending on Batsmen vs Bowlers)
-- ============================================================
SELECT
    team,
    role,
    SUM(amount) AS role_spend,
    ROUND(
        100.0 * SUM(amount) / SUM(SUM(amount)) OVER (PARTITION BY team),
        1
    ) AS pct_of_team_budget
FROM auctions
GROUP BY team, role
ORDER BY team, role_spend DESC;

-- ============================================================
-- 4. Top 10 most expensive single-season buys -- highlights marquee/"star" purchases
-- ============================================================
SELECT player, team, year, role, amount
FROM auctions
ORDER BY amount DESC
LIMIT 10;

-- ============================================================
-- 5. Repeat-auction players -- players bought in 3+ different seasons, with price trajectory
--    (subquery + window function to compute price change season to season)
-- ============================================================
SELECT
    player,
    year,
    team,
    amount,
    amount - LAG(amount) OVER (PARTITION BY player ORDER BY year) AS price_change_vs_prev_sale
FROM auctions
WHERE player IN (
    SELECT player FROM auctions GROUP BY player HAVING COUNT(DISTINCT year) >= 3
)
ORDER BY player, year;

-- ============================================================
-- 6. Indian vs Overseas spend split, per team
-- ============================================================
SELECT
    team,
    origin,
    COUNT(*) AS players_bought,
    SUM(amount) AS total_spend,
    ROUND(100.0 * SUM(amount) / SUM(SUM(amount)) OVER (PARTITION BY team), 1) AS pct_of_team_budget
FROM auctions
GROUP BY team, origin
ORDER BY team, origin;

-- ============================================================
-- 7. Franchises with the most volatile spend across seasons
--    (highest standard-deviation-style range between max and min season spend)
-- ============================================================
SELECT
    team,
    MAX(season_spend) AS peak_season_spend,
    MIN(season_spend) AS lowest_season_spend,
    MAX(season_spend) - MIN(season_spend) AS spend_swing
FROM (
    SELECT team, year, SUM(amount) AS season_spend
    FROM auctions
    GROUP BY team, year
)
GROUP BY team
ORDER BY spend_swing DESC;

-- ============================================================
-- 8. Year-over-year league-wide inflation in average auction price
-- ============================================================
SELECT
    year,
    COUNT(*) AS total_players_sold,
    SUM(amount) AS total_league_spend,
    ROUND(AVG(amount), 0) AS avg_price
FROM auctions
GROUP BY year
ORDER BY year;
