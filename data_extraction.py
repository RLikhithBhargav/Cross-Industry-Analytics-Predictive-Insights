import requests
import pandas as pd
import time

# Yelp API Key 
API_KEY = "Id47o3h1bCBHM9YCy5GfmATz3xO_r58-Tlas3YRoT4JLQ6UyUXrdkHfUXjR7831gsEjB0R7uTCLYbUqQALJssfWLUyfwi6mRQVoNIRTxJjRAMVQGxKBrLRTxVjjWZ3Yx"

# Yelp API Endpoint
API_URL = "https://api.yelp.com/v3/businesses/search"

# Headers with API Key
HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

# List of business types for cross-industry analysis
business_types = ["restaurants", "gyms", "hospitals", "auto repair", "hotels", "salons"]

# List of US states to scrape data from
us_states = ["California", "Texas", "New York", "Florida", "Illinois", "Washington", "Georgia", "Arizona", "Ohio", "Pennsylvania", "Massachusetts"]

# Maximum results per category per state (Yelp API limit: 240 per category)
MAX_RESULTS_PER_CATEGORY = 240
BATCH_SIZE = 50  # Yelp allows max 50 businesses per API request

# Store results
businesses_data = []

# Loop through US states
for state in us_states:
    for business_type in business_types:
        business_count = 0  # Track total businesses per state & category

        # Paginate through API responses (up to 240 businesses per category per state)
        for offset in range(0, MAX_RESULTS_PER_CATEGORY, BATCH_SIZE):
            params = {
                "term": business_type,
                "location": state,  # Dynamically changing state
                "limit": BATCH_SIZE,
                "offset": offset,
                "sort_by": "rating"
            }

            response = requests.get(API_URL, headers=HEADERS, params=params)

            if response.status_code != 200:
                print(f"⚠️ Error for {business_type} in {state}: {response.status_code}, {response.json()}")
                break  # Stop if request fails

            data = response.json()

            for biz in data.get("businesses", []):
                # Handle missing categories
                categories = biz.get("categories", [])
                category_name = categories[0]["title"] if categories else "Unknown"

                business = {
                    "State": state,  # Add state info
                    "Business Type": business_type,
                    "Name": biz.get("name", "N/A"),
                    "Rating": biz.get("rating", "N/A"),
                    "Review Count": biz.get("review_count", "N/A"),
                    "Price Level": biz.get("price", "N/A"),
                    "Category": category_name,
                    "Address": ", ".join(biz.get("location", {}).get("display_address", [])),
                    "City": biz.get("location", {}).get("city", "N/A"),
                    "Phone": biz.get("display_phone", "N/A"),
                    "Yelp URL": biz.get("url", "N/A")
                }
                businesses_data.append(business)
                business_count += 1

            print(f"✅ Scraped {business_count} businesses from {business_type} in {state}...")
            time.sleep(2)  # Respect API rate limits

# Convert to DataFrame
df = pd.DataFrame(businesses_data)

# Save to CSV
df.to_csv("data/yelp_cross_industry_data.csv", index=False)

print("✅ Yelp Data Scraping Completed. Data saved as 'yelp_cross_industry_data.csv'")
