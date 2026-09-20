WITH transfers AS (
    -- Base chain + BNB chain  + Polygon chain
    SELECT chain AS blockchain, evt_block_time, "from" AS sender, "to" AS receiver, value
    FROM cngn_token_v_1_multichain.cngn_evt_transfer
    WHERE evt_block_time >= TIMESTAMP '2025-01-01'
    UNION ALL
    -- Ethereum chain decode and group by
    SELECT 'ethereum', evt_block_time, "from", "to", value
    FROM erc20_ethereum.evt_transfer
    WHERE contract_address = 0x17cdb2a01e7a34cbb3dd4b83260b05d0274c8dab AND evt_block_time >= TIMESTAMP '2025-01-01'
),
weekly AS (
    SELECT
        CAST(date_trunc('week', evt_block_time) AS date) AS week,
        blockchain,
        SUM(CASE WHEN sender = 0x0000000000000000000000000000000000000000 THEN CAST(value AS double)/1e6 ELSE 0 END) AS mint,
        SUM(CASE WHEN receiver = 0x0000000000000000000000000000000000000000 THEN CAST(value AS double)/1e6 ELSE 0 END) AS burn
    FROM transfers
    WHERE sender = 0x0000000000000000000000000000000000000000
       OR receiver = 0x0000000000000000000000000000000000000000
    GROUP BY 1, 2
)
 -- Select from and give result
SELECT
    week, blockchain, mint, burn,
    mint - burn AS net_supply_change,
    SUM(mint - burn) OVER (PARTITION BY blockchain ORDER BY week) AS circulating_supply
FROM weekly
ORDER BY week, blockchain

-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Cngn Adoption and Growth Analysis
-- ===========================
