-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Nigerians involvement with presidential election prediction market 
-- ===========================

SELECT
  m.question AS candidate,
  p.latest_price * 100 AS implied_probability_pct
FROM polymarket_polygon.market_prices_latest p
JOIN polymarket_polygon.market_details m
  ON CAST(p.condition_id AS VARCHAR) = CAST(m.condition_id AS VARCHAR)
  AND CAST(p.token_id AS VARCHAR) = CAST(m.token_id AS VARCHAR)
WHERE m.event_market_name = 'Nigerian Presidential Election Winner'
  AND NOT regexp_like(m.question, 'Candidate [A-Z] win')
  AND m.question NOT LIKE '%Other%'
  AND m.token_outcome = 'Yes'
ORDER BY implied_probability_pct DESC


-- this code shows the live odds probability of each candidate
