--===========================================================================================
-- PROJECT: Ecommerce Acquisition Analytics Case Study
-- QUESTION - Why are cohorts deteriorating despite stable acquisition strategy?
-- DATASET: GA4 Obfuscated Ecommerce Dataset (BigQuery Public Data)
-- AUTHOR: Jubril Davies
--===========================================================================================

-- Business Goal
-- Diagnose why Cohorts are deteriorating
--=========================================================================================== 

-- 1. Define Customer Base Data
--------------------------------
with purchases as (
  select 
    user_pseudo_id as customerId,
    timestamp_micros(event_timestamp) as purchase_time
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  where event_name = 'purchase' and coalesce(ecommerce.purchase_revenue,(select ep.value.double_value from unnest(event_params) ep where ep.key = 'value')) is not null
),
--Define customer_base
customer_base as (
  select
    cm.customerId,
    cm.cohort_date,
    cm.channel_group,
    cm.total_revenue,
    cm.total_orders,
    cm.avg_order_value,
    cm.value_tier,
    p.purchase_time
  from ga_dataset.ga4_customer360_Master cm
  join purchases p using(customerId) 
),
-- Ranked Purchases
---------------------------------
ranked_purchases as (
  select 
    customerId,
    cohort_date,
    channel_group,
    total_revenue,
    total_orders,
    avg_order_value,
    value_tier,
    purchase_time,
    row_number() over(partition by customerId order by purchase_time) as purchase_rank
  from customer_base
),
-- Define Purchase Pairs
---------------------------------
purchase_pairs as (
  select 
    customerId,
    min(case when purchase_rank = 1 then purchase_time end) as first_purchase_time,
    min(case when purchase_rank = 2 then purchase_time end) as second_purchase_time
  from ranked_purchases
  group by customerId
),
--Define User Latency
---------------------------------
user_latency as (
  select
    cb.customerId,
    cb.cohort_date,
    cb.channel_group,
    cb.value_tier,
    cb.total_revenue,
    cb.avg_order_value,
    pp.first_purchase_time,
    pp.second_purchase_time,
    timestamp_diff(second_purchase_time, first_purchase_time, day) as days_to_second_purchase
  from customer_base cb
  join purchase_pairs pp using(customerId) 
),
-- Define Cohort Size
---------------------------------
cohort_size as (
  select 
    cohort_date,
    count(distinct customerId) as new_customers
  from customer_base
  group by cohort_date
),
-- Define Acquisition Mix
---------------------------------
cohort_acquisition_mix as (
  select
    cohort_date,
    round(avg(case when channel_group = 'Direct' then 1 else 0 end),2) as pct_direct,
    round(avg(case when channel_group like '%Search%' then 1 else 0 end),2) as pct_search,
    round(avg(case when channel_group like '%Unattributed%' then 1 else 0 end), 2) as pct_unattributed,
    round(avg(case when channel_group like '%Internal%' then 1 else 0 end),2) as pct_internal,
    round(avg(case when channel_group like '%Other%' then 1 else 0 end),2) as pct_other
  from customer_base
  group by cohort_date
),
-- Define Value_tier composition
----------------------------------
cohort_tier as (
  select
    cohort_date,
    round(avg(case when value_tier = 'Platinum' then 1 else 0 end),2) as pct_platinum,
    round(avg(case when value_tier = 'Gold' then 1 else 0 end), 2) as pct_gold,
    round(avg(case when value_tier = 'Silver' then 1 else 0 end),2) as pct_silver,
    round(avg(case when value_tier = 'Bronze' then 1 else 0 end),2) as pct_bronze
  from customer_base
  group by cohort_date
),
-- Define Economic Quality & Behavioral Depth
-----------------------------------------------
cohort_econs_behaviour as (
  select
    cohort_date,
    --Economics
    round(avg(total_revenue),4) as avg_ltv,
    --Behaviour
    round(avg(total_orders),2) as avg_total_orders,
    round(count(case when total_orders > 1 then customerId end)/count(distinct customerId),2) as repeat_purchase_rate,
    round(count(case when total_orders = 1 then customerId end)/count(distinct customerId),2) as pct_one_time_customers
  from customer_base
  group by cohort_date
),
-- Define Engagement Efficiency Metrics
------------------------------------------------
cohort_engagement as (
  select
    cohort_date,
    round(avg(avg_order_value),4) as avg_order_value,
    avg(days_to_second_purchase) as avg_days_to_second_purchase,
    safe_divide(countif(days_to_second_purchase <= 7), count(days_to_second_purchase)) as pct_users_within_7days,
    safe_divide(countif(days_to_second_purchase <= 30), count(days_to_second_purchase)) as pct_users_within_30_days
  from user_latency
  where days_to_second_purchase is not null
  group by cohort_date
)
select
  cs.cohort_date,
  cs.new_customers,
  cam.pct_direct,
  cam.pct_search,
  cam.pct_unattributed,
  cam.pct_internal,
  cam.pct_other,
  ct.pct_platinum,
  ct.pct_gold,
  ct.pct_silver,
  ct.pct_bronze,
  ceb.avg_ltv,
  ceb.avg_total_orders,
  ceb.repeat_purchase_rate,
  ceb.pct_one_time_customers,
  ce.avg_order_value,
  ce.avg_days_to_second_purchase,
  ce.pct_users_within_7days,
  ce.pct_users_within_30_days
from cohort_size cs
join cohort_acquisition_mix cam using (cohort_date)
join cohort_tier ct using(cohort_date)
join cohort_econs_behaviour ceb using(cohort_date)
join cohort_engagement ce using(cohort_date)
order by cohort_date
