-- Business Problem Q1: Which industries & states have the highest cost to acquire customers?

WITH CAC_Calculation AS (
    SELECT 
        State,
        Business_Type,
        SUM(Price_Level * 1000) AS Total_Marketing_Spend,
        SUM(Review_Count) AS New_Customers_Acquired,
        ROUND(SUM(Price_Level * 1000) / NULLIF(SUM(Review_Count), 0), 2) AS CAC
    FROM Yelp_Businesses
    GROUP BY State, Business_Type
)
SELECT * FROM CAC_Calculation
ORDER BY CAC DESC;

-- Business Problem Q2: Which industries have the most valuable long-term customers?

WITH CLV_Calculation AS (
    SELECT 
        Business_Type,
        ROUND(AVG(Price_Level), 2) AS AOV,  -- Average Order Value
        COUNT(*) OVER (PARTITION BY Business_Type) AS Purchase_Frequency,
        5 AS Avg_Lifespan_Yrs  -- Assumed customer lifespan
    FROM Yelp_Businesses
)
SELECT 
    Business_Type,
    ROUND(AOV * Purchase_Frequency * Avg_Lifespan_Yrs, 2) AS CLV
FROM CLV_Calculation
ORDER BY CLV DESC;

-- Business Problem Q3: Which industries have higher transaction values?

SELECT 
    Business_Type,
    ROUND(SUM(Price_Level) / COUNT(*), 2) AS AOV
FROM Yelp_Businesses
GROUP BY Business_Type
HAVING COUNT(*) > 50  -- Only consider business types with at least 50 businesses
ORDER BY AOV DESC;

-- Business Problem Q4: Which states contribute most to Yelp-listed business revenue?

SELECT 
    State,
    SUM(Price_Level) AS Total_Revenue,
    ROUND(100 * SUM(Price_Level) / SUM(SUM(Price_Level)) OVER (), 2) AS Revenue_Percentage
FROM Yelp_Businesses
GROUP BY State
ORDER BY Total_Revenue DESC;

-- Business Problem Q5: Which months saw the highest revenue growth?

WITH Monthly_Revenue AS (
    SELECT 
        DATE_FORMAT(created_at, '%Y-%m') AS Month,
        SUM(Price_Level) AS Revenue
    FROM Yelp_Businesses
    GROUP BY Month
)
SELECT 
    Month,
    Revenue,
    LAG(Revenue, 1) OVER (ORDER BY Month) AS Previous_Month_Revenue,
    ROUND(((Revenue - LAG(Revenue, 1) OVER (ORDER BY Month)) / 
           NULLIF(LAG(Revenue, 1) OVER (ORDER BY Month), 0)) * 100, 2) AS MoM_Growth
FROM Monthly_Revenue;

-- Business Problem Q6: Which states have the highest business failure rates?

WITH Churned_Businesses AS (
    SELECT 
        State,
        COUNT(*) AS Total_Businesses,
        SUM(CASE WHEN Review_Count < 10 THEN 1 ELSE 0 END) AS Churned
    FROM Yelp_Businesses
    GROUP BY State
)
SELECT 
    State,
    Churned,
    Total_Businesses,
    ROUND((Churned / NULLIF(Total_Businesses, 0)) * 100, 2) AS Churn_Rate
FROM Churned_Businesses
ORDER BY Churn_Rate DESC;

-- Business Problem Q7: Quickly fetch top-rated businesses per state

DELIMITER //
CREATE PROCEDURE Get_Top_Businesses(IN state_name VARCHAR(50))
BEGIN
    SELECT name, category, rating, review_count, price_level
    FROM Yelp_Businesses
    WHERE State = state_name
    ORDER BY rating DESC, review_count DESC
    LIMIT 10;
END //
DELIMITER ;

CALL Get_Top_Businesses('California');

-- Business Problem Q8: Which businesses maintain stable customer satisfaction?

SELECT name, category, ROUND(STDDEV(Rating), 2) AS Rating_Variance
FROM Yelp_Businesses
GROUP BY name, category
HAVING Rating_Variance < 0.5
ORDER BY Rating_Variance ASC
LIMIT 10;

-- Business Problem Q9: Identify fast-growing businesses before they trend!

WITH Monthly_Reviews AS (
    SELECT 
        Name, 
        Category, 
        DATE_FORMAT(created_at, '%Y-%m') AS Month,
        SUM(Review_Count) AS Total_Reviews,
        LEAD(SUM(Review_Count), 1) OVER (PARTITION BY Name ORDER BY Month) AS Next_Month_Reviews
    FROM Yelp_Businesses
    GROUP BY Name, Category, Month
)
SELECT *
FROM Monthly_Reviews
WHERE Next_Month_Reviews > Total_Reviews;

-- Business Problem Q10: Are expensive businesses actually better-rated?

SELECT price_level, ROUND(AVG(rating), 2) AS Avg_Rating, COUNT(*) AS Business_Count
FROM Yelp_Businesses
WHERE price_level > 0  -- Exclude unknown price levels
GROUP BY price_level
ORDER BY price_level ASC;
