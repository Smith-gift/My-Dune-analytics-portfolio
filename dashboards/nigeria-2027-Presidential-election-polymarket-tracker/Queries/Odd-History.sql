-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Nigerians involvement with presidential election prediction market 
-- ===========================

SELECT
  h.hour,
  m.question AS candidate,
  h.price * 100 AS implied_probability_pct
FROM polymarket_polygon.market_prices_hourly h
JOIN polymarket_polygon.market_details m
  ON CAST(h.condition_id AS VARCHAR) = CAST(m.condition_id AS VARCHAR)
  AND CAST(h.token_id AS VARCHAR) = CAST(m.token_id AS VARCHAR)
WHERE m.event_market_name = 'Nigerian Presidential Election Winner'
  AND NOT regexp_like(m.question, 'Candidate [A-Z] win')
  AND m.question NOT LIKE '%Other%'
  AND m.token_outcome = 'Yes'
  AND h.hour >= NOW() - INTERVAL '90' DAY
ORDER BY h.hour


-- this code pulls the odds history of each candidate from the smart contract
