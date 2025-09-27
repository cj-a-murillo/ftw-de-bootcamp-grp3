# syntax=docker/dockerfile:1

FROM python:3.9-slim

# Install system packages + Playwright dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      unzip \
      libnss3 \
      libatk1.0-0 \
      libatk-bridge2.0-0 \
      libcups2 \
      libdrm2 \
      libxkbcommon0 \
      libxcomposite1 \
      libxdamage1 \
      libxrandr2 \
      libgbm1 \
      libgtk-3-0 \
      libasound2 \
      libxshmfence1 \
      libxext6 \
      libxdg-basedir1 \
      libpangocairo-1.0-0 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/dlt/pipelines

# Copy & install Python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
 && pip install --no-cache-dir playwright

# Download Playwright’s browser binaries
RUN playwright install chromium

# Copy .dlt secret configuration
COPY .dlt/secrets.toml /var/dlt/.dlt/secrets.toml

# Copy the rest of your pipeline code in
COPY . .

