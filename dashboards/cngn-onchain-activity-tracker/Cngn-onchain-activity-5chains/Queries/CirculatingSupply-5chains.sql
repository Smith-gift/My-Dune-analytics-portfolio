-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Cngn Adoption and Growth Analysis
-- ===========================
WITH evm_moves AS (
  SELECT 'ethereum' AS chain, CAST(value AS DOUBLE)/1e6 AS amt,
    "from" = 0x0000000000000000000000000000000000000000 AS is_mint,
    "to" = 0x0000000000000000000000000000000000000000 AS is_burn
  FROM erc20_ethereum.evt_Transfer
  WHERE contract_address = 0x17CDB2a01e7a34CbB3DD4b83260B05d0274C8dab
    AND ("from" = 0x0000000000000000000000000000000000000000
         OR "to" = 0x0000000000000000000000000000000000000000)

  UNION ALL

  SELECT 'bnb', CAST(value AS DOUBLE)/1e6,
    "from" = 0x0000000000000000000000000000000000000000,
    "to" = 0x0000000000000000000000000000000000000000
  FROM erc20_bnb.evt_Transfer
  WHERE contract_address = 0xa8AEA66B361a8d53e8865c62D142167Af28Af058
    AND ("from" = 0x0000000000000000000000000000000000000000
         OR "to" = 0x0000000000000000000000000000000000000000)

  UNION ALL

  SELECT 'polygon', CAST(value AS DOUBLE)/1e6,
    "from" = 0x0000000000000000000000000000000000000000,
    "to" = 0x0000000000000000000000000000000000000000
  FROM erc20_polygon.evt_Transfer
  WHERE contract_address = 0x52828daa48C1a9A06F37500882b42daf0bE04C3B
    AND ("from" = 0x0000000000000000000000000000000000000000
         OR "to" = 0x0000000000000000000000000000000000000000)

  UNION ALL

  SELECT 'base', CAST(value AS DOUBLE)/1e6,
    "from" = 0x0000000000000000000000000000000000000000,
    "to" = 0x0000000000000000000000000000000000000000
  FROM erc20_base.evt_Transfer
  WHERE contract_address = 0x46C85152bFe9f96829aA94755D9f915F9B10EF5F
    AND ("from" = 0x0000000000000000000000000000000000000000
         OR "to" = 0x0000000000000000000000000000000000000000)
),
evm_supply AS (
  SELECT
    chain,
    SUM(CASE WHEN is_mint THEN amt ELSE 0 END)
      - SUM(CASE WHEN is_burn THEN amt ELSE 0 END) AS circulating_supply
  FROM evm_moves
  GROUP BY 1
),
sol_supply AS (
  SELECT
    'solana' AS chain,
    SUM(CASE WHEN from_owner IS NULL THEN CAST(amount AS DOUBLE)/1e6 ELSE 0 END)
      - SUM(CASE WHEN to_owner IS NULL THEN CAST(amount AS DOUBLE)/1e6 ELSE 0 END) AS circulating_supply
  FROM tokens_solana.transfers
  WHERE token_mint_address = '3jiqwBQVRC5zRwHyqvnkQurebJ5RNxg3F5fXMwaxgkv8'
)
SELECT * FROM evm_supply
UNION ALL
SELECT * FROM sol_supply
ORDER BY chain

-- This query will fetch the cngn current circulating supply on solana, ethereum, binance smart chain, polygon and base blockchain
