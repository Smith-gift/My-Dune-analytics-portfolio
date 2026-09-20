-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Nigerians involvement with presidential election prediction market 
-- ===========================

SELECT
  COUNT(DISTINCT trader) AS unique_participants
FROM (
  SELECT t.maker AS trader
  FROM polymarket_polygon.market_trades t
  JOIN polymarket_polygon.market_details m
    ON CAST(t.condition_id AS VARCHAR) = CAST(m.condition_id AS VARCHAR)
  WHERE m.event_market_name = 'Nigerian Presidential Election Winner'
  UNION
  SELECT t.taker AS trader
  FROM polymarket_polygon.market_trades t
  JOIN polymarket_polygon.market_details m
    ON CAST(t.condition_id AS VARCHAR) = CAST(m.condition_id AS VARCHAR)
  WHERE m.event_market_name = 'Nigerian Presidential Election Winner'
)


-- this code shows the unique participants on the prediction pool

