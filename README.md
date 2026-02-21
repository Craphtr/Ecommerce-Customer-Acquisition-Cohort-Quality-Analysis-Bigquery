# 🟠 E-commerce Customer Acquisition and Cohort Quality Analysis - A Case Study using GA4 - Bigquery

**Addressing the common problem of deteriorating Cohort Quality faced by Ecommerce Companies**

---

## 🚀 Key Cohort Metrics

| KPI | Metric Description | Badge |
|-----|--------|-------|
| 📊 Average days to 2nd purchase | Measures activation speed — how quickly new customers become repeat buyers after first purchase. Lower = healthier onboarding and engagement. | ![Days to 2nd purchase](https://img.shields.io/badge/Days%20to%202nd%20buy-3.03%25-blue) |
| 🔄 Repeat Purchase Rate | Percentage of customers who purchase more than once. Primary indicator of early retention and cohort health. | ![Repeat Purchase Rate](https://img.shields.io/badge/Repeat%20Rate-42%25-green) |
| 🏆 Percentage of One-time Buyers | Share of customers who never return after first purchase. Direct signal of activation failure and revenue leakage. | ![One-time Buyers](https://img.shields.io/badge/One%20buyers-83.7%25-lightgrey) |
| 🥇 Users Activated Within 7 days | Portion of customers making a second purchase within one week — measures strong early engagement momentum. | ![Users within 7 days](https://img.shields.io/badge/Within%207%20days-87%25-yellow) |
| ⚪ Users Activated Within 30 days | Coverage of successful activation window; shows whether customers eventually convert even if not immediately | ![Users within 30 days](https://img.shields.io/badge/Within%2030%20days-97%25-silver) |
| 🟤 High-Value Customer Share | Percentage of customers reaching high behavioral value tiers based on purchase frequency and engagement. Indicates cohort quality | ![High-Value Tiers](https://img.shields.io/badge/Platinum%20Gold-30.3%25-brown) |


---

## Overview

This project investigates **customer acquisition effectiveness** and **cohort quality deterioration** for an ecommerce business using the Google Analytics 4 (GA4) public BigQuery dataset.

Rather than relying on revenue (obfuscated in GA4 sample data), this analysis applies a **behavioral definition of customer value**, replicating how product analytics teams diagnose acquisition performance under **imperfect real-world data constraints**.

**Objective:** Answer three acquisition-stage business questions:

1. Which acquisition channels bring **high-value customers**?  
2. How do **customer characteristics evolve over time**?  
3. Why are **newer customer cohorts deteriorating** despite stable acquisition strategy?  

---

## Business Context

Ecommerce companies frequently observe:

- Increasing customer acquisition volume  
- Stable marketing strategy  
- Declining customer quality  

This creates a critical ambiguity:

> Is acquisition failing, or are customers failing to **activate after acquisition**?

This project demonstrates a structured analytical workflow to **isolate the true driver**.

---

## Dataset

**Source:** [Google Analytics 4 Obfuscated Ecommerce Dataset (BigQuery Public Data)](https://console.cloud.google.com/marketplace/details/bigquery-public-data/ga4-obfuscated)  

**Characteristics:**

- Event-level ecommerce tracking  
- 3 months of observable acquisition cohorts  
- Revenue values anonymized (near zero)  
- Partial channel attribution  
- No explicit CAC data  

**Analytical Constraint:**  

Because monetary metrics are obfuscated, **customer value must be inferred using behavioral proxies**, mirroring real industry scenarios involving **privacy loss and incomplete attribution**.

---

## Analytical Framework

All analyses follow a **repeatable product analytics workflow**:

Customer Lifecycle Stage  
⬇️ Primary Business Risk  
⬇️ Metric Family  
⬇️ Metric Table Schema  
⬇️ SQL Modeling  
⬇️ Decision Interpretation


**Lifecycle focus:** Customer Lifecycle Stage → **Acquisition Economics**

---

## Data Modeling

A **customer-level analytical layer** (`customer360`) was constructed from event data.  

**Customer Grain:** One row per customer  

**Core Fields:**

| Column | Description |
|--------|-------------|
| `customerId` | Unique user identifier |
| `cohort_date` | Month of first purchase |
| `channel_group` | First acquisition channel |
| `total_orders` | Lifetime purchase count |
| `avg_order_value` | Mean order value proxy |
| `value_tier` | Behavioral customer tier |

**Metric Definition: Behavioral Customer Value**  

Because revenue is obfuscated, customer value is defined using **engagement and purchasing behavior**.

**Value Indicators:**

- `avg_orders_per_customer`  
- `repeat_purchase_rate`  
- `pct_one_time_buyers`  
- `value tier distribution`  
- `time to second purchase`  

**High-value customers** are those who:

- Purchase again  
- Purchase quickly  
- Exhibit higher order frequency  

---

## Analysis 1 — Acquisition Channel Quality

**Business Question:** Which channels bring **high-value customers**?  

**Metrics:**

 📊 **Acquisition Quality KPI Summary**

| KPI | Value | Badge |
|-----|-------|-------|
| 📊 Avg Orders per Customer | 1.30 | ![Avg Orders](https://img.shields.io/badge/Avg%20Orders-1.30-blue) |
| 🔄 Repeat Purchase Rate | 18% | ![Repeat Rate](https://img.shields.io/badge/Repeat%20Rate-18%25-green) |
| 🚫 One-Time Buyers | 82% | ![One Time Buyers](https://img.shields.io/badge/One--Time%20Buyers-82%25-red) |
| 🏆 Platinum Customers | 10–13% | ![Platinum](https://img.shields.io/badge/Platinum%20Share-~12%25-lightgrey) |
| 👥 Customers Acquired | 4,066 | ![Customers](https://img.shields.io/badge/Customers-4066-purple) | 

**Key Finding:**  
- Engagement is shallow coupled with a weak retention. 
- Activation Failure is high with the dominant behavioral pattern being one-time purchasing.
- Channel performance differences exist — but they are small relative to the structural issue.

**Implication:**  
Customer acquisition quality is broadly similar across channels, with minor behavioral advantages in Internal and Direct traffic. However, across all channels, approximately 80% of customers purchase only once, indicating that retention—not acquisition mix—is the primary performance constraint. Strategic focus should shift toward post-purchase engagement rather than channel reallocation.

**Visualization:**  
![Analysis 1 - Acquisition Channel Quality](./visuals/01_Channel_Quality_trend.png)

---

## Analysis 2 — Cohort Evolution

**Business Question:** How do **customer characteristics change over time**?  

Customers were grouped by **first purchase month**.

**Metrics Examined:**

- Repeat purchase rate  
- Average order frequency  
- Value tier migration  
- Acquisition mix stability  

**Finding:**  
Later cohorts demonstrated:

- Higher one-time buyer share  
- Lower repeat behavior  
- Reduced engagement depth  

Customer quality **degraded progressively** after acquisition.

**Visualization:**  
![Analysis 2 - Cohort Evolution](./visualizations/cohort_evolution.png)

---

## Analysis 3 — Cohort Deterioration Diagnosis

**Business Question:** Why are cohorts deteriorating despite **stable acquisition strategy**?  

**Diagnostic Dimensions:**

- **Acquisition Stability:** Channel mix remained largely constant  
- **Behavioral Change:** Time to second purchase increased, repeat purchase probability declined  
- **Activation Failure:** Customers increasingly failed to transition beyond first purchase  

**Core Insight:**  
The business problem is **not acquisition efficiency** — it is an **early lifecycle activation breakdown**. Marketing optimization alone would **not solve performance decline**.

**Visualization:**  
![Analysis 3 - Cohort Deterioration Diagnosis](./visualizations/cohort_deterioration.png)

---

## Key Takeaways

- Behavioral metrics are essential when revenue is obfuscated  
- Cohort analysis reveals early activation failures that traditional channel KPIs cannot detect  
- Structured, repeatable workflows enable rapid diagnosis of customer quality issues  
- Visualizations should track **metrics across time**, not just across channels  

---

## How to Run This Analysis

1. Clone the repository:  

```bash
git clone https://github.com/Craphtr/Ecommerce-Customer-Acquisition-Cohort-Quality-Analysis-Bigquery.git

2. Open BigQuery and link the GA4 sample dataset.

3. Run the SQL scripts in sql/ folder to create customer360 layer and cohort tables.

4. Update visualization placeholders in visualizations/ folder.

5. Open README.md in GitHub to see fully rendered results.