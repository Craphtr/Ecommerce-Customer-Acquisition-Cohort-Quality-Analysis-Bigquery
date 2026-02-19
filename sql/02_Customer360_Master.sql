--====================================================================================
-- PROJECT: Ecommerce Acquisition Analytics Case Study
-- GOAL: Build the Customer Master 360 Table from the Raw Aggregate Customer360 Table
-- DATASET: GA4 Obfuscated Ecommerce Dataset (BigQuery Public Data)
-- AUTHOR: Jubril Davies
--====================================================================================

CREATE OR REPLACE TABLE ga_dataset.ga4_customer360_Master as
with raw_customer360 as (
  select
    customerId,
    extract (month from first_order_date) as cohort_month,
    first_order_date,
    last_order_date,
    total_orders,
    total_revenue,
    first_order_channel,
    first_order_amount,
    last_order_channel,
    percent_rank() over (order by total_revenue desc) as revenue_rank,
    -- Recency, Frequency, Monetary
    ntile(5) over (order by timestamp_diff(timestamp_add(last_order_date, interval 1 day), last_order_date, day)asc) as recency_score,-- recent buyers score high
    ntile(5) over (order by total_orders desc) as frequency_score,-- frequent buyers score high
    ntile(5) over (order by total_revenue desc) as monetary_score,-- big spenders score high
    --
    date_diff(timestamp_add(max(date(last_order_date)) over(), interval 1 day),date(last_order_date),day) as recency,--days since last purchase
    date_diff(timestamp_add(max(date(last_order_date)) over(), interval 1 day), date(first_order_date),day) as tenure_days --customer lifetime so far
  from ga_dataset.ga4_customer360_Raw
),
--===========================================================
-- Final Processing
--===========================================================
final_processing as (
  select *,
    concat(cast(recency_score as string), cast(frequency_score as string), cast(monetary_score as string)) as rfm_score,
   -- champions - best customers who bought recently, often and spend a lot
    case when recency_score >= 4 and frequency_score >= 4 then 'Champions'
      -- Loyal - buy regularly and responsive to promotions
      when recency_score >= 2 and frequency_score >= 3 then 'Loyal'
      -- Potential Loyalists - recent customers with average frequency
      when recency_score >= 3 and frequency_score <= 3 then 'Potential Loyalists'
      -- New Customers - High recency but low frequency
      when recency_score >= 4 and frequency_score <=1 then 'New Customers'
      -- At Risk - Big spenders who haven't bought in a while
      when recency_score <= 2 and frequency_score >= 3 then 'At Risk'
      -- Can't lose them - used to be top tier but haven't returned in ages
      when recency_score = 1 and frequency_score >= 4 then 'Cant Lose them'
      -- Hibernating - Low recency, Low frequency
      when recency_score <= 2 and frequency_score <= 2 then 'Hibernating'
      -- Lost - Lowest scores across the board
      when recency_score = 1 and frequency_score = 1 then 'Lost'
      else 'Other'
    end as rfm_segment,
  -- segment customers
      case when revenue_rank <= 0.1 then 'Platinum'
        when revenue_rank <= 0.3 then 'Gold'
        when revenue_rank <= 0.6 then 'Silver'
      else 'Bronze' 
      end as value_tier,
  -- the behaviour state - the How
    case when tenure_days < 30 then 'New'
      when recency <= 30 then 'Active'
      when recency <= 90 then 'At Risk'
      when recency > 90 then 'Churned'
    end as behaviour_state,
  -- Attribution Logic
    CASE 
    --High confidence channels
      when first_order_channel = '(direct)' THEN 'Direct'
      when first_order_channel LIKE '%google%' 
      and first_order_channel NOT LIKE '%merchandise%' THEN 'Search (Paid/Organic)'
    -- Self-referral / internal noise
      when first_order_channel LIKE '%googlemerchandisestore%' THEN 'Internal / Self Referral'
    -- Privacy loss
      when first_order_channel = '(data deleted)' THEN 'Unattributed (Consent Loss)'
    -- Everything else
    else 'Other / Unknown'
    end as channel_group
  from raw_customer360
)
--============================================================================
-- FINAL OUTPUT
--============================================================================
select
  customerId,
  cohort_month,
  first_order_date,
  last_order_date,
  total_orders,
  total_revenue,
  total_revenue/total_orders as avg_order_value,
  first_order_channel,
  first_order_amount,
  last_order_channel,
  recency_score,
  frequency_score,
  monetary_score,
  rfm_score,
  rfm_segment,
  value_tier,
  behaviour_state,
  channel_group
from final_processing



  