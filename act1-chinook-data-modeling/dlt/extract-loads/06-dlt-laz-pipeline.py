from typing import Optional
from urllib.parse import urljoin
import dlt
from playwright.sync_api import sync_playwright

SEARCH_URL = "https://www.lazada.com.ph/catalog/?q=mechanical+keyboard"
MAX_PAGES = 5

def _canonical_url(href: Optional[str]) -> Optional[str]:
    if not href:
        return None
    if href.startswith("//"):
        return "https:" + href
    if href.startswith("/"):
        return urljoin("https://www.lazada.com.ph", href)
    return href

def _auto_scroll(page, max_steps: int = 12, pause_ms: int = 500):
    last_height = 0
    for _ in range(max_steps):
        page.evaluate("window.scrollBy(0, document.body.scrollHeight)")
        page.wait_for_timeout(pause_ms)
        new_height = page.evaluate("document.body.scrollHeight")
        if new_height == last_height:
            break
        last_height = new_height

@dlt.resource(write_disposition="append", name="lazada_products")
def lazada_scraped_data():
    seen = set()
    with sync_playwright() as pw:
        browser = pw.chromium.launch(headless=True)
        page = browser.new_page()

        for p in range(1, MAX_PAGES + 1):
            url = f"{SEARCH_URL}&page={p}" if p > 1 else SEARCH_URL
            page.goto(url, wait_until="domcontentloaded")
            page.wait_for_selector("div[data-qa-locator='product-item']", timeout=15000)
            _auto_scroll(page)

            for card in page.query_selector_all("div[data-qa-locator='product-item']"):
                try:
                    name_el  = card.query_selector("[title]") or card.query_selector("a[title]")
                    price_el = card.query_selector('span:has-text("₱")')
                    link_el  = card.query_selector("a[href]")

                    href = _canonical_url(link_el.get_attribute("href") if link_el else None)
                    if not href or href in seen:
                        continue
                    seen.add(href)

                    yield {
                        "page":  p,
                        "name":  (name_el.get_attribute("title") if name_el else None),
                        "price": (price_el.inner_text().strip() if price_el else None),
                        "url":   href,
                    }
                except Exception:
                    continue
        browser.close()

def run():
    pipeline = dlt.pipeline(
        pipeline_name="dlt-laz-pipeline",
        destination="clickhouse",
        dataset_name="lazada_products",
        dev_mode=False,
    )
    print("Fetching and loading...")
    info = pipeline.run(lazada_scraped_data())
    print("records loaded:", info)

if __name__ == "__main__":
    run()
