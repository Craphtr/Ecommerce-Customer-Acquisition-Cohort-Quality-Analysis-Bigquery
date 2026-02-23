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
**Note: Because revenue metrics are obfuscated, acquisition economics are inferred using behavioral proxies such as repeat purchase rate, average order per customer and value tier distribution.**

---

# Data Modeling

To enable cohort-level and customer-level analyses, a **customer-level analytical layer** (`customer360`) was constructed from raw event data. This layer aggregates behavioral signals to support **inference of customer value** in the absence of revenue metrics.

**Customer Grain:** One row per customer  

### **Core Fields**

| Column | Description |
|--------|-------------|
| `customerId` | Unique user identifier |
| `cohort_date` | Month of first purchase |
| `channel_group` | First acquisition channel |
| `total_orders` | Lifetime purchase count |
| `avg_order_value` | Mean order value proxy |
| `value_tier` | Behavioral customer tier |

### **Metric Definition: Behavioral Customer Value**

Since revenue is obfuscated in GA4, customer value is inferred using **engagement and purchasing behavior**. This approach mirrors real-world analytics scenarios where financial data is incomplete or unavailable.

### **Value Indicators**

- `avg_orders_per_customer` — overall purchase frequency  
- `repeat_purchase_rate` — likelihood of buying more than once  
- `pct_one_time_buyers` — share of single-purchase customers  
- `value tier distribution` — classification into Platinum/Gold/Silver/Bronze  
- `time to second purchase` — speed of customer activation  

### **High-Value Customers**

Customers are considered high-value if they:

- Purchase again after their first order  
- Purchase quickly (short time to second purchase)  
- Exhibit higher order frequency and engagement  


---

# Analysis Step 1 — Testing Acquisition Channel Quality

---

### 🧭 Investigation Progress

`[ ANALYSIS STEP 1: Acquisition Quality ] → Cohort Evolution → Lifecycle Diagnosis → Root Cause`

Customer quality is declining despite stable acquisition strategy.

### **First Working Hypothesis:** Some acquisition channels may be bringing lower quality customers. 
If true, reallocating marketing spend could solve performance decline.

--- 
Customers were evaluated using repeat behavior and value-tier distribution across channels.

 ### 📊 **Acquisition Quality KPI Summary**

| KPI | Value | Badge |
|-----|-------|-------|
| 📊 Avg Orders per Customer | 1.30 | ![Avg Orders](https://img.shields.io/badge/Avg%20Orders-1.30-blue) |
| 🔄 Repeat Purchase Rate | 18% | ![Repeat Rate](https://img.shields.io/badge/Repeat%20Rate-18%25-green) |
| 🚫 One-Time Buyers | 82% | ![One Time Buyers](https://img.shields.io/badge/One--Time%20Buyers-82%25-red) |
| 🏆 Platinum Customers | 10–13% | ![Platinum](https://img.shields.io/badge/Platinum%20Share-~12%25-lightgrey) |
| 👥 Customers Acquired | 4,066 | ![Customers](https://img.shields.io/badge/Customers-4066-purple) | 

### **Visualization:**  
![Analysis 1 - Acquisition Channel Quality](./visuals/01_Channel_Quality_trend.png)

### Key Results — Acquisition Channel Quality

| Channel Group | Customers | Avg Orders | Repeat Rate | Platinum % | Gold % | One-Time Buyers % |
|---------------|-----------|------------|-------------|------------|--------|------------------|
| Internal / Self Referral | 485 | 1.32 | 0.20 | 13% | 21% | 80% |
| Unattributed (Consent Loss) | 551 | 1.34 | 0.19 | 10% | 21% | 81% |
| Direct | 891 | 1.29 | 0.19 | 10% | 29% | 81% |
| Other / Unknown | 925 | 1.30 | 0.16 | 10% | 18% | 84% |
| Search (Paid/Organic) | 1214 | 1.25 | 0.16 | 9% | 21% | 84% |

### **Key Findings**

- Engagement depth is uniformly shallow across channels.
- Repeat purchase rates cluster tightly between 16 and 20%.
- Approximately 80% of customers purchase only once, regardless of acquisition source.
- Channel differences exist but are marginal relative to overall behavioral patterns.

### **Interim Insight**
Customer behavior converges toward the same outcome independent of acquisition source.

This indicates the business is successfully acquiring customers but struggling to retain them.
The performance constraint appears post-acquisition, not in marketing mix.

### **Hypothesis Status:** ❌ Acquisition channels are NOT the primary driver of declining Customer Quality.

### **Decision - Next Hypothesis:**  
If acquisition quality is stable, cohort deterioration must occur after customers enter the lifecycle.

Next Step: Analyze how customer cohorts evolve over time.

---

# Analysis Step 2 — Cohort Evolution

---

### 🧭 Investigation Progress

Acquisition Quality → `[ ANALYSIS STEP 2: Cohort Evolution ]` → Lifecycle Diagnosis → Root Cause
Acquisition channels were found not to explain declining customer quality.
This step evaluates whether behavioral quality changes across customer cohorts over time.

### **Second Working Hypothesis:** Customer behavior deteriorates across newer acquisition cohorts.

If true, the decline originates after acquisition and indicates structural changes in customer engagement.

---
Customers were grouped by **first purchase month** to observe behavioral evolution.

### 📊 Cohort Evolution KPI Summary

| KPI | Value | Badge |
|-----|-------|-------|
| 🔄 Repeat Purchase Rate | 16% | ![Repeat Rate](https://img.shields.io/badge/Repeat%20Rate-16%25-green) |
| 📊 Avg Orders per Customer | 1.26 | ![Avg Orders](https://img.shields.io/badge/Avg%20Orders-1.26-blue) |
| 🚫 One-Time Buyers | 84% | ![One Time Buyers](https://img.shields.io/badge/One--Time%20Buyers-84%25-red) |
| 🏆 High-Value Tier Share (Platinum + Gold) | ~31% | ![High Value Share](https://img.shields.io/badge/High--Value%20Customers-31%25-lightgrey) |
| 📡 Acquisition Mix Stability | Stable | ![Channel Mix](https://img.shields.io/badge/Channel%20Mix-Stable-purple) |

These metrics evaluate whether customer engagement depth and value composition change across acquisition cohorts over time.

### **Visualization:**  
![Analysis 2 - Cohort Evolution](./visualizations/cohort_evolution.png)

### **Key Findings**  
- Customer volume expanded from November to December before declining in January, indicating mid-period acquisition scaling.
- Behavioral depth weakened progressively across cohorts:
  - repeat purchase rate declined,
  - average orders decreased,
  - one-time buyers increased.
- High-value customers (Platinum + Gold) shrank while lower-value tiers expanded, indicating structural quality deterioration rather than random variation.
- Acquisition channel mix remained stable across cohorts, confirming deterioration is not marketing-channel driven.

### **Interim Insight**
Earlier cohorts demonstrated stronger engagement and value concentration, establishing a baseline of efficient acquisition.
As acquisition scaled, customer depth declined — suggesting growth shifted from quality-driven acquisition toward volume expansion.

This pattern signals acquisition dilution, where newer customers enter the lifecycle with weaker long-term engagement potential.

### **Economic Implication**
If this trajectory continues:
- Future customer lifetime value (LTV) will compress.
- Growth may appear healthy through rising customer counts while retention weakens underneath.
- Revenue expansion risks masking deteriorating unit economics and rising churn exposure.

### **Hypothesis Status:** ✅ Customer behavior worsens across newer cohorts.

### **Decision - Next Hypothesis
Since deterioration occurs after acquisition and progressively across time, the next step is to identify where in the customer lifecycle engagement breaks down.

Next Step: Diagnose lifecycle-stage friction driving retention collapse.

---

## Analysis 3 — Cohort Deterioration Diagnosis

---

## 🧭 Investigation Progress

**Customer Quality Decline Investigation**

Acquisition Quality → Cohort Evolution → `[ ANALYSIS STEP 3: Lifecycle Diagnosis ]` → Root Cause

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