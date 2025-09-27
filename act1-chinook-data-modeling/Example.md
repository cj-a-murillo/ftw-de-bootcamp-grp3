
# ✅ Successful ETL & Transform Run (Docker + dlt + dbt)

### 1. Start Core Services

```bash
docker compose --profile core --compatibility up -d
```

**Result:**

* ✔ `clickhouse` → Healthy
* ✔ `metabase` → Running
* ✔ `chinook_postgres` → Running
* ✔ `chinook_fetch` → Exited (expected after fetching seed data)

---

### 2. Verify Containers

```bash
docker ps
```

**Active Containers:**

* `clickhouse/clickhouse-server:23.12` → Healthy
* `metabase/metabase:latest` → Running on port **3001**
* `postgres:14-alpine` → Healthy (Chinook DB)

---

### 3. Run dlt Pipeline

```bash
docker compose --profile jobs run --rm dlt python extract-loads/01-dlt-mpg-pipeline.py
```

**Output:**

```
Fetching and loading...
records loaded: Pipeline 01-dlt-mpg-pipeline load step completed in 0.05 seconds
1 load package(s) were loaded to destination clickhouse and into dataset autompg
The clickhouse destination used clickhouse://ftw_user:***@clickhouse:9000/raw location to store data
Load package ... is LOADED and contains no failed jobs
```

✔ Data successfully ingested into **ClickHouse → dataset `autompg`**.

---

### 4. Run dbt Transformations

```bash
docker compose --profile jobs run --rm \
  -w /workdir/transforms/01_mpg \
  dbt build --profiles-dir . --target local
```

**Output:**

```
1 of 2 OK created sql table model `clean`.`mpg_standardized` 
2 of 2 OK created sql view model `mart`.`cylinders_by_origin` 
Completed successfully
Done. PASS=2 WARN=0 ERROR=0 SKIP=0 TOTAL=2
```

✔ Transformations executed:

* **Table** → `clean.mpg_standardized`
* **View** → `mart.cylinders_by_origin`

---

### 🎉 End-to-End Workflow Status

* **Docker core services** ✅
* **dlt ingestion pipeline** ✅
* **dbt transformations** ✅
* **No errors, no warnings** 🚀
