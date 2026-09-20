-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Cngn Adoption and Growth Analysis
-- ===========================
SELECT
  blockchain,
  block_date AS day,
  SUM(amount) AS volume,
  SUM(amount_usd) AS volume_usd,
  COUNT(*) AS transfer_count
FROM tokens.transfers
WHERE contract_address IN (
    0xa8AEA66B361a8d53e8865c62D142167Af28Af058, -- cNGN on BNB Chain
    0x17CDB2a01e7a34CbB3DD4b83260B05d0274C8dab  -- cNGN on Ethereum
  )
GROUP BY 1, 2
ORDER BY 2, 1

-- The query fetches cngn daily volume on ethereum and binance smart chain
