-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Cngn Adoption and Growth Analysis
-- ===========================
SELECT
  blockchain,
  date_trunc('year', block_time) AS year,
  SUM(amount) AS volume,
  SUM(amount_usd) AS volume_usd,
  COUNT(*) AS transfer_count
FROM tokens.transfers
WHERE contract_address IN (
    0xa8AEA66B361a8d53e8865c62D142167Af28Af058,
    0x17CDB2a01e7a34CbB3DD4b83260B05d0274C8dab
  )
GROUP BY 1, 2
ORDER BY 2, 1

-- code will fetch all yearly volume/transactions on both Ethereum and binance smart chain
