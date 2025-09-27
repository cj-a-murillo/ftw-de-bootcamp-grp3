import os
import dlt
import psycopg2
from psycopg2.extras import RealDictCursor

def get_connection():
    # these will KeyError if the env var isn't set
    host     = os.environ["POSTGRES_HOST"]
    port     = int(os.environ["POSTGRES_PORT"])
    user     = os.environ["POSTGRES_USER"]
    password = os.environ["POSTGRES_PASSWORD"]
    dbname   = os.environ["POSTGRES_DB"]

    return psycopg2.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        dbname=dbname
    )

@dlt.resource(write_disposition="append", name="artists")
def artists():
    """Extract all artists from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM artist;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

@dlt.resource(write_disposition="append", name="albums")
def albums():
    """Extract all albums from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM album;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

def run():
    pipeline = dlt.pipeline(
        pipeline_name="02-dlt-chinook-pipeline",
        destination="clickhouse",
        dataset_name="chinook",
        dev_mode=False   # set True if you want DLT to drop & recreate tables on each run
    )
    print("Fetching and loading...")
    load_info = pipeline.run(artists())
    print("records loaded:", load_info)
    load_info = pipeline.run(albums())
    print("records loaded:", load_info)

if __name__ == "__main__":
    run()
