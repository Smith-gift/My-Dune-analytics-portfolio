-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Onchain participation in the Dangote refinery IPO valued at over $50 billion
-- ===========================

select
  date_trunc('day', block_time) as day,
  count(*) as tx_count,
  count(distinct "from") as unique_wallets
from base.transactions
where "to" = 0x716B0B731f2FB292C74BD121485d930FA3dEA2DD
  and success = true
  and block_time >= timestamp '2026-09-14'
group by 1
order by 1

-- This code fetch all unique wallets that traded the dangote IPO token( DPRI) from 14th september 2026.
-- Dangote IPO launched september 14th 2026
