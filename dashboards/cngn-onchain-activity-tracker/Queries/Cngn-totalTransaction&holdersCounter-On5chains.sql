-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR: Onchain, blockchain and crypto data analyst
-- PROJECT: Cngn Adoption and Growth Analysis
-- ===========================

WITH evm_transfers AS (
  SELECT 'ethereum' AS chain, evt_tx_hash AS tx_hash, "from", "to", CAST(value AS DOUBLE) AS amt
  FROM erc20_ethereum.evt_Transfer
  WHERE contract_address = 0x17CDB2a01e7a34CbB3DD4b83260B05d0274C8dab

  UNION ALL

  SELECT 'bnb', evt_tx_hash, "from", "to", CAST(value AS DOUBLE)
  FROM erc20_bnb.evt_Transfer
  WHERE contract_address = 0xa8AEA66B361a8d53e8865c62D142167Af28Af058

  UNION ALL

  SELECT 'polygon', evt_tx_hash, "from", "to", CAST(value AS DOUBLE)
  FROM erc20_polygon.evt_Transfer
  WHERE contract_address = 0x52828daa48C1a9A06F37500882b42daf0bE04C3B

  UNION ALL

  SELECT 'base', evt_tx_hash, "from", "to", CAST(value AS DOUBLE)
  FROM erc20_base.evt_Transfer
  WHERE contract_address = 0x46C85152bFe9f96829aA94755D9f915F9B10EF5F
),
evm_transactions AS (
  SELECT chain, COUNT(DISTINCT tx_hash) AS total_transactions
  FROM evm_transfers
  GROUP BY 1
),
evm_moves AS (
  SELECT chain, "to" AS addr, amt FROM evm_transfers
  WHERE "to" != 0x0000000000000000000000000000000000000000
  UNION ALL
  SELECT chain, "from" AS addr, -amt FROM evm_transfers
  WHERE "from" != 0x0000000000000000000000000000000000000000
),
evm_balances AS (
  SELECT chain, addr, SUM(amt) AS balance
  FROM evm_moves
  GROUP BY 1, 2
),
evm_holders AS (
  SELECT chain, COUNT(*) AS current_holders
  FROM evm_balances
  WHERE balance > 0
  GROUP BY 1
),
sol_transactions AS (
  SELECT 'solana' AS chain, COUNT(DISTINCT tx_id) AS total_transactions
  FROM tokens_solana.transfers
  WHERE token_mint_address = '3jiqwBQVRC5zRwHyqvnkQurebJ5RNxg3F5fXMwaxgkv8'
),
sol_moves AS (
  SELECT to_owner AS addr, CAST(amount AS DOUBLE) AS amt
  FROM tokens_solana.transfers
  WHERE token_mint_address = '3jiqwBQVRC5zRwHyqvnkQurebJ5RNxg3F5fXMwaxgkv8'
    AND to_owner IS NOT NULL
  UNION ALL
  SELECT from_owner, -CAST(amount AS DOUBLE)
  FROM tokens_solana.transfers
  WHERE token_mint_address = '3jiqwBQVRC5zRwHyqvnkQurebJ5RNxg3F5fXMwaxgkv8'
    AND from_owner IS NOT NULL
),
sol_balances AS (
  SELECT addr, SUM(amt) AS balance
  FROM sol_moves
  GROUP BY 1
),
sol_holders AS (
  SELECT 'solana' AS chain, COUNT(*) AS current_holders
  FROM sol_balances
  WHERE balance > 0
  GROUP BY 1
)
SELECT
  t.chain,
  t.total_transactions,
  h.current_holders
FROM evm_transactions t
JOIN evm_holders h ON t.chain = h.chain

UNION ALL

SELECT
  st.chain,
  st.total_transactions,
  sh.current_holders
FROM sol_transactions st
JOIN sol_holders sh ON st.chain = sh.chain

ORDER BY chain

-- This fecthes all Transactions on all 5 chains and all holders
