import requests
import dlt
import json
from typing import Dict, Any, List

POKEAPI_BASE = "https://pokeapi.co/api/v2"

@dlt.resource(write_disposition="append", name="gen1")
def gen1_pokemon() -> Dict[str, Any]:
    """
    Fetches the first-generation (Kanto) Pokémon data (IDs 1–151) and yields records.
    """
    for pokemon_id in range(1, 152):
        detail_url = f"{POKEAPI_BASE}/pokemon/{pokemon_id}"
        try:
            r = requests.get(detail_url)
            r.raise_for_status()
            data = r.json()
            yield {
                "id": data["id"],
                "name": data["name"],
                "height": data["height"],
                "weight": data["weight"],
                # Arrays of simple types map to ClickHouse Array(String)
                "types": [t["type"]["name"] for t in data["types"]],
                "abilities": [a["ability"]["name"] for a in data["abilities"]],
                # Store base_stats as JSON string in ClickHouse String column
                "base_stats_json": json.dumps({s["stat"]["name"]: s["base_stat"] for s in data["stats"]}),
                "sprite_url": data["sprites"]["front_default"] or "",
            }
        except Exception as e:
            # log and skip on errors
            print(f"Error fetching Pokémon ID {pokemon_id}: {e}")
            continue


def run():
    # Create a ClickHouse pipeline that will auto-create the database and tables
    pipeline = dlt.pipeline(
        pipeline_name="05-dlt-poke-pipeline",
        destination="clickhouse",
        dataset_name="pokemon",
        dev_mode=False  
    )
    print("Fetching and loading...")
    info = pipeline.run(gen1_pokemon())
    print(f"✅ Loaded Gen 1 Pokémon: {info}")


if __name__ == "__main__":
    run()
