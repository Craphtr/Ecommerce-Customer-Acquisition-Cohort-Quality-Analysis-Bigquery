--=================================================================================
-- PROJECT: Ecommerce Acquisition Analytics Case Study
-- GOAL: Build Raw Aggregate Table where we have order level data - one row per order
-- DATASET: GA4 Obfuscated Ecommerce Dataset (BigQuery Public Data)
-- AUTHOR: Jubril Davies
--================================================================================
-- Fact Table: Orders (Purchase events)
-- Grain: 1 row per purchase
--================================================================================
CREATE OR REPLACE TABLE ga_dataset.ga4_customer360_Raw as
with purchase_orders as (
  select 
    event_date as order_date,
    user_pseudo_id as customerId,
    (select ep.value.int_value from unnest(event_params) ep where ep.key = 'ga_session_id') as ga_session_id,   
    timestamp_micros(event_timestamp) as order_timestamp,
    coalesce(ecommerce.purchase_revenue,
    (select ep.value.double_value from unnest(event_params) ep where ep.key = 'value'))/1e6 as order_amount,
    ecommerce.total_item_quantity as order_quantity,
    ecommerce.tax_value as order_tax,
    ecommerce.shipping_value as order_shipping,
    ecommerce.transaction_id as transaction_id
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  where event_name = 'purchase' and coalesce(ecommerce.purchase_revenue,(select ep.value.double_value from unnest(event_params) ep where ep.key = 'value')) is not null
),
-- Get the channels for each session
--============================================
-- DIMENSION TABLE: Session source
-- Grain: 1 row per session
-- Only sessions with valid purchase revenue
--============================================
session_source as (
  select
    user_pseudo_id as customerId,
    ga_session_id,
    any_value(channel) as channel
    from (
      select
        user_pseudo_id,
        (select ep.value.int_value from unnest(event_params) ep where ep.key = 'ga_session_id') as ga_session_id,
        traffic_source.source as channel,
        coalesce(ecommerce.purchase_revenue, (select ep.value.double_value from unnest(event_params) ep where ep.key = 'value')) as order_amount
      from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
      where event_name = 'purchase'
     )
    where order_amount is not null
    group by customerId, ga_session_id
),
--Attach acqusistion channel to each order
--=======================================================
-- JOIN FACT + DIMENSION 
-- Grain: Still 1 row per order
--=======================================================
orders_with_channel as (
  select
    o.customerId,
    o.ga_session_id,
    o.transaction_id,
    o.order_timestamp,
    o.order_amount,
    o.order_quantity,
    o.order_tax,
    o.order_shipping,
    s.channel
  from purchase_orders o
  left join session_source s
  on o.customerId = s.customerId
  and o.ga_session_id = s.ga_session_id
),
-- rank customers by order
--=============================================
-- Rank Orders per Customer
-- To identify first and last order
--=============================================
ranked_order as (
  select *,
    row_number() over (partition by customerId order by order_timestamp) as order_rank,
    row_number() over (partition by customerId order by order_timestamp desc) as reverse_order_rank
  from orders_with_channel
)
--aggregate orders and group by customerId
--=====================================================
-- Aggregate to Customer Raw 360
-- Grain: 1 row per customer
--=====================================================
select
  customerId,
  min(order_timestamp) as first_order_date,
  max(order_timestamp) as last_order_date,
  count(*) as total_orders,
  sum(order_amount) as total_revenue,
  max(if(order_rank = 1, channel, null)) as first_order_channel,
  max(if(order_rank = 1, order_amount, null)) as first_order_amount,
  max(if(reverse_order_rank = 1, channel, null)) as last_order_channel
from ranked_order
group by customerId;