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
plain

**PHASE 1: Acquisition Quality Audit**

    ⬇️ Ruled out: Channel-driven degradation

**PHASE 2: Cohort Evolution Analysis**  

    ⬇️ Confirmed: Temporal quality deterioration

**PHASE 3: Lifecycle Mechanism Diagnosis**

    ✅ Isolated: Early activation failure as root cause


### **Executive KPI Snapshot**

| Metric                                            | Finding           | Risk Level  | Strategic Implication                        |
| ------------------------------------------------- | --------------------------- | ----------- | -------------------------------------------- |
| **Activation Rate** (2nd purchase within 30 days) | 16% (down from 73%)         | 🔴 Critical | 84% of customers never generate repeat value |
| **Cohort Quality Trend**                          | Declining 34% per month     | 🔴 Critical | Newer customers structurally less valuable   |
| **Channel Performance**                           | Uniformly poor              | 🟡 Moderate | No "good" channel to reallocate toward       |
| **High-Value Customer Concentration**             | 8% Platinum (down from 24%) | 🔴 Critical | Revenue concentration in shrinking base      |

### **Final Diagnosis**
Customer quality decline is not an acquisition problem. The primary failure occurs **after acquisition**, where customers increasingly fail to transition beyond their first purchase. In this business scenario, the 40% acquisition increase should be conditionally declined pending resolution of early-lifecycle retention failure.

### **Recommendation**
**Immediate:** Halt acquisition scaling. Deploy retention/activation experiments before increasing top-of-funnel spend.

**90-Day:** Implement activation-based campaign optimization.

**Ongoing:** Shift KPIs from "customers acquired" to "activations achieved."

---

#### **Technical Architecture**
**Data Stack:** BigQuery (transformation) → Python (visualization)

**Source:** Google Analytics 4 Obfuscated Ecommerce Dataset (BigQuery Public Data)


**Technical Note:** All SQL code used production-grade patterns: modular CTEs, incremental logic, and extensible schema design. This architecture mirrors how I structure client engagements for scalability.

---

# 📊 **Phase 1: Acquisition Quality Audit**

### **Hypothesis**
"Performance decline stems from channel mix shift—lower-quality channels scaling while high-quality channels stagnate."

#### **Analytical Approach**
I evaluated customer quality by first-touch attribution channel, measuring behavioral depth (purchase frequency, activation speed, value tier) as revenue proxies.

### **Visualization:**  
![Analysis 1 - Acquisition Channel Quality](./visuals/01_Channel_Quality_trend.png)

#### **Key Results**
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

#### **Consultant's Insight**
Channel effects are marginal. The 4-percentage-point gap between "best" and "worst" channels is insignificant against the 82% one-time buyer rate across all sources.Customer behavior converges toward the same outcome independent of acquisition source.
This indicates the business is successfully acquiring customers but struggling to retain them.
The performance constraint appears post-acquisition, not in marketing mix.

>#### **Judgement Call:** I initially suspected Search channel dilution due to its scale (28-31% of volume). However, cross-cohort analysis revealed channel mix remained stable—Search didn't increase disproportionately as quality declined. The deterioration pattern persisted uniformly across all sources. The problem was systemic, not channel-specific, forcing me to look post-acquisition.

#### **❌ Hypothesis rejected** 
Channel reallocation will not solve quality decline. The constraint lies downstream.

### **Decision - Next Hypothesis:**  
If acquisition quality is stable, cohort deterioration must occur after customers enter the lifecycle

Next Step: Analyze how customer cohorts evolve over time.

# 📊 **Phase 2: Cohort Evolution Analysis**

### **Hypothesis**
"Customer behavior deteriorates across newer acquisition cohorts, indicating structural market shifts."

#### **Analytical Approach**
I grouped Customers by **first purchase month** measuring economic and behavioral proxy metrics (`new_customers`,`repeat_purchase_rate`,`pct_one_time_buyers`,`value_tiers`) to observe behavioral evolution.

#### **Visualization:**  
![Analysis 2 - Cohort Evolution](./visuals/02_Cohort_Evolution.png)

#### **Cohort Quality Trajectory**
| Cohort   | New Customers | Repeat Rate | Avg Orders | One-Time % | Platinum+Gold % | Bronze % | Channel Mix |
| -------- | ------------- | ----------- | ---------- | ---------- | --------------- | -------- | ----------- |
| Nov 2020 | 1,481         | 29%         | 1.44       | 71%        | 36%             |   34%    | Stable      |
| Dec 2020 | 1,813         | 14%         | 1.26       | 86%        | 28%             |   42%    | Stable      |
| Jan 2021 | 772           | 6%          | 1.18       | 94%        | 24%             |   44%    | Stable      |

#### **Critical Observations**
**1. Accelerating Deterioration**

 - Repeat purchase rate collapsed 79% (29% → 6%)
 - One-time buyers increased 32% (71% → 94%)
 - Average Total Orders decreased 26% (1.44 → 1.18%)

**2. Volume-Quality Inverse Correlation**

 - December: 22% volume increase, 52% repeat rate decline
 - Pattern: Scaling acquisition correlated with quality dilution

#### **Consultant Insight**
Earlier cohorts demonstrated stronger engagement and value concentration, establishing a baseline of efficient acquisition.
As acquisition scaled, customer depth declined — suggesting growth shifted from quality-driven acquisition toward volume expansion. This pattern signals acquisition dilution, where newer customers enter the lifecycle with weaker long-term engagement potential.

#### **Economic Implication**
If this trajectory continues:
- Future customer lifetime value (LTV) will compress.
- Growth may appear healthy through rising customer counts while retention weakens underneath.
- Revenue expansion risks masking deteriorating unit economics and rising churn exposure.

#### **Phase 2 Conclusion**
#### **✅ Hypothesis confirmed - Cohort quality deteriorates structurally** 
The failure occurs post-acquisition, triggered by scaling without activation infrastructure.

#### **Decision - Next Hypothesis**
Since deterioration occurs after acquisition and progressively across time, then I identify where in the customer lifecycle engagement breaks down.

Next Step: Diagnose lifecycle-stage friction driving retention collapse.

# **📊 Phase 3: Lifecycle Mechanism Diagnosis**
#### **Diagnostic Objective**
Isolate the precise behavioral breakpoint where customers fail to generate value.

#### **Root Cause Identification**





#### **Customer Journey Breakdown:**

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
