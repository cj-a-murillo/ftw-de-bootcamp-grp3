# 📝 Beginner Data Engineer Documentation & Presentation Guide

This guide is for documenting and presenting your group’s **dimensional modeling exercise**.  
Follow the structure below, fill in your team’s work, and use it as both internal documentation and a final presentation outline.  

---

## 1. Project Overview

- **Dataset Used:**  
  *(Briefly describe the dataset and domain — e.g., Chinook music store, OULAD education dataset, or IMDb entertainment dataset.)*  
  [Dataset Link](https://raw.githubusercontent.com/lerocha/chinook-database/master/ChinookDatabase/DataSources/Chinook_PostgreSql.sql)
  
- **Goal of the Exercise:**  
  *(What was the objective? Example: transform OLTP schema into dimensional star schema for analytics.)*  
  The goal was to convert the normalized Chinook dataset into a dimensional model to answer the business questions given to us by group. The objective was to "consistently store efficient data that is trustable" by building a robust data pipeline that our team could rely on for analytics.
  
- **Team Setup:**  
  *(State if you worked individually, as a group, or both. Mention collaboration style.)*  
  We worked as a collaborative group, with each team member taking responsibility for their own pipeline components while contributing to the overall project. Our collaboration style involved individual ownership of pipeline sections - each of us personalized our naming conventions (like changing the dataset = chinook_[nickname] using our nicknames to name pipeline) while working toward shared business objectives. We coordinated our work to ensure compatibility and could learn from each other's approaches.
  
- **Environment Setup:**  
  *(Describe your environment — local vs remote, individual vs shared instances. Example: Docker containers on a shared VM + local laptops.)*  
  We used a shared remote environment that allowed us to collaborate effectively:

  - Shared ClickHouse server at IP 54.87.106.52 where all team members could access the same infrastructure
  - Individual credentials (each of us had our own ftw_user accounts) to maintain separation while sharing resources
  - Docker containers for running DLT and DBT jobs, ensuring consistency across our team's development environments
  - Local DBeaver instances on our individual laptops for database management and SQL development
  - Shared Metabase instance for collaborative data visualization and dashboard creation
  - Hybrid approach - we could work locally on our laptops while executing jobs on the shared remote infrastructure

---

## 2. Architecture & Workflow

- **Pipeline Flow:**  
  *(Diagram or describe: raw → clean → mart → BI.)*  

- **Tools Used:**  
  - Ingestion: `dlt`  
  - Modeling: `dbt`  
  - Visualization: `Metabase`  
  *(Add others if used.)*  

- **Medallion Architecture Application:**  
  - **Bronze (Raw):** Initial ingestion of source data  
  - **Silver (Clean):** Cleaning, type casting, handling missing values  
  - **Gold (Mart):** Business-ready star schema for BI  

*(Insert diagram or screenshot here if possible.)*  

---

## 3. Modeling Process

- **Source Structure (Normalized):**  
  *(Describe how the original tables were structured — 3NF, relationships, etc.)*  

- **Star Schema Design:**  
  - Fact Tables: *(e.g., FactSales, FactAssessment, FactRatings)*  
  - Dimension Tables: *(e.g., Customer, Date, Genre, Student, Demographics, Title, Person)*  

- **Challenges / Tradeoffs:**  
  *(E.g., handling missing data, many-to-many joins, exploding arrays, performance considerations.)*  

---

## 4. Collaboration & Setup

- **Task Splitting:**  
  *(How the team divided ingestion, modeling, BI dashboards, documentation.)*  

- **Shared vs Local Work:**  
  *(Issues faced with sync conflicts, version control, DB connections, etc.)*  

- **Best Practices Learned:**  
  *(E.g., using Git for dbt projects, naming conventions, documenting assumptions, group debugging sessions.)*  

---

## 5. Business Questions & Insights

- **Business Questions Explored:**  
  1. *(Example: Who are the top customers by revenue?)*  
  2. *(Example: What factors contribute to student dropout?)*  
  3. *(Example: Which genres/actors perform best in ratings?)*  

- **Dashboards / Queries:**  
  *(Add screenshots, SQL snippets, or summaries of dashboards created in Metabase.)*  

- **Key Insights:**  
  - *(Highlight 1–2 interesting findings. Example: “Rock was the top genre in North America, while Latin genres dominated in South America.”)*  

---

## 6. Key Learnings

- **Technical Learnings:**  
  *(E.g., SQL joins, window functions, dbt builds/tests, schema design.)*  

- **Team Learnings:**  
  *(E.g., collaboration in shared environments, version control, importance of documentation.)*  

- **Real-World Connection:**  
  *(How this exercise relates to actual data engineering workflows in industry.)*  

---

## 7. Future Improvements

- **Next Steps with More Time:**  
  *(E.g., add orchestration with Airflow/Prefect, implement testing, optimize queries, handle larger datasets.)*  

- **Generalization:**  
  *(How this workflow could be applied to other datasets or business domains.)*  

---

## 📢 Presentation Tips

- Keep it **5–10 minutes**, like a project walkthrough.  
- Use **diagrams, screenshots, and SQL snippets**.  
- Focus on both **technical process** and **business insights**.  
- End with your **key learnings and future improvements**.  
- For other documentation tips. Read [this](TECHNICAL-DOCS.md).

---

✅ By filling this template, your group will produce a professional-style project guide **just like real data engineers** — clear, structured, and insight-driven.
