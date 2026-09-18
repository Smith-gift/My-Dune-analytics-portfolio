-- ===========================
-- AUTHOR: Solomon Gift Amunde
-- AUTHOR BIO: Onchain, blockchain and crypto data analyst
-- PROJECT: Onchain participation in the Dangote refinery IPO valued at over $40 billion
-- ===========================

with cngn_transfers as (
  select evt_tx_hash, evt_block_time, "from", value / 1e6 as cngn_spent
  from erc20_base.evt_Transfer
  where contract_address = 0x46C85152bFe9f96829aA94755D9f915F9B10EF5F
    and evt_block_time >= timestamp '2026-09-14'
),

-- the above code gets us the cngn transactions from the defined date 14th september. 
-- excluding any previous token mints for accuracy

  dpri_transfers as (
  select evt_tx_hash, "to", value / 1e18 as dpri_received
  from erc20_base.evt_Transfer
  where contract_address = 0xc68b460fe4c916Fd17d6ab6b181A409C763002d9
    and evt_block_time >= timestamp '2026-09-14'
)
select
  date_trunc('day', c.evt_block_time) as day,
  count(distinct c."from") as unique_buyers,
  count(*) as purchase_count,
  sum(c.cngn_spent) as total_cngn_spent,
  sum(d.dpri_received) as total_dpri_received,
  sum(c.cngn_spent) / nullif(sum(d.dpri_received), 0) as avg_dpri_price_ngn
from cngn_transfers c
join dpri_transfers d
  on c.evt_tx_hash = d.evt_tx_hash
  and c."from" = d."to"
group by 1
order by 1

-- This code will sort all users cngn spent to purchase dpri token on base chain
-- from september 14th 2026 when the dangote refinery IPO went live
-- the query will enable us see how the users have engaged with the onchain assset and its price actiion
