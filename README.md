# 🟠 Diagnosing Cohort Quality Decline in Ecommerce — Behavioral Case Study (BigQuery)

**Addressing the common problem of deteriorating Cohort Quality faced by Ecommerce Companies**

---

### 🚀 Key Cohort Metrics

| KPI | Metric Description | Badge |
|-----|--------|-------|
| 📊 Average days to 2nd purchase | Measures activation speed — how quickly new customers become repeat buyers after first purchase. Lower = healthier onboarding and engagement. | ![Days to 2nd purchase](https://img.shields.io/badge/Days%20to%202nd%20buy-3.03%25-blue) |
| 🔄 Repeat Purchase Rate | Percentage of customers who purchase more than once. Primary indicator of early retention and cohort health. | ![Repeat Purchase Rate](https://img.shields.io/badge/Repeat%20Rate-42%25-green) |
| 🏆 Percentage of One-time Buyers | Share of customers who never return after first purchase. Direct signal of activation failure and revenue leakage. | ![One-time Buyers](https://img.shields.io/badge/One%20buyers-83.7%25-lightgrey) |
| 🥇 Users Activated Within 7 days | Portion of customers making a second purchase within one week — measures strong early engagement momentum. | ![Users within 7 days](https://img.shields.io/badge/Within%207%20days-87%25-yellow) |
| ⚪ Users Activated Within 30 days | Coverage of successful activation window; shows whether customers eventually convert even if not immediately | ![Users within 30 days](https://img.shields.io/badge/Within%2030%20days-97%25-silver) |
| 🟤 High-Value Customer Share | Percentage of customers reaching high behavioral value tiers based on purchase frequency and engagement. Indicates cohort quality | ![High-Value Tiers](https://img.shields.io/badge/Platinum%20Gold-30.3%25-brown) |

---

# 🧠 Executive Summary — Customer Acquisition Investigation

### Business Problem
Customer acquisition volume remains stable, yet overall customer quality appears to decline over time.

### 🔎 Investigation Path

| Investigation Step | Question Tested | Outcome |
|-------------------|-----------------|---------|
| **1️⃣ Acquisition Quality** | Are some channels bringing lower-value customers? | ❌ No meaningful quality differences across channels |
| **2️⃣ Cohort Evolution** | Do newer customers behave differently over time? | ✅ Newer cohorts show weaker engagement |
| **3️⃣ Lifecycle Diagnosis** | What behavioral mechanism explains deterioration? | ✅ Customers increasingly fail to activate after first purchase |


### 📊 Executive KPI Snapshot

| Metric | Observation | Badge |
|--------|------------|-------|
| 📊 Avg Orders per Customer | Low engagement depth | ![Avg Orders](https://img.shields.io/badge/Avg%20Orders-1.30-blue) |
| 🔄 Repeat Purchase Rate | Weak retention | ![Repeat Rate](https://img.shields.io/badge/Repeat%20Rate-18%25-green) |
| 🚫 One-Time Buyers | Dominant behavior pattern | ![One Time](https://img.shields.io/badge/One--Time%20Buyers-82%25-red) |
| 🏆 High-Value Customers | Small minority | ![Platinum](https://img.shields.io/badge/Platinum%20Share-~12%25-lightgrey) |



### 🎯 Final Diagnosis

Customer quality decline is **not caused by acquisition channel performance**.

The primary failure occurs **after acquisition**, where customers increasingly fail to transition beyond their first purchase.

**Root Cause:** Early lifecycle activation breakdown.



### 💼 Business Implication

Optimizing marketing spend alone will not reverse performance decline.

Impact is more likely achieved through:

- post-purchase engagement strategy
- onboarding and activation improvements
- early lifecycle retention interventions

---

# Problem Statement

Ecommerce companies frequently face a common challenge:

- Customer acquisition volume is increasing  
- Marketing strategy remains stable  
- Customer quality is declining  

This creates a critical ambiguity:

> Is acquisition failing, or are customers failing to **activate after acquisition**?

This project investigates **customer acquisition effectiveness** and the **deterioration of cohort quality** using the Google Analytics 4 (GA4) public BigQuery dataset.  

Because revenue is obfuscated in the GA4 sample data, customer value is assessed using a **behavioral definition**, focusing on engagement and purchase patterns.  

### **Objective:** 
Investigate and address the common problem of **deteriorating cohort quality**, by understanding behavioral and engagement patterns that drive customer value post-acquisition.  

The analysis follows a **sequential diagnostic approach**:

1. Evaluate acquisition channel quality  
2. Examine cohort behavior over time  
3. Diagnose lifecycle mechanisms driving deterioration  

This workflow demonstrates how structured analytics can **isolate the true driver** of declining customer quality.

---

# Data & Analytical Framework

**Source:** [Google Analytics 4 Obfuscated Ecommerce Dataset (BigQuery Public Data)](https://console.cloud.google.com/marketplace/details/bigquery-public-data/ga4-obfuscated)  

### **Characteristics:**
- Event-level ecommerce tracking  
- 3 months of observable acquisition cohorts  
- Revenue values anonymized (near zero)  
- Partial channel attribution  
- No explicit CAC data  

### **Analytical Constraint:**  
Because monetary metrics are obfuscated, **customer value must be inferred using behavioral proxies**, mirroring real industry scenarios involving **privacy loss and incomplete attribution**.


All analyses follow a **repeatable product analytics workflow**:

Customer Lifecycle Stage  
⬇️ Primary Business Risk  
⬇️ Metric Family  
⬇️ Metric Table Schema  
⬇️ SQL Modeling  
⬇️ Decision Interpretation

### **Lifecycle Focus:** 
Customer Lifecycle Stage → Acquisition Economics  
**Note: Because revenue metrics are obfuscated, acquisition economics are inferred using behavioral proxies such as repeat purchase rate, average orders, and value tier distribution.**

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
---

## Analysis 1 — Acquisition Channel Quality

---

## 🧭 Investigation Progress

**Customer Quality Decline Investigation**

`[ STEP 1: Acquisition Quality ] → Cohort Evolution → Lifecycle Diagnosis → Root Cause`

**Current Objective:** Test whether acquisition channels explain declining customer quality.

--- 

 📊 **Acquisition Quality KPI Summary**

| KPI | Value | Badge |
|-----|-------|-------|
| 📊 Avg Orders per Customer | 1.30 | ![Avg Orders](https://img.shields.io/badge/Avg%20Orders-1.30-blue) |
| 🔄 Repeat Purchase Rate | 18% | ![Repeat Rate](https://img.shields.io/badge/Repeat%20Rate-18%25-green) |
| 🚫 One-Time Buyers | 82% | ![One Time Buyers](https://img.shields.io/badge/One--Time%20Buyers-82%25-red) |
| 🏆 Platinum Customers | 10–13% | ![Platinum](https://img.shields.io/badge/Platinum%20Share-~12%25-lightgrey) |
| 👥 Customers Acquired | 4,066 | ![Customers](https://img.shields.io/badge/Customers-4066-purple) | 

### Key Results — Acquisition Channel Quality

| Channel Group | Customers | Avg Orders | Repeat Rate | Platinum % | One-Time Buyers % |
|---------------|-----------|------------|-------------|------------|------------------|
| Internal / Self Referral | 485 | 1.32 | 0.20 | 0.13 | 0.80 |
| Unattributed (Consent Loss) | 551 | 1.34 | 0.19 | 0.10 | 0.81 |
| Direct | 891 | 1.29 | 0.19 | 0.10 | 0.81 |
| Other / Unknown | 925 | 1.30 | 0.16 | 0.10 | 0.84 |
| Search (Paid/Organic) | 1214 | 1.25 | 0.16 | 0.09 | 0.84 |

**Key Finding:**  
- Engagement is shallow coupled with a weak retention. 
- Activation Failure is high with the dominant behavioral pattern being one-time purchasing.
- Channel performance differences exist — but they are small relative to the structural issue.

**Implication:**  
The quality of customers is broadly similar across all channels, with minor behavioral advantages in Internal and Direct traffic. However, across all channels, approximately 80% of customers purchase only once, indicating that retention—not acquisition mix—is the primary performance constraint. Strategic focus should shift toward post-purchase engagement rather than channel reallocation.

**Visualization:**  
![Analysis 1 - Acquisition Channel Quality](./visuals/01_Channel_Quality_trend.png)


**Hypothesis Status:** ❌ Acquisition channels are NOT the primary driver.
---
---

## Analysis 2 — Cohort Evolution

---

## 🧭 Investigation Progress

**Customer Quality Decline Investigation**

Acquisition Quality → `[ STEP 2: Cohort Evolution ]` → Lifecycle Diagnosis → Root Cause

**Current Objective:** Determine whether customer behavior changes across acquisition cohorts over time.

---
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

**Hypothesis Status:** ✅ Customer behavior worsens across newer cohorts.
---
---

## Analysis 3 — Cohort Deterioration Diagnosis

---

## 🧭 Investigation Progress

**Customer Quality Decline Investigation**

Acquisition Quality → Cohort Evolution → `[ STEP 3: Lifecycle Diagnosis ]` → Root Cause

**Current Objective:** Identify the behavioral mechanism causing cohort deterioration.

---

**Diagnostic Dimensions:**

- **Acquisition Stability:** Channel mix remained largely constant  
- **Behavioral Change:** Time to second purchase increased, repeat purchase probability declined  
- **Activation Failure:** Customers increasingly failed to transition beyond first purchase  

**Core Insight:**  
The business problem is **not acquisition efficiency** — it is an **early lifecycle activation breakdown**. Marketing optimization alone would **not solve performance decline**.

**Visualization:**  
![Analysis 3 - Cohort Deterioration Diagnosis](./visualizations/cohort_deterioration.png)

---

## 🧭 Investigation Progress

**Customer Quality Decline Investigation**

Acquisition Quality → Cohort Evolution → Lifecycle Diagnosis → `[ ROOT CAUSE IDENTIFIED ]`

**Root Cause Identified:** Early lifecycle activation failure.
---
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