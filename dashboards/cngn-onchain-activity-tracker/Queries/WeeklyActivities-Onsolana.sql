-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Cngn Adoption and Growth Analysis
-- ===========================

SELECT
    CAST(date_trunc('week', block_time) AS date) AS week,
    'solana' AS chain,
    COUNT(DISTINCT tx_id) AS transactions,
    COUNT(*) AS transfers,
    SUM(CAST(amount AS double)/1e6) AS volume,
    COUNT(DISTINCT from_owner) + COUNT(DISTINCT to_owner)
      - COUNT(DISTINCT CASE WHEN from_owner = to_owner THEN from_owner END) AS unique_addresses
FROM tokens_solana.transfers
WHERE token_mint_address = '3jiqwBQVRC5zRwHyqvnkQurebJ5RNxg3F5fXMwaxgkv8'
  AND block_date >= DATE '2026-02-01'
  AND from_owner IS NOT NULL AND to_owner IS NOT NULL
GROUP BY 1
ORDER BY week DESC

-- pulls weekly activites relating to transactions on solana blockchain
