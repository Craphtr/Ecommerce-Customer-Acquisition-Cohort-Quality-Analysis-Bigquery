# 🟠 E-commerce Customer Acquisition and Cohort Quality Analysis - A Case Study using GA4 - Bigquery

**Addressing the common problem of deteriorating Cohort Quality faced by Ecommerce Companies**

---

## 🚀 Dashboard Cover: Key Cohort Metrics

| KPI | Metric Description | Badge |
|-----|--------|-------|
| 📊 Average days to 2nd purchase | Measures activation speed — how quickly new customers become repeat buyers after first purchase. Lower = healthier onboarding and engagement. | ![Days to 2nd purchase](https://img.shields.io/badge/Days%20to%202nd%20purchase-3.03%25-blue) |
| 🔄 Repeat Purchase Rate | Percentage of customers who purchase more than once. Primary indicator of early retention and cohort health. | ![Repeat Purchase Rate](https://img.shields.io/badge/Repeat%20Rate-42%25-green) |
| 🏆 Percentage of One-time Buyers | Share of customers who never return after first purchase. Direct signal of activation failure and revenue leakage. | ![One-time Buyers](https://img.shields.io/badge/One%20buyers-83.7%25-lightgrey) |
| 🥇 Users Activated Within 7 days | Portion of customers making a second purchase within one week — measures strong early engagement momentum. | ![Users within 7 days](https://img.shields.io/badge/Within%207%20days-87%25-yellow) |
| ⚪ Users Activated Within 30 days | Coverage of successful activation window; shows whether customers eventually convert even if not immediately | ![Users within 30 days](https://img.shields.io/badge/Within%2030%20days-97%25-silver) |
| 🟤 High-Value Customer Share | Percentage of customers reaching high behavioral value tiers based on purchase frequency and engagement. Indicates cohort quality | ![High-Value Tiers](https://img.shields.io/badge/Platinum%20Gold-30.3%25-brown) |

> 💡 Tip: Replace the badge numbers with your **actual calculated cohort metrics**.

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
