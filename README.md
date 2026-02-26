# 🟠Simulated Consulting Engagement: Ecommerce Cohort Quality Diagnostic
TechCraphters Strategic Analytics 

#### **Addressing the common problem of deteriorating Cohort Quality faced by Ecommerce Companies**


## 📋 Engagement Simulation Context
#### **Scenario:** Fortune 500 Ecommerce Retailer
#### **Role:** Lead Analytics Consultant (Simulated)
#### **Duration:** 6 weeks
#### **Stakeholder:** Chief Marketing Officer & VP of Customer Retention

# **Business Scenario**
This case study simulates a strategic diagnostic engagement using the Google Analytics 4 public dataset. The business context, stakeholder dynamics, and strategic stakes are modeled on typical enterprise engagements I have observed or participated in, while all data and specific outcomes are derived from public sources.

### **Mandate:**
A client's acquisition volume has grown 34% YoY, yet quarterly revenue growth lags at 12%. The CMO must decide whether to approve a 40% increase in Q2 acquisition spend. My objective is to determine whether declining performance stems from acquisition source degradation or post-acquisition activation failure.

### **Analytical Constraint:**
Revenue values are obfuscated in the GA4 dataset, requiring behavioral proxy methodology—a common real-world scenario where financial data resides in separate systems or requires legal clearance.

>### **Consulting Approach:**
>I deliberately chose this constraint to demonstrate how I operate when perfect data is unavailable. In actual engagements, I frequently architect analytics strategies across data silos, using behavioral inference when revenue data is inaccessible. This simulation showcases that capability.

---
# 🎯 Executive Summary
### **The Board Question**
"We're acquiring more customers than ever. Why isn't revenue accelerating?"

### 🔍 **Diagnostic Methodology**
I designed a three-phase forensic analysis to isolate the failure point in the customer journey. Each phase tested a specific hypothesis using repeatable, production-grade SQL pipelines.

**PHASE 1: Acquisition Quality Audit**

    ⬇️ Ruled out: Channel-driven degradation

**PHASE 2: Cohort Evolution Analysis**  

    ⬇️ Confirmed: Temporal quality deterioration

**PHASE 3: Lifecycle Mechanism Diagnosis**

    ✅ Isolated: Early activation failure as root cause


### **Executive KPI Snapshot**

| Metric                      | Finding                    | Risk Level  | Strategic Implication                             |
| --------------------------- | ------------------------------------ | ----------- | ------------------------------------------------- |
| 🚫**One-Time Buyer Rate**     | 82% across all channels              | 🔴 Critical | Majority of customers never generate repeat value |
| 🔄**Repeat Purchase Rate**    | 29% → 6% across cohorts              | 🔴 Critical | Newer customers 79% less likely to return         |
| 🏆**Platinum Customer Share** | 24% → 8%                             | 🔴 Critical | High-value concentration collapsing               |
| ⏱**Activation Speed**        | 3.9 days → 1.5 days (motivated only) | 🟡 Warning  | Only highly motivated customers activating        |


### **Final Diagnosis**
Customer quality decline is not an acquisition problem. The primary failure occurs **after acquisition**, where customers increasingly fail to transition beyond their first purchase. In this business scenario, the 40% acquisition increase should be conditionally declined pending resolution of early-lifecycle retention failure.

### **Recommendation**
- **Immediate:** Halt acquisition scaling. Deploy retention/activation experiments before increasing top-of-funnel spend.

- **90-Day:** Implement activation-based campaign optimization.

- **Ongoing:** Shift KPIs from "customers acquired" to "activations achieved."

---

# Data & Analytical Framework

**Source:** [Google Analytics 4 Obfuscated Ecommerce Dataset (BigQuery Public Data)](https://console.cloud.google.com/marketplace/details/bigquery-public-data/ga4-obfuscated)  

### **Characteristics:**
- Event-level ecommerce tracking  
- 3 months of observable acquisition cohorts  
- Revenue values anonymized (near zero)  
- Partial channel attribution  
- No explicit CAC data

**Technical Note:** All SQL code used production-grade patterns: modular CTEs, incremental logic, and extensible schema design. This architecture mirrors how I structure client engagements for scalability.

---

# Data Modeling

To enable cohort-level and customer-level analyses, I constructed a **customer-level analytical layer** (`customer360`) from raw event data. This layer aggregates behavioral signals to support **inference of customer value** in the absence of revenue metrics.

**Customer Grain:** One row per customer  

### **Metric Definition: Behavioral Customer Value**

Since revenue is obfuscated in GA4, I inferred customer value using **engagement and purchasing behavior**. This approach mirrors real-world analytics scenarios where financial data is incomplete or unavailable.

#### **Value Indicators**

- `avg_orders_per_customer` — overall purchase frequency  
- `repeat_purchase_rate` — likelihood of buying more than once  
- `pct_one_time_buyers` — share of single-purchase customers  
- `value tier distribution` — classification into Platinum/Gold/Silver/Bronze  
- `time to second purchase` — speed of customer activation  

#### **High-Value Customers**

Customers are considered high-value if they:

- Purchase again after their first order  
- Purchase quickly (short time to second purchase)  
- Exhibit higher order frequency and engagement  

---

# 📊 **Phase 1: Acquisition Quality Audit**

### **Hypothesis** - "Performance decline stems from channel mix shift—lower-quality channels scaling while high-quality channels stagnate."

### **Analytical Approach**
I evaluated customer quality by first-touch attribution channel, measuring behavioral depth (purchase frequency, activation speed, value tier) as revenue proxies.

### **Visualization:**  
![Analysis 1 - Acquisition Channel Quality](./visuals/01_Channel_Quality_trend.png)

### **Key Results**
| Channel Group          | Volume | Avg Orders | Repeat Rate | Platinum % | One-Time % | Quality Assessment |
| ---------------------- | ------ | ---------- | ----------- | ---------- | ---------- | ------------------ |
| Internal/Self-Referral | 485    | 1.32       | 20%         | 13%        | 80%        | Baseline           |
| Unattributed           | 551    | 1.34       | 19%         | 10%        | 81%        | Consistent         |
| Direct                 | 891    | 1.29       | 19%         | 10%        | 81%        | Consistent         |
| Other/Unknown          | 925    | 1.30       | 16%         | 10%        | 84%        | Slightly weaker    |
| Search (Paid/Organic)  | 1,214  | 1.25       | 16%         | 9%         | 84%        | Slightly weaker    |

### **Key Findings**

- Engagement depth is uniformly shallow across channels.
- Repeat purchase rates cluster tightly between 16 and 20%.
- Approximately 80% of customers purchase only once, regardless of acquisition source.
- Channel differences exist but are marginal relative to overall behavioral patterns.

### **Consultant's Insight**
Channel effects are marginal. The 4-percentage-point gap between "best" and "worst" channels is insignificant against the 82% one-time buyer rate across all sources.Customer behavior converges toward the same outcome independent of acquisition source.
This indicates the business is successfully acquiring customers but struggling to retain them.
The performance constraint appears post-acquisition, not in marketing mix.

>### **Judgement Call:** I initially suspected Search channel dilution due to its scale (28-31% of volume). However, cross-cohort analysis revealed channel mix remained stable—Search didn't increase disproportionately as quality declined. The deterioration pattern persisted uniformly across all sources. The problem was systemic, not channel-specific, forcing me to look post-acquisition.

### **❌ Hypothesis rejected** - Channel reallocation will not solve quality decline. The constraint lies downstream.

### **Decision - Next Hypothesis:**  - If acquisition quality is stable, cohort deterioration must occur after customers enter the lifecycle

---

# 📊 **Phase 2: Cohort Evolution Analysis**

### **Hypothesis** - "Customer behavior deteriorates across newer acquisition cohorts, indicating structural market shifts."

### **Analytical Approach**
I grouped Customers by **first purchase month** measuring economic and behavioral proxy metrics (`new_customers`,`repeat_purchase_rate`,`pct_one_time_buyers`,`value_tiers`) to observe behavioral evolution.

### **Visualization:**  
![Analysis 2 - Cohort Evolution](./visuals/02_Cohort_Evolution.png)

### **Cohort Quality Trajectory**
| Cohort   | New Customers | Repeat Rate | Avg Orders | One-Time % | Platinum+Gold % | Bronze % | Channel Mix |
| -------- | ------------- | ----------- | ---------- | ---------- | --------------- | -------- | ----------- |
| Nov 2020 | 1,481         | 29%         | 1.44       | 71%        | 36%             |   34%    | Stable      |
| Dec 2020 | 1,813         | 14%         | 1.26       | 86%        | 28%             |   42%    | Stable      |
| Jan 2021 | 772           | 6%          | 1.18       | 94%        | 24%             |   44%    | Stable      |

### **Critical Observations**
**1. Accelerating Deterioration**

 - Repeat purchase rate collapsed 79% (29% → 6%)
 - One-time buyers increased 32% (71% → 94%)
 - Average Total Orders decreased 26% (1.44 → 1.18%)

**2. Volume-Quality Inverse Correlation**

 - December: 22% volume increase, 52% repeat rate decline
 - Pattern: Scaling acquisition correlated with quality dilution

### **Consultant Insight**
Earlier cohorts demonstrated stronger engagement and value concentration, establishing a baseline of efficient acquisition.
As acquisition scaled, customer depth declined — suggesting growth shifted from quality-driven acquisition toward volume expansion. This pattern signals acquisition dilution, where newer customers enter the lifecycle with weaker long-term engagement potential.

### **Economic Implication**
If this trajectory continues:
- Future customer lifetime value (LTV) will compress.
- Growth may appear healthy through rising customer counts while retention weakens underneath.
- Revenue expansion risks masking deteriorating unit economics and rising churn exposure.

### **Phase 2 Conclusion**
### **✅ Hypothesis confirmed - Cohort quality deteriorates structurally** 
The failure occurs post-acquisition, triggered by scaling without activation infrastructure.

### **Decision - Next Hypothesis**
Since deterioration occurs after acquisition and progressively across time, then I identify where in the customer lifecycle engagement breaks down.

---
# **📊 Phase 3: Lifecycle Mechanism Diagnosis**
### **Diagnostic Objective** - Isolate the precise behavioral breakpoint where customers fail to generate value.

**Visualization:**  
![Analysis 3 - Cohort Deterioration Diagnosis](./visuals/03_repeat_purchase_rate_vs_pct_one_time_buyers.png)

### **Key Results — Lifecycle Activation**

| Cohort Date | New Customers | Repeat Purchase Rate (%) | One-Time Buyers (%) | Platinum (%) | Bronze (%) | Avg Days to 2nd Purchase | Users Within 7 Days (%) |
|-------------|---------------|-------------------------|-------------------|--------------|------------|-------------------------|------------------------|
| Nov 2020    | 1,481         | 73                      | 71                | 24           | 26         | 3.90                    | 85                     |
| Dec 2020    | 1,813         | 38                      | 86                | 16           | 35         | 3.71                    | 86                     |
| Jan 2021    | 772           | 16                      | 94                | 8            | 41         | 1.49                    | 90                     |

![Analysis 3 - Activation Speed and Coverage](./visuals/04_Activation_Speed_and_Coverage_Chart.png)

### **Root Cause Identification**
- **Activation failure as root cause:** Most customers who do repeat purchase do so quickly (within 7–30 days), but the **activation probability is low** — fewer customers enter the repeat journey.  
- **Structural deterioration:** Later cohorts contain more one-time buyers and fewer high-value customers, confirming that **cohort quality deterioration occurs early in the lifecycle**.  
- **Acquisition channels remain stable:** Channel mix shows no meaningful change, so deterioration is **not driven by marketing** but by early lifecycle activation failure. 

### Economic Implication

- Activation failure compresses future **customer lifetime value** while acquisition costs remain unchanged.  
- Apparent customer growth masks declining **unit economics**.  
- Misdiagnosing the problem as acquisition-driven could lead to **inefficient marketing spend, channel reallocations, and incorrect CAC optimization**.  
- If unresolved: margin erosion accelerates, revenue growth becomes increasingly dependent on continuous acquisition, and high churn dominates newer cohorts.

### **Customer Journey Breakdown:**

ACQUISITION → [First Purchase] → ACTIVATION WINDOW (0-30 days) → [Second Purchase] → RETENTION

Phase 1: Acquisition working (channels stable)
Phase 2: Cohort quality declining (temporal pattern identified)  
Phase 3: ACTIVATION FAILURE identified as breakpoint
           ⬇️
    94% of customers never reach second purchase
           ⬇️
    Activation infrastructure insufficient for scaled volume

#### **Phase 3 Conclusion**
#### **✅ Root cause isolated - Early-lifecycle activation failure is the primary driver**

---

# 💼 **Strategic Recommendations**
- ### **Immediate Actions (0-30 Days)**

| Initiative                      | Owner               | Investment | Success Metric          |
| ------------------------------- | ------------------- | ---------- | ----------------------- |
| **Activation Experiment**       | Retention Marketing | \$150K     | +5pp 30-day repeat rate |
| **Post-Purchase Journey Audit** | Product/UX          | 40 hrs     | Journey map completed   |
| **KPI Migration**               | Analytics           | 20 hrs     | Board reporting updated |

- ### **90-Day Strategic Shift**
From: Acquisition-volume optimization
To: Activation-efficiency optimization

---

### **🧠 Methodology & Technical Notes**
Behavioral Value Proxy Framework

Due to revenue obfuscation, I developed a behavioral LTV prediction model:

| Tier         | Behavioral Criteria               | Predictive Rationale                          |
| ------------ | --------------------------------- | --------------------------------------------- |
| **Platinum** | ≥3 orders OR 2nd purchase ≤7 days | Highest correlation with long-term engagement |
| **Gold**     | 2 orders, 2nd purchase 8-30 days  | Moderate activation, stable retention         |
| **Silver**   | 2 orders, 2nd purchase >30 days   | Delayed activation, churn risk                |
| **Bronze**   | 1 order only                      | No activation, minimal LTV                    |

### Metric Definition Consistency###
- **Phase 1 (Channel Analysis):** Full observation period, customer-level averages
- **Phase 2-3 (Cohort Analysis):** Cohort-specific (month of first purchase)

This methodological distinction explains metric variations between phases.

---

### How to Run This Analysis

1. Clone the repository:  

```bash
git clone https://github.com/Craphtr/why-are-customer-cohorts-declining-despite-stable-acquisition--a-lifecycle-diagnostic-using-GA4-data.git
```
2. Open BigQuery and link the GA4 sample dataset.

3. Run the SQL scripts in sql/ folder to create customer360 layer and cohort tables.

4. Update visualization placeholders in visuals/ folder.

5. Open README.md in GitHub to see fully rendered results.

---

### 📬 **Contact**
TechCraphters Strategic Analytics

Consultant: Jubril Davies

Portfolio Inquiries: [jubril.davies@techcraphters.com]

LinkedIn: [linkedin.com/in/jubrildavies]

This is a simulated consulting case study built using the Google Analytics 4 public dataset. The engagement scenario, stakeholder context, and business stakes are representative of enterprise analytics challenges, while all data and results are derived from publicly available sources. This format demonstrates my consulting methodology and strategic communication capabilities without claiming specific client engagements.