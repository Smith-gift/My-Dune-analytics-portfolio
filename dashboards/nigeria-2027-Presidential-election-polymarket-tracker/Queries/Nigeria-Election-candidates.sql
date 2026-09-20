-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Nigerians involvement with presidential election prediction market 
-- ===========================

SELECT DISTINCT
  question AS candidate
FROM polymarket_polygon.market_details
WHERE event_market_name = 'Nigerian Presidential Election Winner'
  AND NOT regexp_like(question, 'Candidate [A-Z] win')
  AND question NOT LIKE '%Other%'
  AND token_outcome = 'Yes'

-- this code pulls the election candidates from poly market smart contract
