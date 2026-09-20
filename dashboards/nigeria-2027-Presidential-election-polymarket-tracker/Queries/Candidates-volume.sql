-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Nigerians involvement with presidential election prediction market 
-- ===========================


SELECT
  regexp_extract(m.question, 'Will (.*?) win') AS candidate,
  SUM(t.amount) AS volume_usd
FROM polymarket_polygon.market_trades t
JOIN polymarket_polygon.market_details m
  ON CAST(t.condition_id AS VARCHAR) = CAST(m.condition_id AS VARCHAR)
WHERE m.event_market_name = 'Nigerian Presidential Election Winner'
  AND NOT regexp_like(m.question, 'Candidate [A-Z] win')
  AND m.question NOT LIKE '%Other%'
GROUP BY 1
ORDER BY 2 DESC

-- this code pulls the individual candidates trading volume by users betting
