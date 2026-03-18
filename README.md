# 📊 E-Commerce Customer & Revenue Analytics (SQL Project)

## 🚀 Overview
This project analyzes a large-scale **E-commerce dataset (1M+ records)** to extract key business insights related to customer behavior, revenue trends, and retention.

The goal of this project is to simulate real-world data analysis using SQL by calculating important business KPIs and understanding customer patterns.

---

## 🛠️ Tools & Technologies
- SQL (MySQL)
- Window Functions
- Common Table Expressions (CTEs)
- Joins & Subqueries
- Aggregate Functions

---

## 📁 Dataset
- Source: Kaggle E-commerce dataset  
- Size: 10L+ records  
- Tables Used:
  - `orders`
  - `order_items`
  - `users`
  - `products`
  - `events`
   - `reviews`
---

## 📌 Key Business Questions Solved

### 🔹 1. Monthly Revenue & Average Order Value (AOV)
- Calculated total revenue per month
- Derived **AOV = Total Revenue / Total Orders**

---

### 🔹 2. Average Items Per Order
- Measured average number of products purchased per order

---

### 🔹 3. Revenue Contribution by Category
- Identified top-performing product categories
- Used **window functions** to calculate revenue percentage

---

### 🔹 4. Customer Revenue Analysis
- Identified top customers contributing to revenue
- Calculated revenue percentage per user

---

### 🔹 5. Repeat Purchase Rate (RPR)
- Defined repeat customers as users with ≥2 orders
- Calculated:
  
---

### 🔹 6. Customer Segmentation (Repeat vs One-time)
- Segmented users using **CASE WHEN**
- Compared revenue contribution between segments

---

### 🔹 7. Conversion Rate Analysis
- Measured:
- View → Purchase conversion
- Calculated both:
- Event-level conversion
- User-level conversion

---

### 🔹 8. Cohort Analysis (Retention)
- Grouped users by signup month
- Tracked how many users returned in future months
- Calculated **retention percentage**

---

### 🔹 9. Product Ranking
- Ranked products based on total revenue using **DENSE_RANK()**

---

## 📊 Key Insights

- 📈 ~18% Repeat Purchase Rate (RPR)
- 🔄 ~26% Conversion Rate
- 💰 Revenue heavily driven by top product categories
- 👥 Repeat customers contributed significantly higher revenue than one-time users
- 📉 Retention decreases over time across cohorts

---

## 🧠 Key Learnings

- Writing optimized SQL queries for large datasets
- Using **window functions** for percentage and ranking calculations
- Applying **CTEs** for better query readability
- Understanding real-world business metrics like AOV, RPR, and retention
- Performing **cohort analysis** using SQL

---
