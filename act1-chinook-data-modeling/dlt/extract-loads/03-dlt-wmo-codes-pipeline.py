# pipelines/dlt-meteo-wmo-codes.py
import dlt
import requests
from requests.adapters import HTTPAdapter, Retry

WMO_CODES_URL = "https://gist.githubusercontent.com/stellasphere/9490c195ed2b53c707087c8c2db4ec0c/raw/76b0cb0ef0bfd8a2ec988aa54e30ecd1b483495d/descriptions.json"

def http_session():
    s = requests.Session()
    retries = Retry(
        total=5, backoff_factor=0.5,
        status_forcelist=[429, 500, 502, 503, 504],
        allowed_methods=["GET"]
    )
    s.mount("https://", HTTPAdapter(max_retries=retries))
    return s

@dlt.resource(
    name="wmo_codes",
    primary_key="weather_code",
    write_disposition="merge"   # upsert on weather_code
)
def wmo_code_descriptions():
    """Fetch WMO code → day/night description & icon; flatten to one row per code."""
    resp = http_session().get(WMO_CODES_URL, timeout=30)
    resp.raise_for_status()
    data = resp.json()          # keys like "0","1",... mapping to {day:{}, night:{}}

    for k, v in data.items():
        day = (v or {}).get("day", {}) or {}
        night = (v or {}).get("night", {}) or {}
        yield {
            "weather_code":         int(k),
            "day_description":      day.get("description"),
            "day_icon_url":         day.get("image"),
            "night_description":    night.get("description"),
            "night_icon_url":       night.get("image"),
            "source_url":           WMO_CODES_URL,
        }

def run():
    pipeline = dlt.pipeline(
        pipeline_name="03-dlt-meteo-wmo-codes",
        destination="clickhouse",   # creds taken from your container env
        dataset_name="meteo",
        dev_mode=False
    )
    print("Loading WMO code descriptions…")
    info = pipeline.run(wmo_code_descriptions())
    print(f"✅ Load completed: {info}")

if __name__ == "__main__":
    run()
