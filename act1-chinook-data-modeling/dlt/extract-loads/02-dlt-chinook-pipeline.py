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
    cur.execute("SELECT * FROM artist;") #Query targeting yun postgres DB ng chinook
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

#ADD OTHER SCRIPTS FOR OTHER TABLES IF NEEDED: SOURCE OF TABLES from CHINOOK DB (ito yun naka public)
@dlt.resource(write_disposition="append", name="customers")
def customer():
    """Extract all customers from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM customer;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

@dlt.resource(write_disposition="append", name="invoice_lines")
def invoiceLine():
    """Extract all invoiceLine from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM invoice_line;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

@dlt.resource(write_disposition="append", name="tracks")
def track():
    """Extract all track from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM track;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

@dlt.resource(write_disposition="append", name="invoices")
def invoice():
    """Extract all invoice from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM invoice;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

@dlt.resource(write_disposition="append", name="employees")
def employee():
    """Extract all employee from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM employee;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

@dlt.resource(write_disposition="append", name="media_types")
def media_type():
    """Extract all media_type from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM media_type;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

@dlt.resource(write_disposition="append", name="genres")
def genre():
    """Extract all genre from the Chinook sample DB."""
    conn = get_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM genre;")
    for row in cur.fetchall():
        yield dict(row)
    conn.close()

def run():
    pipeline = dlt.pipeline(
        pipeline_name="02-dlt-chinook-pipeline",
        destination="clickhouse",
        dataset_name="chinook_cj", # change yun dataset name if an error occured, ex: chinook_cj  #old:chinook
        dev_mode=False   # set True if you want DLT to drop & recreate tables on each run
    )
    
    print("Fetching and loading...")
    load_info = pipeline.run(artists())
    print("records loaded:", load_info)
    load_info = pipeline.run(albums())
    print("records loaded:", load_info)
    load_info = pipeline.run(customer())
    print("records loaded:", load_info)
    load_info = pipeline.run(invoiceLine())
    print("records loaded:", load_info)
    load_info = pipeline.run(track())
    print("records loaded:", load_info)
    load_info = pipeline.run(invoice())   
    print("records loaded:", load_info)
    load_info = pipeline.run(employee())   
    print("records loaded:", load_info)
    load_info = pipeline.run(media_type())   
    print("records loaded:", load_info)
    load_info = pipeline.run(genre())   
    print("records loaded:", load_info)

if __name__ == "__main__":
    run()
