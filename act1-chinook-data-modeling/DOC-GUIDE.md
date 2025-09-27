
 # 📝 Beginner Data Engineer Documentation & Presentation Guide

This guide is for documenting and presenting your group’s **dimensional modeling exercise**.  
Follow the structure below, fill in your team’s work, and use it as both internal documentation and a final presentation outline.  

---

## 1. Project Overview

- **Dataset Used:**  
  *(Briefly describe the dataset and domain — e.g., Chinook music store, OULAD education dataset, or IMDb entertainment dataset.)*  

- **Goal of the Exercise:**  
  *(What was the objective? Example: transform OLTP schema into dimensional star schema for analytics.)*  
  The goal was to convert the normalized **Chinook dataset** into a dimensional model to answer the business questions given to us by group. The objective was to "consistently store efficient data that is trustable" by building a robust data pipeline that our team could rely on for analytics.

<div style="display: flex; align-items: center; gap: 10px;">
  <img src="https://i.imgur.com/0jWu4Mp.png" height="250">
  <img src="https://i.imgur.com/iGPYV5V.png" height="250">
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

## 2. Architecture & Workflow

- **Pipeline Flow:**  
  *(Diagram or describe: raw → clean → mart → BI.)* 

![DIAGRAM](https://i.imgur.com/Iznh8At.png)

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
  * The chinook datasets were already normalized so there's no normalization applied to it during the process except the standardization of the data for each table.
  * We used the naming convention for our staging with: stg_chinook_<table_name>_grp3
  *  Creation of staging tables in the CLEAN folder for the following:
        - stg_chinook_album_grp3
        - stg_chinook_artist_grp3
        - stg_chinook_customer_grp3
        - stg_chinook_genre_grp3
        - stg_chinook_invoice_line_grp3
        - stg_chinook_invoice_grp3
        - stg_chinook_tracks_grp3
    * During the cleaning stage, below are the formatting and standardization applied from raw source to the clean destionation folder:
        - Removal of leading and trailing spaces
        - Cross checking of total counts between tables from raw and cleaned tables
        - Since the data type for date column is using a timestamp but it's noticeable that there's no time indicatd, hence the change of the data type to date only using cast

- **Star Schema Design:**  
  - Fact Tables:
    * with our fact table, we joined the following tables to add all the columns that contain numerical values:
        - stg_chinook_invoice_line_grp3
        - stg_chinook_invoice_grp3
        - stg_chinook_tracks_grp3
        - stg_chinook_customer_grp3
    * The table is called: **fact_invoice_line_grp3** with the below columns:
        * invoice_id
        * customer_id
        * track_id
        * invoice_date
        * quantity
        * line_amount (multiplied the unit_price and quantity)
  - Dimension Tables: 
    * For the Dimension tables we created 7 dimension tables:
        * dim_album_grp3
            * album_id
            * album_title
            * artist_id
        * dim_artist_grp3
            * artist_id
            * artist_name
        * dim_date_grp3
            * invoice_id
            * invoice_date
            * month_num (for the purpose of easier monthly and quarterly computation)
            * month_name (optional)
            * date_year (for the purpose of yearly computation)
        * dim_genre_grp3
            * genre_id
            * genre_name
            * track_id
        * dim_invoice_grp3
            * invoice_id
            * invoice_date
            * customer_id
        * dim_track_grp3
            * track_id
            * track_name
            * album_id
            * genre_id
        * dim_customer_grp3
            * customer_id
            * country
            * invoice_id
            * support_rep_id (this is the employee id)
    **Note:** At this point we didn't use the employee table since it's already existing in the customer table. Unless the requirement will ask us to indicate the details of the employee then that'll be a different story.

- **Challenges / Tradeoffs:**  
  *(E.g., handling missing data, many-to-many joins, exploding arrays, performance considerations.)*  

---

## 4. Collaboration & Setup

- **Task Splitting:**  
  *(How the team divided ingestion, modeling, BI dashboards, documentation.)*  
Met at 8pm with Sir Myk to understand the assignment better
Decided each team member should complete the entire pipeline individually (ingestion through modeling to visualization) so everyone could experience the full process
CJ took the lead on Metabase dashboards and coordinated our BI efforts

- **Shared vs Local Work:**  
  *(Issues faced with sync conflicts, version control, DB connections, etc.)*  
Faced inconsistent raw data - different row counts for the same tables between groupmates
Scheduled Thursday 8pm meeting to brainstorm and establish single source of truth for queries
Encountered database connection issues when multiple members accessed shared ClickHouse server simultaneously


- **Best Practices Learned:**  
  *(E.g., using Git for dbt projects, naming conventions, documenting assumptions, group debugging sessions.)*  
Used personalized naming conventions (like "_nickname") to prevent conflicts
Documented assumptions to resolve data discrepancies
Held group debugging sessions during Thursday meeting
Learned to establish single source of truth early to prevent consistency issues
Coordinated pipeline execution to avoid server overload
Maintained regular check-ins to catch problems before they became blockers

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
-
- **Team Learnings:**  
  *(E.g., collaboration in shared environments, version control, importance of documentation.)*  

- **Real-World Connection:**  
  *(How this exercise relates to actual data engineering workflows in industry.)*  
Experienced common data engineering challenges like data quality issues and pipeline coordination
Applied modern data stack tools (DLT, DBT, ClickHouse, Metabase) that are widely used in industry
Learned the medallion architecture pattern that's standard in enterprise data platforms
Practiced the collaborative debugging and problem-solving approach typical in data engineering teams
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

- Keep it **5–10 minutes**, like a project walkthrough.  
- Use **diagrams, screenshots, and SQL snippets**.  
- Focus on both **technical process** and **business insights**.  
- End with your **key learnings and future improvements**.  
- For other documentation tips. Read [this](TECHNICAL-DOCS.md).

---

✅ By filling this template, your group will produce a professional-style project guide **just like real data engineers** — clear, structured, and insight-driven.
