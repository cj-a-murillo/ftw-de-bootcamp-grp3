# extract-loads/09-dlt-big-covid-pipeline.py

import os
import io
import dlt
import pandas as pd
from typing import Optional
from pathlib import Path
from urllib.request import urlopen

# ---------------------------------------------------------------------------
# CONFIG
# ---------------------------------------------------------------------------
CSV_URL = "https://storage.googleapis.com/covid19-open-data/v3/epidemiology.csv"

# Staging directory and file (relative to this script)
ROOT_DIR = Path(__file__).resolve().parent
STAGING_DIR = ROOT_DIR / "staging" / "covid"
FULL_CSV_PATH = STAGING_DIR / "epidemiology.csv"  # full dataset
# When only a small head is requested, we write a compact file for speed:
HEAD_CSV_TEMPLATE = "epidemiology_head_{n}.csv"   # e.g., epidemiology_head_500.csv

# ---------------------------------------------------------------------------
# SCHEMA HINTS (ensure columns get created even if early batches are nulls)
# ---------------------------------------------------------------------------
COLUMNS = {
    "date": {"data_type": "date", "nullable": True},
    "location_key": {"data_type": "text", "nullable": True},
    "new_confirmed": {"data_type": "bigint", "nullable": True},
    "new_deceased": {"data_type": "bigint", "nullable": True},
    "new_recovered": {"data_type": "bigint", "nullable": True},
    "new_tested": {"data_type": "bigint", "nullable": True},
    "cumulative_confirmed": {"data_type": "bigint", "nullable": True},
    "cumulative_deceased": {"data_type": "bigint", "nullable": True},
    "cumulative_recovered": {"data_type": "bigint", "nullable": True},
    "cumulative_tested": {"data_type": "bigint", "nullable": True},
}


# ---------------------------------------------------------------------------
# UTIL: Download helpers
# ---------------------------------------------------------------------------
def _download_full_csv(url: str, dest: Path) -> None:
    """Download the entire CSV to `dest` (streaming, low memory)."""
    STAGING_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Downloading full CSV to {dest} ...")
    with urlopen(url) as resp, open(dest, "wb") as f:
        # stream in binary chunks
        while True:
            chunk = resp.read(1024 * 1024)  # 1 MB
            if not chunk:
                break
            f.write(chunk)
    print("Full download complete.")


def _download_head_csv(url: str, dest: Path, n_rows: int) -> None:
    """
    Download only the header + first n_rows data lines to `dest`.
    This is MUCH faster for testing/small demos.
    """
    STAGING_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Downloading head ({n_rows} rows) to {dest} ...")

    with urlopen(url) as resp:
        # Wrap as text stream for line-by-line iteration
        text_stream = io.TextIOWrapper(resp, encoding="utf-8", newline="")
        with open(dest, "w", encoding="utf-8", newline="") as f_out:
            # Write header
            header = next(text_stream)
            f_out.write(header)

            # Write first n_rows data lines
            for i, line in enumerate(text_stream, start=1):
                if i > n_rows:
                    break
                f_out.write(line)

    print("Head download complete.")


def ensure_local_csv(row_limit: Optional[int], force_redownload: bool = False) -> Path:
    """
    Ensure a local CSV is present in staging. Strategy:
    - If row_limit is provided, prefer a small head file for speed.
    - Otherwise, ensure the full CSV is present (download if missing).
    """
    if row_limit is not None:
        head_path = STAGING_DIR / HEAD_CSV_TEMPLATE.format(n=row_limit)
        if force_redownload or not head_path.exists():
            _download_head_csv(CSV_URL, head_path, row_limit)
        else:
            print(f"Using cached head file: {head_path}")
        return head_path

    # Full dataset case
    if force_redownload or not FULL_CSV_PATH.exists():
        _download_full_csv(CSV_URL, FULL_CSV_PATH)
    else:
        print(f"Using cached full file: {FULL_CSV_PATH}")
    return FULL_CSV_PATH


# ---------------------------------------------------------------------------
# dlt RESOURCE: reads from LOCAL staged file (not over the network)
# ---------------------------------------------------------------------------
@dlt.resource(
    name="covid19_epidemiology",
    table_name="covid19_epidemiology",
    write_disposition="append",
    columns=COLUMNS,
)
def covid_epidemiology(
    row_limit: Optional[int] = None,
    chunk_rows: int = 50_000,
    force_redownload: bool = False,
):
    """
    Yield dataframes from a LOCAL CSV (downloaded to staging first).

    - If `row_limit` is set → we stage a head file and use `nrows=row_limit` (fast).
    - If `row_limit` is None → we stage the full file and stream with `chunksize`.
    """
    local_csv = ensure_local_csv(row_limit=row_limit, force_redownload=force_redownload)

    if row_limit is not None:
        # FAST path for small demos/tests: read only N rows in a single DF
        df = pd.read_csv(local_csv, nrows=row_limit, dtype_backend="pyarrow")
        _clean_types_inplace(df)
        yield df
    else:
        # BIG path: stream the full file locally in chunks
        for chunk in pd.read_csv(local_csv, chunksize=chunk_rows, dtype_backend="pyarrow"):
            _clean_types_inplace(chunk)
            yield chunk


def _clean_types_inplace(df: pd.DataFrame) -> None:
    """Normalize dtypes for stability in ClickHouse."""
    if "date" in df.columns:
        df["date"] = pd.to_datetime(df["date"], errors="coerce").dt.date

    for col in [
        "new_confirmed", "new_deceased", "new_recovered", "new_tested",
        "cumulative_confirmed", "cumulative_deceased", "cumulative_recovered", "cumulative_tested",
    ]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce").astype("Int64")


# ---------------------------------------------------------------------------
# PIPELINE RUNNER
# ---------------------------------------------------------------------------
def run(
    row_limit: Optional[int] = 500,
    chunk_rows: int = 20_000,
    force_redownload: bool = False,
):
    """
    row_limit:
      - int  → download + use a small head file; read with nrows (fast)
      - None → download (if needed) the full file; read in chunks (safe for RAM)
    chunk_rows: chunk size when row_limit=None
    force_redownload: True to re-fetch even if cached file exists
    """
    print(
        f"Starting ingestion with row_limit={row_limit}, chunk_rows={chunk_rows}, "
        f"force_redownload={force_redownload}"
    )

    pipe = dlt.pipeline(
        pipeline_name="covid19_epidemiology_pipeline",
        destination="clickhouse",
        dataset_name="covid19_open_data",
    )

    load_info = pipe.run(
        covid_epidemiology(
            row_limit=row_limit,
            chunk_rows=chunk_rows,
            force_redownload=force_redownload,
        ),
        loader_file_format="parquet",
    )

    print("Ingestion completed.")
    print(load_info)


if __name__ == "__main__":
    # Example: Only first 500 rows, will create/use staging/covid/epidemiology_head_500.csv
    run(row_limit=500, chunk_rows=100, force_redownload=False)
