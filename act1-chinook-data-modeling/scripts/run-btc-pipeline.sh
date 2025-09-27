#!/usr/bin/env bash
set -euo pipefail
cd /projects/ftw-de-bootcamp

# 1) ingest (dlt)
docker compose --profile jobs run --rm dlt \
  python extract-loads/04-dlt-btc-pipeline.py

# (optional) tiny wait so CH merges are visible to the next step
sleep 2

# 2) build BTC models only
docker compose --profile jobs run --rm \
  -w /workdir/transforms/04_btc \
  dbt build --profiles-dir . --target local

# chmod +x jobs/run_btc.sh
# */5 * * * * /usr/bin/flock -n /tmp/dlt-btc.lock /projects/ftw-de-bootcamp/jobs/run_btc.sh >> /projects/ftw-de-bootcamp/logs/btc_cron.log 2>&1

# test against mac and ubuntu wsl