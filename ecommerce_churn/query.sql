USE ecommerce_churn;
SHOW TABLES
DESCRIBE ecommerce_customers_complete;
SELECT COUNT(*) AS customers,
       COUNT(DISTINCT CustomerID) AS unique_customers
FROM ecommerce_churn.ecommerce_customers_complete;


-- Finding Churn percentage
SELECT SUM(Churn) / COUNT(DISTINCT CustomerID) * 100 AS churn_rate_pct
FROM ecommerce_churn.ecommerce_customers_complete;

-- How does churn rate differ between customers who complained and those who did not?
SELECT
    Complain,
    COUNT(*) AS customers,
    SUM(Churn) AS churned_customers,
    ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_rate_pct
FROM ecommerce_churn.ecommerce_customers_complete
GROUP BY Complain
ORDER BY Complain;

-- How does churn rate change across customer tenure? Create sensible tenure groups.
SELECT
    CASE
        WHEN Tenure IS NULL THEN 'Missing'
        WHEN Tenure < 2 THEN 'A'
        WHEN Tenure BETWEEN 2 AND 10 THEN 'B'
        WHEN Tenure BETWEEN 11 AND 20 THEN 'C'
        ELSE 'D'
    END AS tenure_groups,
    COUNT(*) AS customers,
    ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_rate_pct
FROM ecommerce_churn.ecommerce_customers_complete
GROUP BY tenure_groups;

-- 4. Do customers who have gone longer since their last order churn more often?
SELECT DaySinceLastOrder, COUNT(*) AS number_of_customers, ROUND( 100* SUM(Churn) / COunt(*), 2) AS churn_rate_pct
FROM ecommerce_churn.ecommerce_customers_complete
WHERE DaySinceLastOrder IS NOT NULL
GROUP BY DaySinceLastOrder
ORDER BY DaySinceLastOrder;

-- Which preferred order categories have the highest churn rates? Are their customer counts large enough to trust the comparison?
SELECT PreferedOrderCat, COUNT(*) AS number_of_customers, ROUND( 100* SUM(Churn) / COunt(*), 2) AS churn_rate_pct
FROM ecommerce_churn.ecommerce_customers_complete
WHERE PreferedOrderCat IS NOT NULL
GROUP BY PreferedOrderCat
ORDER BY churn_rate_pct;




-- 6. Does satisfaction score show a consistent relationship with churn?
SELECT SatisfactionScore, COUNT(*) AS number_of_customers, ROUND( 100* SUM(Churn) / COunt(*), 2) AS churn_rate_pct
FROM ecommerce_customers_complete
GROUP BY SatisfactionScore;

-- 7. Does churn differ by preferred payment method or login device?
SELECT
    PreferredPaymentMode,
    PreferredLoginDevice,
    COUNT(*) AS customers,
    SUM(Churn) AS churned_customers,
    ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_rate_pct
FROM ecommerce_churn.ecommerce_customers_complete
GROUP BY PreferredPaymentMode, PreferredLoginDevice
ORDER BY churn_rate_pct DESC;

-- 8. Among customers who complained, does satisfaction score help distinguish those who churned from those who stayed?
SELECT
    SatisfactionScore,
    COUNT(*) AS customers,
    SUM(Churn) AS churned_customers,
    ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_rate_pct
FROM ecommerce_churn.ecommerce_customers_complete
WHERE Complain=1
GROUP BY SatisfactionScore
ORDER BY SatisfactionScore;

-- 9. Are low tenure and a recent complaint together associated with higher churn than either characteristic alone?

SELECT
    CASE
        WHEN Tenure IS NULL THEN 'Missing'
        WHEN Tenure < 2 THEN 'Under 2'
        WHEN Tenure < 10 THEN '2–9'
        WHEN Tenure < 20 THEN '10–19'
        ELSE '20+'
    END AS tenure_group,
    Complain,
    COUNT(*) AS customers,
    ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_rate_pct
FROM ecommerce_churn.ecommerce_customers_complete
GROUP BY tenure_group, Complain
ORDER BY tenure_group, Complain;

-- 10. Which customer segments show the greatest retention risk
-- when combining tenure, complaints, satisfaction, and recency?

SELECT
    CASE
        WHEN Tenure IS NULL THEN 'Missing'
        WHEN Tenure < 2 THEN 'Under 2'
        WHEN Tenure < 10 THEN '2-9'
        WHEN Tenure < 20 THEN '10-19'
        ELSE '20+'
    END AS tenure_group,

    Complain,

    CASE
        WHEN SatisfactionScore <= 2 THEN 'Low'
        WHEN SatisfactionScore = 3 THEN 'Medium'
        ELSE 'High'
    END AS satisfaction_group,

    CASE
        WHEN DaySinceLastOrder IS NULL THEN 'Missing'
        WHEN DaySinceLastOrder <= 3 THEN '0-3 days'
        WHEN DaySinceLastOrder <= 7 THEN '4-7 days'
        ELSE '8+ days'
    END AS recency_group,

    COUNT(*) AS customers,
    SUM(Churn) AS churned_customers,
    ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_rate_pct

FROM ecommerce_churn.ecommerce_customers_complete

GROUP BY
    tenure_group,
    Complain,
    satisfaction_group,
    recency_group

HAVING COUNT(*) >= 20

ORDER BY
    churn_rate_pct DESC,
    customers DESC;



