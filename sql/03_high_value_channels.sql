--==============================================================================================
-- PROJECT: Ecommerce Acquisition Analytics Case Study
-- QUESTION - Which acquisition channels bring high-value customers, (Behavioral Definition)?
-- DATASET: GA4 Obfuscated Ecommerce Dataset (BigQuery Public Data)
-- AUTHOR: Jubril Davies
--==============================================================================================

-- Business Goal:
-- Identify acquisition channels producing high behavioral quality customers.
--==============================================================================================

with customer_metrics as (
  select 
    customerId,
    channel_group,
    total_orders,
    value_tier
  from ga_dataset.ga4_customer360_Master
),
channel_summary as (
  select
    channel_group,
    -- Customer Volume
    count(distinct customerId) as total_customers,
    -- Engagement Depth
    round(avg(total_orders),2) as avg_orders_per_customer,
    -- Repeat Intent
    round(count(distinct case when total_orders > 1 then customerId end)/count(distinct customerId),2) as repeat_purchase_rate,
    -- Tier distribution
    round(sum(case when value_tier = 'Platinum' then 1 else 0 end)/count(distinct customerId),2) as pct_platinum,
    round(sum(case when value_tier = 'Gold' then 1 else 0 end)/count(distinct customerId),2) as pct_gold,
    round(sum(case when value_tier = 'Silver' then 1 else 0 end)/count(distinct customerId),2) as pct_silver,
    round(sum(case when value_tier = 'Bronze' then 1 else 0 end)/count(distinct customerId),2) as pct_bronze,
    -- One time buyers
    round(count(distinct case when total_orders = 1 then customerId end)/count(distinct customerId),2) as pct_one_time_buyers
from customer_metrics
group by channel_group
)
  select *
  from channel_summary
  order by repeat_purchase_rate desc, avg_orders_per_customer desc;

