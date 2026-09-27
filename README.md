Customer Retention & Churn Analysis

Project Overview

This project analyzes customer retention and churn patterns for a telecommunications business using Python, SQL, Excel, and Tableau.

The goal is to transform raw customer and usage data into a validated analytical dataset, identify patterns associated with customer churn, and present the findings through an interactive Tableau dashboard.

Business Problem

Customer churn can affect recurring revenue and long-term customer value. The objective of this analysis is to understand:

* How many customers are retained versus churned
* Overall customer churn rate
* How churn varies by contract type
* How churn varies across regions
* Whether churn patterns differ by customer tenure
* How churn varies across complaint levels
* Which customer segments may require further investigation

⸻

Project Workflow

Raw Data → Python/Pandas Cleaning → MySQL/SQL Analysis → Excel Validation → Tableau Dashboard

Raw Customer Data
       ↓
Python / Pandas
Data Cleaning & Validation
       ↓
MySQL / SQL
Data Analysis & Aggregation
       ↓
Excel
KPI & Pivot Validation
       ↓
Tableau Public
Interactive Dashboard

⸻

Dataset

The project uses three related datasets.

Customer Information

Contains customer-level information such as:

* Customer ID
* Age
* Gender
* Region
* Contract Type
* Monthly Charges
* Signup Date

Usage Data

Contains monthly customer activity including:

* Customer ID
* Month
* Call Minutes
* Data Usage
* SMS Count
* Complaints

Churn Labels

Contains:

* Customer ID
* Churn indicator

Where:

* 0 = Retained
* 1 = Churned

⸻

Data Cleaning & Preparation

Python and Pandas were used to profile, clean, validate, and prepare the datasets for analysis.

Key data preparation steps included:

* Identifying and handling duplicate customer records
* Reducing the customer population to 10,000 unique customers
* Investigating missing age values
* Imputing missing age values using grouped median logic
* Creating an AgeMissing indicator
* Identifying negative monthly charge values for review
* Creating a ChargeReviewFlag
* Validating dates and customer IDs
* Checking referential integrity across datasets
* Aggregating monthly usage metrics to the customer level
* Calculating average monthly call minutes
* Calculating average monthly data usage
* Calculating average monthly SMS usage
* Calculating total complaints
* Calculating customer tenure in months

The final analytical dataset contains 10,000 customer records.

⸻

SQL Analysis

MySQL was used to structure and analyze the cleaned data.

SQL work included:

* Database and schema creation
* Table creation
* Data validation
* Customer-level aggregation
* Churn analysis
* Grouping and filtering
* Contract and regional analysis
* KPI calculations

SQL scripts are included in the sql/ folder.

⸻

Excel Validation

Excel was used as an additional validation and analysis layer.

The analytical dataset was used to validate key metrics and create pivot-based analysis.

Validated KPIs

Metric	Result
Total Customers	10,000
Churned Customers	786
Retained Customers	9,214
Churn Rate	7.86%
Average Monthly Charge	$51.03
Average Tenure	38.6 months
Average Total Complaints	6.04

⸻

Key Findings

Churn by Contract Type

Contract Type	Churn Rate
Monthly	7.56%
Prepaid	7.67%
Yearly	8.82%

The observed churn rates differ across contract types, with yearly-contract customers showing the highest observed churn rate in this dataset.

Churn by Region

Region	Churn Rate
Rural	7.40%
Suburban	8.05%
Urban	8.12%

Urban and suburban customers have higher observed churn rates than rural customers.

Contract × Region

The combination of contract type and region shows additional variation in observed churn rates.

Contract Type	Rural	Suburban	Urban
Monthly	7.01%	6.94%	8.81%
Prepaid	6.72%	8.79%	7.50%
Yearly	9.45%	8.89%	8.09%

Churn by Tenure

Tenure Group	Churn Rate
<1 Year	7.50%
1-2 Years	8.10%
2-3 Years	8.27%
3-4 Years	7.34%
4-5 Years	7.69%
5+ Years	8.06%

Churn varies across tenure groups, with the 2–3 year group showing the highest observed rate in this analysis.

Churn by Complaints

Complaint Group	Churn Rate
0-3	8.09%
4-7	7.34%
8-11	8.91%
12+	8.96%

Higher complaint groups show elevated observed churn rates in this dataset. This represents an observed relationship and does not establish that complaints directly cause churn.

⸻

Tableau Dashboard

The final Tableau Public dashboard provides an interactive view of customer retention and churn.

The dashboard includes:

* Total Customers KPI
* Churned Customers KPI
* Churn Rate KPI
* Average Monthly Charge KPI
* Average Tenure KPI
* Average Complaints KPI
* Churn by Contract Type
* Churn by Tenure
* Contract × Region Churn Heatmap
* Churn by Complaint Group
* Contract Type filter
* Region filter

Dashboard Preview

Interactive Dashboard

The interactive dashboard is published on Tableau Public:


[View Customer Retention & Churn Analysis on Tableau Public](https://public.tableau.com/app/profile/somaja.raavi/viz/Book1_17904964463880/CustomerRetentionDashboard)

⸻

Tools & Technologies

* Python
* Pandas
* Jupyter Notebook
* MySQL
* SQL
* Microsoft Excel
* Tableau Public
* Git
* GitHub

⸻

Project Structure

customer-retention-analysis/
│
├── data/
│   └── processed/
│       └── customer_churn_analysis.csv
│
├── excel/
│   └── customer_churn_analysis.xlsx
│
├── notebooks/
│   ├── 01_data_profiling.ipynb
│   └── 02_data_cleaning.ipynb
│
├── screenshots/
│   └── customer-retention-dashboard.png
│
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_data_validation.sql
│   └── 03_churn_analysis.sql
│
├── .gitignore
└── README.md

⸻

Data Privacy

Raw customer-level source files are not included in this public repository.

Temporary files, local Python environments, and intermediate data files are excluded through .gitignore.

The repository contains the final analytical dataset used for the project and supporting analysis files.

⸻

Limitations

This analysis is descriptive and focuses on observed churn patterns within the available dataset.

The results identify relationships and segment-level differences but do not establish causation.

The project does not currently use predictive machine learning models. The focus is on data cleaning, SQL analysis, business intelligence, visualization, and exploratory customer retention analysis.

⸻

Future Improvements

Potential future enhancements include:

* Building a repeatable ETL workflow in Alteryx
* Adding additional customer behavior features
* Expanding dashboard interactivity
* Adding revenue-at-risk analysis
* Creating customer segmentation analysis
* Developing retention-focused business recommendations
* Exploring predictive churn modeling as a separate extension

⸻

Author

Somaja Raavi

Data Analytics Engineering | Data Analysis | SQL | Python | Excel | Tableau