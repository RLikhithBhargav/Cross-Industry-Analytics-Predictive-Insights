Yelp Business Analytics - End-to-End Data Pipeline & Power BI Dashboard

📌 Project Overview

This project is a comprehensive data analytics pipeline that extracts, processes, and visualizes Yelp business data across multiple industries. The goal is to generate actionable business insights using Python, MySQL, and Power BI. The project showcases expertise in data engineering, SQL analytics, and advanced data visualization.

📊 Technologies & Tools Used

Python → Web scraping (Yelp API), data cleaning (Pandas), MySQL connection (SQLAlchemy)

MySQL → Database storage, advanced SQL analytics

Power BI → Data visualization, interactive dashboard, DAX calculations

DAX (Data Analysis Expressions) → Custom measures for business metrics

Power Query → Data transformations in Power BI

SQLAlchemy & PyMySQL → Efficient MySQL connection handling

📌 Project Workflow

🔹 Step 1: Data Collection (Web Scraping & API Extraction)

Extracted Yelp business data using the Yelp Fusion API.

Gathered multiple business categories (restaurants, gyms, salons, hotels, etc.).

Retrieved details including ratings, reviews, price levels, and locations.

Saved extracted data into a structured CSV file for further processing.

🔹 Step 2: Data Cleaning & Transformation (Python & Pandas)

Handled missing values (e.g., replaced null phone numbers with "Not Provided").

Converted data types (e.g., price levels to numerical, review counts to integers).

Standardized address formats and category classifications.

Removed duplicate businesses and inconsistencies in dataset.

Saved cleaned data into cleaned_yelp_data.csv.

🔹 Step 3: Database Storage (MySQL Integration)

Designed an optimized MySQL schema for Yelp business data.

Established a secure connection to MySQL using SQLAlchemy & PyMySQL.

Inserted cleaned data into the MySQL database (YelpData and Yelp_Businesses table).

Validated successful data insertion using SQL queries in MySQL Workbench.

🔹 Step 4: Advanced SQL Queries for Business Insights

To uncover deep insights, we implemented complex SQL queries:

Customer Acquisition Cost (CAC) per business type (Marketing Spend / New Customers)

Customer Lifetime Value (CLV) Calculation

Average Order Value (AOV) by industry

Revenue contribution per state

Month-over-month revenue growth trends

Churn rate analysis (identifying failing businesses)

State-wise high-rated businesses

Most consistent businesses (low rating variance)

Stored Procedures to fetch top businesses dynamically

Trending businesses based on review growth rate

🔹 Step 5: Power BI Dashboard - Advanced Data Visualization

Connected Power BI to MySQL to fetch real-time business data.

Created calculated measures in DAX:

📈 Customer Acquisition Cost (CAC)

💰 Customer Lifetime Value (CLV)

📊 Revenue Share Per State

📉 Rolling Revenue & Review Trends

⭐ Price vs. Rating Correlation

Designed interactive visualizations:

Geospatial Analysis: Filled maps & bubble maps for state-wise insights

Industry Performance: Bar & scatter plots for category-based trends

Time-Series Analysis: Line charts for revenue & review trends

Dynamic Filters: Slicers for state, category, business type, and price level

Published dashboard to Power BI Service for scheduled refreshes & sharing.

📌 Key Business Insights Derived

✅ Which industries have the highest customer acquisition cost?
✅ Which business types retain the most valuable customers (high CLV)?
✅ Do higher-priced businesses have better customer ratings?
✅ Which states contribute the most revenue to Yelp businesses?
✅ Which businesses are trending based on review growth?
✅ What are the most consistent businesses with stable ratings?

