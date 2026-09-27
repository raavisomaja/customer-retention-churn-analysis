USE customer_retention;
-- Overall customer churn rate

SELECT
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    ROUND(AVG(Churn) * 100, 2) AS churn_rate_pct
FROM churn;
SELECT
    c.ContractType,
    COUNT(*) AS total_customers,
    SUM(ch.Churn) AS churned_customers,
    ROUND(AVG(ch.Churn) * 100, 2) AS churn_rate_pct
FROM customers c
JOIN churn ch
    ON c.CustomerID = ch.CustomerID
GROUP BY c.ContractType
ORDER BY churn_rate_pct DESC;
WITH customer_complaints AS (
    SELECT
        CustomerID,
        SUM(Complaints) AS total_complaints
    FROM monthly_usage
    GROUP BY CustomerID
)

SELECT
    ch.Churn,
    COUNT(*) AS customers,
    ROUND(AVG(cc.total_complaints), 2) AS avg_complaints,
    ROUND(MIN(cc.total_complaints), 2) AS min_complaints,
    ROUND(MAX(cc.total_complaints), 2) AS max_complaints
FROM customer_complaints cc
JOIN churn ch
    ON cc.CustomerID = ch.CustomerID
GROUP BY ch.Churn;
WITH customer_usage AS (
    SELECT
        CustomerID,
        AVG(CallMinutes) AS avg_call_minutes,
        AVG(DataUsageGB) AS avg_data_usage,
        AVG(SMSCount) AS avg_sms
    FROM monthly_usage
    GROUP BY CustomerID
)

SELECT
    ch.Churn,
    COUNT(*) AS customers,
    ROUND(AVG(cu.avg_call_minutes), 2) AS avg_call_minutes,
    ROUND(AVG(cu.avg_data_usage), 2) AS avg_data_usage_gb,
    ROUND(AVG(cu.avg_sms), 2) AS avg_sms
FROM customer_usage cu
JOIN churn ch
    ON cu.CustomerID = ch.CustomerID
GROUP BY ch.Churn;
SELECT
    ch.Churn,
    COUNT(*) AS customers,
    ROUND(AVG(c.MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(MIN(c.MonthlyCharges), 2) AS min_monthly_charge,
    ROUND(MAX(c.MonthlyCharges), 2) AS max_monthly_charge
FROM customers c
JOIN churn ch
    ON c.CustomerID = ch.CustomerID
GROUP BY ch.Churn;
SELECT
    ch.Churn,
    COUNT(*) AS customers,
    ROUND(AVG(c.MonthlyCharges), 2) AS avg_monthly_charge
FROM customers c
JOIN churn ch
    ON c.CustomerID = ch.CustomerID
WHERE c.ChargeReviewFlag = 0
GROUP BY ch.Churn;
SELECT
    c.ContractType,
    c.Region,
    COUNT(*) AS total_customers,
    SUM(ch.Churn) AS churned_customers,
    ROUND(AVG(ch.Churn) * 100, 2) AS churn_rate_pct
FROM customers c
JOIN churn ch
    ON c.CustomerID = ch.CustomerID
GROUP BY
    c.ContractType,
    c.Region
ORDER BY churn_rate_pct DESC;
SELECT
    CASE
        WHEN c.Age BETWEEN 18 AND 29 THEN '18-29'
        WHEN c.Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN c.Age BETWEEN 50 AND 59 THEN '50-59'
        WHEN c.Age >= 60 THEN '60+'
    END AS age_group,

    COUNT(*) AS total_customers,
    SUM(ch.Churn) AS churned_customers,
    ROUND(AVG(ch.Churn) * 100, 2) AS churn_rate_pct

FROM customers c
JOIN churn ch
    ON c.CustomerID = ch.CustomerID

GROUP BY age_group
ORDER BY churn_rate_pct DESC;
SELECT
    CASE
        WHEN c.Age BETWEEN 18 AND 29 THEN '18-29'
        WHEN c.Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN c.Age BETWEEN 50 AND 59 THEN '50-59'
        WHEN c.Age >= 60 THEN '60+'
    END AS age_group,

    COUNT(*) AS total_customers,
    SUM(ch.Churn) AS churned_customers,
    ROUND(AVG(ch.Churn) * 100, 2) AS churn_rate_pct

FROM customers c
JOIN churn ch
    ON c.CustomerID = ch.CustomerID

WHERE c.AgeMissing = 0

GROUP BY age_group
ORDER BY churn_rate_pct DESC;
SELECT
    MIN(SignupDate) AS earliest_signup,
    MAX(SignupDate) AS latest_signup
FROM customers;
SELECT
    MIN(Month) AS first_usage_month,
    MAX(Month) AS last_usage_month
FROM monthly_usage;
WITH customer_tenure AS (
    SELECT
        CustomerID,
        TIMESTAMPDIFF(
            MONTH,
            SignupDate,
            '2023-12-31'
        ) AS tenure_months
    FROM customers
)

SELECT
    CASE
        WHEN ct.tenure_months < 12 THEN '<1 Year'
        WHEN ct.tenure_months < 24 THEN '1-2 Years'
        WHEN ct.tenure_months < 36 THEN '2-3 Years'
        WHEN ct.tenure_months < 48 THEN '3-4 Years'
        WHEN ct.tenure_months < 60 THEN '4-5 Years'
        ELSE '5+ Years'
    END AS tenure_group,

    COUNT(*) AS total_customers,
    SUM(ch.Churn) AS churned_customers,
    ROUND(AVG(ch.Churn) * 100, 2) AS churn_rate_pct

FROM customer_tenure ct
JOIN churn ch
    ON ct.CustomerID = ch.CustomerID

GROUP BY tenure_group
ORDER BY churn_rate_pct DESC;
SELECT DISTINCT Month
FROM monthly_usage
ORDER BY Month;
WITH usage_change AS (
    SELECT
        CustomerID,

        AVG(
            CASE
                WHEN Month BETWEEN '2023-01-01' AND '2023-03-31'
                THEN DataUsageGB
            END
        ) AS early_data_usage,

        AVG(
            CASE
                WHEN Month BETWEEN '2023-10-01' AND '2023-12-31'
                THEN DataUsageGB
            END
        ) AS late_data_usage

    FROM monthly_usage
    GROUP BY CustomerID
)

SELECT
    ch.Churn,
    COUNT(*) AS customers,

    ROUND(AVG(uc.early_data_usage), 2) AS avg_early_usage,
    ROUND(AVG(uc.late_data_usage), 2) AS avg_late_usage,

    ROUND(
        AVG(uc.late_data_usage - uc.early_data_usage),
        2
    ) AS avg_usage_change

FROM usage_change uc
JOIN churn ch
    ON uc.CustomerID = ch.CustomerID

GROUP BY ch.Churn;
WITH complaint_change AS (
    SELECT
        CustomerID,

        SUM(
            CASE
                WHEN Month BETWEEN '2023-01-01' AND '2023-03-31'
                THEN Complaints
                ELSE 0
            END
        ) AS early_complaints,

        SUM(
            CASE
                WHEN Month BETWEEN '2023-10-01' AND '2023-12-31'
                THEN Complaints
                ELSE 0
            END
        ) AS late_complaints

    FROM monthly_usage
    GROUP BY CustomerID
)

SELECT
    ch.Churn,
    COUNT(*) AS customers,
    ROUND(AVG(cc.early_complaints), 2) AS avg_early_complaints,
    ROUND(AVG(cc.late_complaints), 2) AS avg_late_complaints,
    ROUND(
        AVG(cc.late_complaints - cc.early_complaints),
        2
    ) AS avg_complaint_change

FROM complaint_change cc
JOIN churn ch
    ON cc.CustomerID = ch.CustomerID

GROUP BY ch.Churn;
WITH customer_segments AS (
    SELECT
        c.CustomerID,
        c.ContractType,
        c.Region,

        CASE
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 12
                THEN '<1 Year'
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 24
                THEN '1-2 Years'
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 36
                THEN '2-3 Years'
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 48
                THEN '3-4 Years'
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 60
                THEN '4-5 Years'
            ELSE '5+ Years'
        END AS tenure_group

    FROM customers c
)

SELECT
    cs.ContractType,
    cs.Region,
    cs.tenure_group,
    COUNT(*) AS customers,
    SUM(ch.Churn) AS churned_customers,
    ROUND(AVG(ch.Churn) * 100, 2) AS churn_rate_pct

FROM customer_segments cs
JOIN churn ch
    ON cs.CustomerID = ch.CustomerID

GROUP BY
    cs.ContractType,
    cs.Region,
    cs.tenure_group

HAVING COUNT(*) >= 100

ORDER BY churn_rate_pct DESC
LIMIT 10;
WITH customer_segments AS (
    SELECT
        c.CustomerID,
        c.ContractType,
        c.Region,

        CASE
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 12 THEN '<1 Year'
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 24 THEN '1-2 Years'
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 36 THEN '2-3 Years'
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 48 THEN '3-4 Years'
            WHEN TIMESTAMPDIFF(MONTH, c.SignupDate, '2023-12-31') < 60 THEN '4-5 Years'
            ELSE '5+ Years'
        END AS tenure_group

    FROM customers c
),

segment_metrics AS (
    SELECT
        cs.ContractType,
        cs.Region,
        cs.tenure_group,
        COUNT(*) AS customers,
        SUM(ch.Churn) AS churned_customers,
        ROUND(AVG(ch.Churn) * 100, 2) AS churn_rate_pct

    FROM customer_segments cs
    JOIN churn ch
        ON cs.CustomerID = ch.CustomerID

    GROUP BY
        cs.ContractType,
        cs.Region,
        cs.tenure_group

    HAVING COUNT(*) >= 100
)

SELECT
    DENSE_RANK() OVER (
        ORDER BY churn_rate_pct DESC
    ) AS risk_rank,

    ContractType,
    Region,
    tenure_group,
    customers,
    churned_customers,
    churn_rate_pct

FROM segment_metrics
ORDER BY risk_rank;
CREATE OR REPLACE VIEW customer_churn_analysis AS

SELECT
    c.CustomerID,
    c.Age,
    c.AgeMissing,
    c.Gender,
    c.Region,
    c.ContractType,
    c.MonthlyCharges,
    c.ChargeReviewFlag,
    c.SignupDate,

    TIMESTAMPDIFF(
        MONTH,
        c.SignupDate,
        '2023-12-31'
    ) AS TenureMonths,

    ROUND(AVG(u.CallMinutes), 2) AS AvgMonthlyCallMinutes,
    ROUND(AVG(u.DataUsageGB), 2) AS AvgMonthlyDataUsageGB,
    ROUND(AVG(u.SMSCount), 2) AS AvgMonthlySMS,

    SUM(u.Complaints) AS TotalComplaints,

    ch.Churn

FROM customers c

JOIN monthly_usage u
    ON c.CustomerID = u.CustomerID

JOIN churn ch
    ON c.CustomerID = ch.CustomerID

GROUP BY
    c.CustomerID,
    c.Age,
    c.AgeMissing,
    c.Gender,
    c.Region,
    c.ContractType,
    c.MonthlyCharges,
    c.ChargeReviewFlag,
    c.SignupDate,
    ch.Churn;
    SELECT COUNT(*)
FROM customer_churn_analysis;
SELECT *
FROM customer_churn_analysis
LIMIT 5;
SELECT COUNT(*)
FROM customer_churn_analysis;