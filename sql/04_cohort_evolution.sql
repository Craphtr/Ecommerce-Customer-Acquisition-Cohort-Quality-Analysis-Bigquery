--==============================================================================================
-- PROJECT: Ecommerce Acquisition Analytics Case Study
-- QUESTION -  How do customer characteristics and attributes change over time?
-- DATASET: GA4 Obfuscated Ecommerce Dataset (BigQuery Public Data)
-- AUTHOR: Jubril Davies
--==============================================================================================

-- Business Goal: 
-- Full Cohort Quality Evolution 
--===============================================================================================

-- 1. BASE CUSTOMER COHORT DATA
--==============================
CREATE OR REPLACE TABLE ga_dataset.ga4_04_cohort_evolution_table as
with customer_base as (
  select
    customerId,
    cohort_date,
    channel_group,
    total_revenue,
    total_orders,
    avg_order_value,
    value_tier
  from ga_dataset.ga4_customer360_Master
),
-- 2. COHORT SIZE
--=====================
cohort_size as (
  select
    cohort_date,
    count(distinct customerId) as new_customers
from customer_base
group by cohort_date
),
-- 3. ECONOMIC QUALITY
--=====================
cohort_econs as (
  select
    cohort_date,
    round(avg(total_revenue),4) as avg_ltv,
    round(avg(avg_order_value), 4) as avg_order_value,
  from customer_base
  group by cohort_date
),
-- 4. BEHAVIURAL DEPTH
--=======================
cohort_behaviour as (
  select 
    cohort_date,
    round(avg(total_orders),2) as avg_total_orders,
    round(count(case when total_orders > 1 then customerId end)/count(distinct customerId),2) as repeat_purchase_rate,
    round(count(case when total_orders = 1 then customerId end)/count(distinct customerId), 2) as pct_one_time_buyers
  from customer_base
  group by cohort_date
),
-- 5. VALUE TIER MIX
--=========================
cohort_value_mix as (
  select
    cohort_date,
    round(avg(case when value_tier = 'Platinum' then 1 else 0 end), 2) as pct_platinum,
    round(avg(case when value_tier = 'Gold' then 1 else 0 end), 2) as pct_gold,
    round(avg(case when value_tier = 'Silver' then 1 else 0 end), 2) as pct_silver,
    round(avg(case when value_tier = 'Bronze' then 1 else 0 end), 2) as pct_bronze
  from customer_base
  group by cohort_date
),
cohort_acq_mix as (
  select
   cohort_date,
   round(avg(case when channel_group = 'Direct' then 1 else 0 end),2) as pct_direct,
   round(avg(case when channel_group like '%Search%' then 1 else 0 end),2) as pct_search,
   round(avg(case when channel_group like '%Unattributed%' then 1 else 0 end),2) as pct_unattributed,
   round(avg(case when channel_group like '%Internal%' then 1 else 0 end), 2) as pct_internal,
   round(avg(case when channel_group like '%Other%' then 1 else 0 end), 2) as pct_other
  from customer_base
  group by cohort_date
)
select
  cohort_date,
  new_customers,
  avg_ltv,
  avg_order_value,
  avg_total_orders,
  repeat_purchase_rate,
  pct_one_time_buyers,
  pct_platinum,
  pct_gold,
  pct_silver,
  pct_bronze,
  pct_direct,
  pct_search,
  pct_unattributed,
  pct_internal,
  pct_other
from cohort_size cs
join cohort_econs ce using(cohort_date)
join cohort_behaviour cb using(cohort_date)
join cohort_value_mix cv using(cohort_date)
join cohort_acq_mix ca using(cohort_date)
order by cohort_date;
