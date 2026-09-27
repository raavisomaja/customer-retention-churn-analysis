CREATE DATABASE customer_retention;
USE customer_retention;
SELECT DATABASE();
CREATE TABLE customers (
    CustomerID VARCHAR(20) PRIMARY KEY,
    Age INT,
    Gender VARCHAR(10),
    Region VARCHAR(20),
    ContractType VARCHAR(20),
    MonthlyCharges DECIMAL(10,2),
    SignupDate DATE,
    AgeMissing TINYINT,
    ChargeReviewFlag TINYINT
);
DESCRIBE customers;
CREATE TABLE monthly_usage (
    CustomerID VARCHAR(20) NOT NULL,
    Month DATE NOT NULL,
    CallMinutes DECIMAL(10,2),
    DataUsageGB DECIMAL(10,2),
    SMSCount INT,
    Complaints INT,

    PRIMARY KEY (CustomerID, Month),

    FOREIGN KEY (CustomerID)
        REFERENCES customers(CustomerID)
);
DESCRIBE monthly_usage;
CREATE TABLE churn (
    CustomerID VARCHAR(20) PRIMARY KEY,
    Churn TINYINT NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES customers(CustomerID)
);
DESCRIBE churn;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM monthly_usage;
SELECT COUNT(*) FROM churn;
SELECT COUNT(*) FROM customers;
SELECT * FROM customers LIMIT 5;
SELECT COUNT(*) AS customer_count
FROM customers;
SELECT COUNT(*) AS usage_count
FROM monthly_usage;
SELECT COUNT(DISTINCT CustomerID) AS unique_customers
FROM monthly_usage;
SELECT
    MIN(month_count) AS min_months,
    MAX(month_count) AS max_months
FROM (
    SELECT CustomerID, COUNT(*) AS month_count
    FROM monthly_usage
    GROUP BY CustomerID
) x;
SELECT COUNT(*) AS churn_count
FROM churn;
SELECT COUNT(DISTINCT CustomerID) AS unique_customers
FROM churn;
SELECT Churn, COUNT(*) AS customer_count
FROM churn
GROUP BY Churn;
