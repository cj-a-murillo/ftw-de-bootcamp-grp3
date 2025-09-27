import os
import subprocess
import dlt
import csv
from datetime import datetime
import json


# Directory where this script lives
ROOT_DIR = os.path.dirname(__file__)
# Use a staging folder alongside the pipeline code so it's inside the Docker context
STAGING_DIR = os.path.join(ROOT_DIR, "staging", "food")
ZIP_PATH = os.path.join(STAGING_DIR, "food-panda-restaurant-reviews.zip")

def fetch_and_extract():
    """
    Downloads the Kaggle dataset zip if not present, then unzips into STAGING_DIR.
    """
    os.makedirs(STAGING_DIR, exist_ok=True)
    if not os.path.isfile(ZIP_PATH):
        print("Downloading dataset...")
        subprocess.check_call([
            "curl", "-L",
            "-o", ZIP_PATH,
            "https://www.kaggle.com/api/v1/datasets/download/bwandowando/food-panda-restaurant-reviews"
        ])
    else:
        print("Zip file already present, skipping download.")

    # Unzip
    print("Extracting zip contents...")
    subprocess.check_call([
        "unzip", "-o", ZIP_PATH,
        "-d", STAGING_DIR
    ])


def get_file_path(filename: str) -> str:
    """
    Helper to get full path under STAGING_DIR/source
    """
    return os.path.join(STAGING_DIR, filename)


@dlt.resource(write_disposition="append",name="restaurants")
def restaurants() -> dict:
    """
    Ingests the restaurant master data.
    """
    csv_path = get_file_path("ph_restos_2025.csv")
    with open(csv_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield {
                "store_id": row["StoreId"],
                "name": row["CompleteStoreName"],
                "food_type": row["FoodType"],
                "average_rating": float(row["AverageRating"]) if row["AverageRating"] else None,
                "reviewer_count": int(row["Reviewers"].strip("()")) if row["Reviewers"] else None,
                "city": row["City"]
            }



@dlt.resource(write_disposition="append", name="reviews")
def reviews() -> dict:
    """
    Ingests individual reviews with all available columns, including properly parsing 'replies'.
    """
    csv_path = get_file_path("ph_reviews_2025.csv")
    with open(csv_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            # parse Python-style repr in 'replies' field
            raw_replies = row.get("replies", "[]")
            try:
                replies = ast.literal_eval(raw_replies)
            except Exception:
                replies = []
            yield {
                "store_id": row["StoreId"],
                "uuid": row["uuid"],
                "created_at": datetime.fromisoformat(row["createdAt"].replace("Z", "+00:00")),
                "updated_at": datetime.fromisoformat(row["updatedAt"].replace("Z", "+00:00")),
                "text": row["text"],
                "is_anonymous": row.get("isAnonymous", "false").lower() == "true",
                "reviewer_id": row.get("reviewerId") or None,
                "replies": replies,
                "like_count": int(row.get("likeCount", 0)),
                "is_liked": row.get("isLiked", "false").lower() == "true",
                "overall_rating": float(row.get("overall")) if row.get("overall") else None,
                "rider_rating": float(row.get("rider")) if row.get("rider") else None,
                "restaurant_rating": float(row.get("restaurant_food")) if row.get("restaurant_food") else None,
            }



def run():
    # Ensure data is available
    fetch_and_extract()

    # Configure and run the DLT pipeline
    pipeline = dlt.pipeline(
        pipeline_name="dlt-food-pipeline",
        destination="clickhouse",
        dev_mode=False,
        dataset_name="foodpanda",
    )
    print("Fetching and loading...")
    info1 = pipeline.run(restaurants())
    print("Restaurants loaded:", info1)
    info2 = pipeline.run(reviews())

    print("Reviews loaded:", info2)


if __name__ == "__main__":
    run()
