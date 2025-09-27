
 # 📝 Chinook Dataset Modeling
 
[Metabase Visualization](https://ftw.dataengineering.ph/public/dashboard/b35ade31-47eb-4394-84be-9acb1d11f85e)
## 1. Project Overview

- **Dataset Used:**   

    - The Chinook database is a sample digital music store with 11 interconnected tables covering artists, albums, tracks, genres, customers, employees, invoices, and invoice lines. 
    - It models  music catalog management, customer transactions, and business operations, similar to platforms like iTunes or Spotify.

# Chinook Database Schema Overview

## Table Structure

| Table Name | Primary Key | Key Columns | Description |
|------------|-------------|-------------|-------------|
| **Artist** | ArtistId | ArtistId, Name | Music artists/bands |
| **Album** | AlbumId | AlbumId, Title, ArtistId | Music albums |
| **Track** | TrackId | TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice | Individual songs/tracks |
| **Genre** | GenreId | GenreId, Name | Music genres (Rock, Jazz, etc.) |
| **MediaType** | MediaTypeId | MediaTypeId, Name | File formats (MP3, AAC, etc.) |
| **Playlist** | PlaylistId | PlaylistId, Name | User-created playlists |
| **PlaylistTrack** | PlaylistId, TrackId | PlaylistId, TrackId | Many-to-many junction table |
| **Customer** | CustomerId | CustomerId, FirstName, LastName, Company, Address, City, State, Country, PostalCode, Phone, Fax, Email, SupportRepId | Store customers |
| **Employee** | EmployeeId | EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email | Company employees |
| **Invoice** | InvoiceId | InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total | Customer purchase orders |
| **InvoiceLine** | InvoiceLineId | InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity | Individual items in purchases |

- **Dataset number of Rows** 
  - **Artists**: 275 records
  - **Albums**: 347 records  
  - **Tracks**: 3,503 records
  - **Customers**: 59 records
  - **Employees**: 8 records
  - **Invoices**: 412 records
  - **InvoiceLines**: 2,240 records
  - **Genres**: 25 records
  - **MediaTypes**: 5 records
  - **Playlists**: 18 records
  - **PlaylistTrack**: 8,715 records

- **Goal of the Exercise:**  
  *(What was the objective? Example: transform OLTP schema into dimensional star schema for analytics.)*  
    - The goal was to convert the normalized **Chinook dataset** into a dimensional model to answer the business questions given to us by group. 
  
    - The objective was to "consistently store efficient data that is trustable" by building a robust data pipeline that our team could rely on for analytics.

<div style="display: flex; align-items: center; gap: 10px;">
  <img src="https://i.imgur.com/iGPYV5V.png" height="250">
  <img src="https://i.imgur.com/0jWu4Mp.png" height="250">
</div>


- **Team Setup:**  
  *(State if you worked individually, as a group, or both. Mention collaboration style.)*  
    - We worked as a collaborative group, with each team member taking responsibility for their own pipeline components while contributing to the overall project. 
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

  
<img width="1038" height="467" alt="image" src="https://github.com/user-attachments/assets/65a6810b-8c01-4de4-9df3-87f75a49c518" />


---
## 2. Tools
- **Tools Used:**
  - Ingestion: `dlt`
    [![dltHub](https://img.shields.io/badge/dltHub-FF6F00?style=for-the-badge&logo=databricks&logoColor=white)](https://dlthub.com/)
 
DLT: Data Loading Tool (Extra and Load)
Importance of changing data_set value on re-runs:
Prevents overwriting existing raw data.
Ensures that each ingestion run is captured as a separate dataset version, which helps in data lineage and traceability.
Handling schema changes in source data requires careful versioning to avoid breaking downstream models.
Automating ingestion with dlt reduces manual intervention and ensures reproducibility of pipelines.
@dlt.resource(write_disposition="append", name="artists_lacopia")
def artists(): Here name value should be changed. Not changing this will result in database error. 

  - Modeling: `dbt`
    [![dltHub](https://img.shields.io/badge/dltHub-FF6F00?style=for-the-badge&logo=databricks&logoColor=white)](https://dlthub.com/)
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
   [![Metabase](https://img.shields.io/badge/Metabase-509EE3?style=for-the-badge&logo=metabase&logoColor=white)](https://www.metabase.com/)
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

<img width="807" height="827" alt="image" src="https://github.com/user-attachments/assets/2f7a2219-92f5-4316-8015-f211c5211bed" />

- **Source Structure (Normalized):**  
  *(Describe how the original tables were structured — 3NF, relationships, etc.)*
  * The chinook datasets were already normalized so there's no normalization applied to it during the process except the standardization of the data for each table.
  * We used the naming convention for our staging with: stg_chinook_<table_name>_grp3
  *  Creation of staging tables in the CLEAN folder for the following:
        ```
        - stg_chinook_album_grp3
        - stg_chinook_artist_grp3
        - stg_chinook_customer_grp3
        - stg_chinook_genre_grp3
        - stg_chinook_invoice_line_grp3
        - stg_chinook_invoice_grp3
        - stg_chinook_tracks_grp3
        ```
    * During the cleaning stage, below are the formatting and standardization applied from raw source to the clean destionation folder:
        - Removal of leading and trailing spaces
        - Cross checking of total counts between tables from raw and cleaned tables
        - Since the data type for date column is using a timestamp but it's noticeable that there's no time indicatd, hence the change of the data type to date only using cast

- **Star Schema Design:**  
  - Fact Tables:
    * with our fact table, we joined the following tables to add all the columns that contain numerical values:
        ```
        - stg_chinook_invoice_line_grp3
        - stg_chinook_invoice_grp3
        - stg_chinook_tracks_grp3
        - stg_chinook_customer_grp3
        ```
    * The table is called: **fact_invoice_line_grp3** with the below columns:
        ```
        * invoice_id
        * customer_id
        * track_id
        * invoice_date
        * quantity
        * line_amount (multiplied the unit_price and quantity)
        ```
  - Dimension Tables: 
    * For the Dimension tables we created 7 dimension tables:
        ```
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
            * month_name (optional: easier to use when presenting in metabase)
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
        ```
    **Note:** At this point we didn't use the employee table since it's already existing in the customer table. Unless the requirement will ask us to indicate the details of the employee then that'll be a different story.

    <img width="555" height="611" alt="image" src="https://github.com/user-attachments/assets/34c17146-919a-4409-9b12-f0f1d26182f6" />


- **Challenges / Tradeoffs:**  
  *(E.g., handling missing data, many-to-many joins, exploding arrays, performance considerations.)*  

  1. Row counts differ when we check the tables from each member. 
        - Reason is that when we relood the DLT, it appends new data regardless if it's a duplicate entries. 
        - Solution: 
            * Deleted all the tables created previously.
            * Changed the data set name 
            * Temporarily enabled the dev_mode to True.
            * Decided to run once the dlt to make sure the data consistency being loaded in our raw tables.
    2. Slowness of the server
        - Given that we have different users updating on the same server, hence it slows down a bit the production of our processing, but so far it is still manageable.
    3. Since each of us did the whole process from start to finish, it's questionable that we have different results of computation when we did the exercises especially on the part of identifying the monthly sales trend, employees performance quarterly. But most importantly, we were able to understand more the process of how the pipelines work, how to debug the errors we encountered.

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
    - <img src="https://i.imgur.com/5MnNGPi.png" height="200">

    **Customer spending** is highly concentrated: The majority of customers (59 total) fall into the Low spending tier, with only a small segment in High spending, indicating potential opportunities for targeted marketing to convert medium spenders and retain high-value customers.
    - <img src="https://i.imgur.com/WwFSLjA.png" height="200">
    


---

## 6. Key Learnings

- **Technical Learnings:**  
  *(E.g., SQL joins, window functions, dbt builds/tests, schema design.)*  
    - Discovered the importance of establishing single source of truth (SST) early to prevent data inconsistencies across team members
    - Learned that shared infrastructure requires coordination to avoid conflicts 

- **Team Learnings:**  
  *(E.g., collaboration in shared environments, version control, importance of documentation.)*  
    - Gained hands-on experience with DBT transformations 
    - Practiced dimensional modeling by creating fact and dimension tables 
    
- **Real-World Connection:**  
  *(How this exercise relates to actual data engineering workflows in industry.)*  
    - Experienced common data engineering challenges like data quality issues and pipeline coordination
    - Applied modern data stack tools (DLT, DBT, ClickHouse, Metabase) that are widely used in industry
    - Practiced the collaborative debugging and problem-solving approach typical in data engineering teams
---

## 7. Future Improvements

- **Next Steps with More Time:**  
  *(E.g., add orchestration with Airflow/Prefect, implement testing, optimize queries, handle larger datasets.)*  
    - Add data quality tests & validation in DBT
    - Improve normalization, and data cleaning techniques
    - Optimize ClickHouse queries & tables for large datasets
    - Set up Git workflow for collaborative DBT development

- **Generalization:**  
  *(How this workflow could be applied to other datasets or business domains.)*  
    - The dockerized DLT/DBT approach ensures consistency across different business domains and can be templated for similar star schema designs
   
---

## 📢 Presentation Tips

- Keep it **5–10 minutes-**, like a project walkthrough.  
- Use **diagrams, screenshots, and SQL snippets**.  
- Focus on both **technical process** and **business insights**.  
- End with your **key learnings and future improvements**.  
- For other documentation tips. Read [this](TECHNICAL-DOCS.md).

---

✅ By filling this template, your group will produce a professional-style project guide **just like real data engineers** — clear, structured, and insight-driven.
