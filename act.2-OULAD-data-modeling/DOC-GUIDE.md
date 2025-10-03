
# 📝 Dimensional Modeling Documentation & Presentation (OULAD Project)

## 1. Project Overview

* **Dataset Used:**
  Open University Learning Analytics Dataset (OULAD) [link](https://analyse.kmi.open.ac.uk/open-dataset).

* **Goal of the Exercise:**
  We built an end-to-end pipeline on the OULAD dataset using dlt for ingestion, dbt for cleaning and modeling, and Metabase for BI. The goal was to transform the normalized OLTP schema into a dimensional star schema and practice data engineering skills from ingestion to visualization.


* **Team Setup:**
  Tasks split across ingestion, cleaning, dbt modeling, visualization dashboards, and documentation. 

* **Environment Setup:**
  Local + shared environment. Work executed in **sandbox schema** with dbt jobs for cleaning and transformations.

---

## 2. Architecture & Workflow

* **Pipeline Flow:**
  `raw -> clean -> mart -> visualization (Metabase)`

* **Tools Used:**

  * Ingestion: `dlt`
  * Modeling: `dbt`
  * Visualization: `Metabase`

* **Medallion Layers:**

  * **Bronze (Raw):** Direct OULAD source ingestion
  * **Silver (Clean):** Type casting, formatting, removing invalids (`?` -> NULL, boolean conversions, deduplication)
  * **Gold (Mart):** Star schema with fact tables + dimensions

---

## 3. Modeling Process

* **Source Structure (Normalized):**
  7 original raw tables (student info, registration, student assessment, assessments, courses, VLE, student vle, ) 

* **Star Schema Design:**

  * **Fact Tables:**
 [add]
   
  * **Dimension Tables:**

    * Course, Semester, Year, Region, Gender, Age Band, IMD Band, Education, Assessment Type, Result

* **Challenges / Tradeoffs:**

  * Handling `Withdrawn` and `Fail` categories vs Pass/Distinction
  * Deciding whether to normalize at clean stage or only in mart
  * Potential snowflaking with the initial creation of highly normalized tables vs creating a star schema

---

## 4. Collaboration & Setup

* **Task Splitting (DBT Clean Stage):**

 [add]

* **Shared vs Local Work:**
  Some sync issues and need to align on schema conventions (`stg_oulad_<table>_grp3`).

* **Best Practices Learned:**

  * Use Git for dbt projects
  * Consistent naming conventions
  * Flatten where possible (example gender column -> we directly wrote Male/Female/Others instead of having another table reference)
  * Group debugging sessions helped align schema decisions

---

## 5. Business Questions & Insights

* **Main Business Question:**
  *What is the average passing percentage per course module and per semester?*

  * Formula: `Passing % = (students passed ÷ students enrolled) × 100`
  * Visualization: **Bar chart** of passing rate per module/semester

* **Sub-Questions:**

  1. Factors influencing completion rate (final_result): disability, region, age band, IMD band, highest education.
  2. Effect of number of semesters registered on completion rate.
  3. Correlation between submission type (`is_banked`) and test scores.
  4. Impact of registration/unregistration dates on performance.

* **Key Insights (early):**

  * `Withdrawn` counts are high in some regions and lower-education bands.
  * Curriculum developers can focus on reducing Fail + Withdrawn rather than Pass/Distinction.

---

## 6. Key Learnings

* **Technical:**

  * dbt staging, casting, and building dimension/fact tables
  * SQL joins + aggregation for BI questions
  * Handling missing/boolean conversions

* **Team:**

  * Collaboration in shared schema
  * Documenting transformations
  * Deciding tradeoffs: normalize early vs in mart

* **Real-World Connection:**
  Mimics industry medallion architecture: raw ingestion → clean data → BI-ready mart.

---

## 7. Future Improvements

* More testing/validation in dbt
* Optimize large tables (`student_vle` ~10M rows)
* Automate dashboards for different stakeholders (Curriculum Dev, Admission Head)
* Generalize pipeline for other education datasets

---

## 📢 Presentation Tips

* 5–10 min walkthrough with **ERD diagrams + SQL snippets + dashboards**
* Start with **business problem → model → insights**
* Highlight **failures/withdrawals trend** for stakeholder relevance
* End with **learnings + future improvements**


[add
- ingestion process, using csv files ]

