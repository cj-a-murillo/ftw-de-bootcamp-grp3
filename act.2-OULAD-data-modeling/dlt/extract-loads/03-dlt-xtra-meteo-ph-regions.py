# pipelines/dlt-meteo-ph-regions.py
import dlt
import requests
from datetime import date, timedelta
from requests.adapters import HTTPAdapter, Retry

# Representative lat/lon per region (region capital / centroid-ish)
PH_REGIONS = [
    {"code": "NCR", "name": "National Capital Region (Metro Manila)", "lat": 14.5995, "lon": 120.9842},  # Manila
    {"code": "I",   "name": "Ilocos Region",          "lat": 16.6159, "lon": 120.3167},
    {"code": "II",  "name": "Cagayan Valley",         "lat": 17.6131, "lon": 121.7269},
    {"code": "III", "name": "Central Luzon",          "lat": 15.0333, "lon": 120.6833},
    {"code": "IV",  "name": "Southern Tagalog",       "lat": 14.2117, "lon": 121.1653},
    {"code": "V",   "name": "Bicol Region",           "lat": 13.1390, "lon": 123.7438},
    {"code": "VI",  "name": "Western Visayas",        "lat": 10.7202, "lon": 122.5621},
    {"code": "VII", "name": "Central Visayas",        "lat": 10.3157, "lon": 123.8854},
    {"code": "VIII","name": "Eastern Visayas",        "lat": 11.2440, "lon": 125.0030},
    {"code": "IX",  "name": "Western Mindanao",       "lat":  6.9214, "lon": 122.0790},
    {"code": "X",   "name": "Northern Mindanao",      "lat":  8.4820, "lon": 124.6472},
    {"code": "XI",  "name": "Southern Mindanao",      "lat":  7.1907, "lon": 125.4557},
]


def http():
    s = requests.Session()
    r = Retry(total=5, backoff_factor=0.5, status_forcelist=[429, 500, 502, 503, 504], allowed_methods=["GET"])
    s.mount("https://", HTTPAdapter(max_retries=r))
    return s

@dlt.resource(
    name="regions_daily",
    primary_key=["region_code", "date"],       # upsert per region/day
    write_disposition="merge",
)
def ph_regions_past_week():
    """
    Fetch past 7 available days (Open-Meteo archive has ~2-day lag)
    for a set of PH regions. One row per region/day.
    """
    today = date.today()
    end_date = today - timedelta(days=2)       # model delay
    start_date = end_date - timedelta(days=6)  # 7-day window

    url = "https://archive-api.open-meteo.com/v1/archive"
    daily_cols = ",".join([
        "weather_code",
        "temperature_2m_min",
        "temperature_2m_max",
        "precipitation_sum"
    ])

    for r in PH_REGIONS:
        params = {
            "latitude": r["lat"],
            "longitude": r["lon"],
            "start_date": start_date.isoformat(),
            "end_date": end_date.isoformat(),
            "daily": daily_cols,
            "timezone": "Asia/Manila"
        }
        resp = http().get(url, params=params, timeout=30)
        resp.raise_for_status()
        payload = resp.json()

        times = payload["daily"]["time"]
        mins  = payload["daily"]["temperature_2m_min"]
        maxs  = payload["daily"]["temperature_2m_max"]
        prcps = payload["daily"]["precipitation_sum"]
        codes = payload["daily"]["weather_code"]

        for i, dt in enumerate(times):
            yield {
                "region_code":   r["code"],
                "region_name":   r["name"],
                "latitude":      r["lat"],
                "longitude":     r["lon"],
                "date":          dt,         # YYYY-MM-DD
                "temp_min":      mins[i],
                "temp_max":      maxs[i],
                "precipitation": prcps[i],
                "weather_code":  codes[i],
            }

def run():
    pipeline = dlt.pipeline(
        pipeline_name="03-dlt-meteo-ph-regions",
        destination="clickhouse",
        dataset_name="meteo",
        dev_mode=False
    )
    print("Fetching PH regions past-week weather...")
    info = pipeline.run(ph_regions_past_week())
    print(f"✅ Load completed: {info}")

if __name__ == "__main__":
    run()
