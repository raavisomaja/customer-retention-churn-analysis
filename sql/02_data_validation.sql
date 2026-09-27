USE customer_retention;

-- =========================================
-- 1. TABLE ROW COUNTS
-- =========================================

SELECT COUNT(*) AS customer_count
FROM customers;

SELECT COUNT(*) AS usage_count
FROM monthly_usage;

SELECT COUNT(*) AS churn_count
FROM churn;


-- =========================================
-- 2. UNIQUE CUSTOMER COUNTS
-- =========================================

SELECT COUNT(DISTINCT CustomerID) AS unique_customers
FROM customers;

SELECT COUNT(DISTINCT CustomerID) AS usage_unique_customers
FROM monthly_usage;

SELECT COUNT(DISTINCT CustomerID) AS churn_unique_customers
FROM churn;


-- =========================================
-- 3. MONTHLY USAGE COVERAGE
-- Every customer should have 12 monthly records
-- =========================================

SELECT
    MIN(month_count) AS min_months,
    MAX(month_count) AS max_months
FROM (
    SELECT
        CustomerID,
        COUNT(*) AS month_count
    FROM monthly_usage
    GROUP BY CustomerID
) AS customer_month_counts;


-- =========================================
-- 4. DUPLICATE CUSTOMER-MONTH CHECK
-- Should return 0 rows
-- =========================================

SELECT
    CustomerID,
    Month,
    COUNT(*) AS record_count
FROM monthly_usage
GROUP BY CustomerID, Month
HAVING COUNT(*) > 1;


-- =========================================
-- 5. CHURN DISTRIBUTION
-- =========================================

SELECT
    Churn,
    COUNT(*) AS customer_count
FROM churn
GROUP BY Churn
ORDER BY Churn;


-- =========================================
-- 6. DATA DATE RANGE
-- =========================================

SELECT
    MIN(SignupDate) AS earliest_signup,
    MAX(SignupDate) AS latest_signup
FROM customers;

SELECT
    MIN(Month) AS first_usage_month,
    MAX(Month) AS last_usage_month
FROM monthly_usage;


-- =========================================
-- 7. REFERENTIAL INTEGRITY CHECKS
-- Should return 0
-- =========================================

SELECT COUNT(*) AS usage_orphan_customers
FROM monthly_usage u
LEFT JOIN customers c
    ON u.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

SELECT COUNT(*) AS churn_orphan_customers
FROM churn ch
LEFT JOIN customers c
    ON ch.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;


-- =========================================
-- 8. BUSINESS RULE / FLAG VALIDATION
-- =========================================

SELECT
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    SUM(AgeMissing) AS imputed_age_count,
    SUM(ChargeReviewFlag) AS charge_review_count
FROM customers;


-- =========================================
-- 9. ANALYTICAL VIEW VALIDATION
-- =========================================

SELECT COUNT(*) AS analysis_view_count
FROM customer_churn_analysis;