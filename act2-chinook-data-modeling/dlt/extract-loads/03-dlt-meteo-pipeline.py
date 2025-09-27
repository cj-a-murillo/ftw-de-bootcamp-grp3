import requests
from datetime import date, timedelta
import dlt

@dlt.resource(write_disposition="append", name="manila")
def manila_historical_weather():
    """
    Fetches the past 365 days of daily weather for Metro Manila
    using Open‑Meteo's Historical Weather API, adjusting for the
    2-day model delay.
    """
    today = date.today()
    end_date = today - timedelta(days=2)
    start_date = end_date - timedelta(days=364)

    url = "https://archive-api.open-meteo.com/v1/archive"
    params = {
        "latitude": 14.5995,
        "longitude": 120.9842,
        "start_date": start_date.isoformat(),
        "end_date": end_date.isoformat(),
        "daily": ",".join([
            "weather_code",
            "temperature_2m_min",
            "temperature_2m_max",
            "precipitation_sum"
        ]),
        "timezone": "Asia/Manila"
    }

    resp = requests.get(url, params=params)
    resp.raise_for_status()
    payload = resp.json()

    times = payload["daily"]["time"]
    mins  = payload["daily"]["temperature_2m_min"]
    maxs  = payload["daily"]["temperature_2m_max"]
    prcps = payload["daily"]["precipitation_sum"]
    codes = payload["daily"]["weather_code"]

    for i, dt in enumerate(times):
        yield {
            "date":         dt,
            "temp_min":     mins[i],
            "temp_max":     maxs[i],
            "precipitation":prcps[i],
            "weather_code": codes[i],
        }

def run():
    pipeline = dlt.pipeline(
        pipeline_name="03-dlt-meteo-pipeline",
        destination="clickhouse",
        dataset_name="meteo",
        dev_mode=False  
    )
    print("Fetching and loading...")
    info = pipeline.run(manila_historical_weather())
    print(f"✅ Load completed: {info}")

if __name__ == "__main__":
    run()


# https://gist.github.com/stellasphere/9490c195ed2b53c707087c8c2db4ec0c 
# https://gist.githubusercontent.com/stellasphere/9490c195ed2b53c707087c8c2db4ec0c/raw/76b0cb0ef0bfd8a2ec988aa54e30ecd1b483495d/descriptions.json
