
 # 📝 Beginner Data Engineer Documentation & Presentation Guide

This guide is for documenting and presenting your group’s **dimensional modeling exercise**.  
Follow the structure below, fill in your team’s work, and use it as both internal documentation and a final presentation outline.  

---

## 1. Project Overview

- **Dataset Used:**  
  *(Briefly describe the dataset and domain — e.g., Chinook music store, OULAD education dataset, or IMDb entertainment dataset.)*  

- **Goal of the Exercise:**  
  *(What was the objective? Example: transform OLTP schema into dimensional star schema for analytics.)*  
  The goal was to convert the normalized **Chinook dataset** into a dimensional model to answer the business questions given to us by group. 
  
  The objective was to "consistently store efficient data that is trustable" by building a robust data pipeline that our team could rely on for analytics.

<div style="display: flex; align-items: center; gap: 10px;">
  <img src="https://i.imgur.com/iGPYV5V.png" height="250">
  <img src="https://i.imgur.com/0jWu4Mp.png" height="250">
</div>


- **Team Setup:**  
  *(State if you worked individually, as a group, or both. Mention collaboration style.)*  
  We worked as a collaborative group, with each team member taking responsibility for their own pipeline components while contributing to the overall project. 
    - Used personalized naming conventions (like `dataset = chinook_[nickname]`) for individual ownership
    - Coordinated work to ensure compatibility across different pipeline implementations
    - Shared learning and troubleshooting approaches while working toward shared business objectives

- **Environment Setup:**  
  *(Describe your environment — local vs remote, individual vs shared instances. Example: Docker containers on a shared VM + local laptops.)*  
  - We used a shared remote environment that allowed us to collaborate effectively:

  - Shared ClickHouse server at IP 54.87.106.52 where all team members could access the same infrastructure
  - Individual credentials (each of us had our own ftw_user accounts) to maintain separation while sharing resources
  - Docker containers for running DLT and DBT jobs, ensuring consistency across our team's development environments
  - Local DBeaver instances on our individual laptops for database management and SQL development
  - Shared Metabase instance for collaborative data visualization and dashboard creation
  - Hybrid approach - we could work locally on our laptops while executing jobs on the shared remote infrastructure


---

- **Tools Used:**  
  - Ingestion: `dlt`  
DLT: Data Loading Tool (Extra and Load)
Importance of changing data_set value on re-runs:
Prevents overwriting existing raw data.
Ensures that each ingestion run is captured as a separate dataset version, which helps in data lineage and traceability.
Handling schema changes in source data requires careful versioning to avoid breaking downstream models.
Automating ingestion with dlt reduces manual intervention and ensures reproducibility of pipelines.
@dlt.resource(write_disposition="append", name="artists_lacopia")
def artists(): Here name value should be changed. Not changing this will result in database error. 

  - Modeling: `dbt`  
  - dbt (Data Build Tool) allows transformations in SQL while maintaining modularity with models, seeds, snapshots, and tests.

It encourages the following: 
Version control for transformations.
Testing of models (e.g., uniqueness, not null).
Documentation of models and lineage.
The combination of dlt + dbt ensures that raw data can be ingested first and then consistently transformed into usable analytical models.
Dependency management through ref() ensures that models are built in the correct order.
Incorrect naming of sources in the cleaning of data will result in these errors.
“Database Error in model stg_chinook__fact_invoice_line_rizza (models/clean/stg_chinook__fact_invoice_line_rizza.sql) HTTPDriver for http://54.87.106.52:8123 received ClickHouse error code 62 Code: 62. DB::Exception: Syntax error: failed at position 1629 (end of query) (line 60, col 43): ;”

The team agreed to try out first the exercise hands on. Then we check if we have the same results on the questions given. 

  - Visualization: `Metabase`  
Metabase provides a simple, user-friendly interface to explore and visualize data.
Helps translate business questions into dashboards quickly without writing complex queries each time.
Supports drill-downs andinteractive charts, which enhances decision-making.
Acts as a bridge between technical data pipelines and business stakeholders.
Metabase is for end users use. 

Key Learnings: 

Proper orchestration is key: ingestion (dlt) → modeling (dbt) → visualization (Metabase).
Version control and dataset management are crucial for reproducibility and avoiding data loss.
Automated pipelines reduce manual errors and improve confidence in downstream analyses.
Documentation at every step is important for team collaboration and handover.
Document every error encountered and share with the team. As well as the fix if you were able to fix the error. 


  *(Add others if used.)*  

 **Medallion Architecture Application:**  
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
    - Met at 8pm with Sir Myk to understand the assignment better
    - Decided each team member should complete the entire pipeline individually (ingestion through modeling to visualization) so everyone could experience the full process
    - CJ took the lead on Metabase dashboards and coordinated our BI efforts

- **Shared vs Local Work:**  
  *(Issues faced with sync conflicts, version control, DB connections, etc.)*  
    - Faced inconsistent raw data - different row counts for the same tables between groupmates
    - Scheduled Thursday 8pm meeting to brainstorm and establish single source of truth for queries
    - Encountered database connection issues when multiple members accessed shared ClickHouse server simultaneously


- **Best Practices Learned:**  
  *(E.g., using Git for dbt projects, naming conventions, documenting assumptions, group debugging sessions.)*  
    - Used personalized naming conventions (like "_nickname") to prevent conflicts
    - Documented assumptions to resolve data discrepancies
    - Held group debugging sessions during Thursday meeting
    - Learned to establish single source of truth early to prevent consistency issues
    - Coordinated pipeline execution to avoid server overload
    - Maintained regular check-ins to catch problems before they became blockers

---

## 5. Business Questions & Insights

- **Business Questions Explored:**  
    1. Which music genres generate the most revenue in each country?
    2. How can we group customers into tiers (High, Medium, Low) based on their total spend - how many customers fall into each tier?
    3. How has revenue trended month-by-month over the last 2 years?
    4. Which sales employees generated the most revenue by quarter?
    5. What are the top 20 tracks by total units sold, and which albums/artists do they belong to?
    6. Do average unit prices differ across countries or regions? 

- **Dashboards / Queries:**  
  *(Add screenshots, SQL snippets, or summaries of dashboards created in Metabase.)*  
  <img src="https://i.imgur.com/uV8fiFW.png" height="550">



- **Key Insights:**  
  - *(Highlight 1–2 interesting findings. Example: “Rock was the top genre in North America, while Latin genres dominated in South America.”)*  
    **Rock** dominates globally: Rock music generates the highest revenue across most countries, with the USA leading at $180 in total revenue, followed by Brazil and France, showing rock's universal appeal in the music market.
    <img src="https://i.imgur.com/5MnNGPi.png" height="200">

    **Customer spending** is highly concentrated: The majority of customers (59 total) fall into the Low spending tier, with only a small segment in High spending, indicating potential opportunities for targeted marketing to convert medium spenders and retain high-value customers.
    


---

## 6. Key Learnings

- **Technical Learnings:**  
  *(E.g., SQL joins, window functions, dbt builds/tests, schema design.)*  

- **Team Learnings:**  
  *(E.g., collaboration in shared environments, version control, importance of documentation.)*  

- **Real-World Connection:**  
  *(How this exercise relates to actual data engineering workflows in industry.)*  
    - Experienced common data engineering challenges like data quality issues and pipeline coordination
    - Applied modern data stack tools (DLT, DBT, ClickHouse, Metabase) that are widely used in industry
    - Practiced the collaborative debugging and problem-solving approach typical in data engineering teams
---

## 7. Future Improvements

- **Next Steps with More Time:**  
  *(E.g., add orchestration with Airflow/Prefect, implement testing, optimize queries, handle larger datasets.)*  
    - 

- **Generalization:**  
  *(How this workflow could be applied to other datasets or business domains.)*  
    - Add data quality tests & validation in DBT
    - Optimize ClickHouse queries & tables for large datasets
    - Set up Git workflow for collaborative DBT development
---

## 📢 Presentation Tips

- Keep it **5–10 minutes-**, like a project walkthrough.  
- Use **diagrams, screenshots, and SQL snippets**.  
- Focus on both **technical process** and **business insights**.  
- End with your **key learnings and future improvements**.  
- For other documentation tips. Read [this](TECHNICAL-DOCS.md).

---

✅ By filling this template, your group will produce a professional-style project guide **just like real data engineers** — clear, structured, and insight-driven.
