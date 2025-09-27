import time
import requests
import dlt

import dlt, requests
from requests.adapters import HTTPAdapter, Retry

def http():
    s = requests.Session()
    r = Retry(total=5, backoff_factor=0.4, status_forcelist=[429,500,502,503,504], allowed_methods=['GET'])
    s.mount('https://', HTTPAdapter(max_retries=r))
    return s

@dlt.resource(
    name="market_price",
    primary_key=["id","last_updated"],           # 👈 upsert key
    write_disposition="merge"                    # 👈 dedupe by key
)
def bitcoin_markets():
    api_key = dlt.secrets["coingecko"]["api_key"]
    url = "https://api.coingecko.com/api/v3/coins/markets"
    params = {"vs_currency": "usd", "ids": "bitcoin"}
    headers = {"x_cg_pro_api_key": api_key}
    resp = http().get(url, params=params, headers=headers, timeout=30)
    resp.raise_for_status()
    for obj in resp.json():
        yield {
            "id": obj.get("id"),
            "symbol": obj.get("symbol"),
            "name": obj.get("name"),
            "image": obj.get("image"),
            "current_price": obj.get("current_price"),
            "market_cap": obj.get("market_cap"),
            "market_cap_rank": obj.get("market_cap_rank"),
            "total_volume": obj.get("total_volume"),
            "high_24h": obj.get("high_24h"),
            "low_24h": obj.get("low_24h"),
            "price_change_24h": obj.get("price_change_24h"),
            "price_change_percentage_24h": obj.get("price_change_percentage_24h"),
            "last_updated": obj.get("last_updated"),  # ISO8601 from API
        }



def run():
    pipeline = dlt.pipeline(
        pipeline_name="04-dlt-btc-pipeline",
        destination="clickhouse",
        dataset_name="btc",
        dev_mode=False   # creates DB & tables if they don't exist
    )
    print("Fetching and loading...")
    #while True:
    info = pipeline.run(bitcoin_markets())
 
    print("records loaded:", info)


if __name__ == "__main__":
    run()

