# automotive_warranty_analysis
An end-to-end data analysison vehicle performance, reliability adn warranty trends.

Project Overview:
This project simulates a real-world automotive analytics scenario, focusing on understanding vehicle reliability, service frequency, and warranty claim patterns using synthetic yet realistic data.
It covers the full data lifecycle — from raw CSVs to an interactive Power BI dashboard.


Objectives:
•	Analyze service and warranty claim patterns across vehicle models.
•	Identify high-maintenance vehicles and potential quality improvement areas.
•	Measure vehicle reliability based on mileage, service frequency, and age.
•	Provide actionable insights to reduce service costs and optimize warranty approval processes.


Steps Involved:
1. Early data exploration (Excel):
o Explored and validated raw dataset for inconsistency.   

2.	Data Preparation (Python):
o	Handled null values and inconsistencies.
o	Fixed text formatting and invalid entries.
o	Cleaned 4 major CSV datasets (Vehicles, Service Records, Warranty Claims, Sensor Data).

3.	Exploratory Analysis (SQL):
o	Used CTEs, subqueries, and window functions.
o	Derived key metrics like service frequency, claim ratio, reliability score, and age-based trends.

4.	Visualization (Power BI):
o	Built a fully interactive dashboard.
o	Integrated slicers for model, region, year, and claim status.
o	Used conditional formatting and KPIs for better storytelling.


Dataset Description:
| Table               | Rows    | Columns | Description                                    |
| ------------------- | ------- | ------- | ---------------------------------------------- |
| **Vehicles**        | 10,000  | 5       | Model, Year, Mileage, Region                   |
| **Service Records** | 60,000  | 6       | Service date, Component, Cost, Issue type      |
| **Warranty Claims** | 20,000  | 6       | Claim date, Status, Amount, Component          |
| **Sensor Data**     | 100,000 | 6       | Engine Temp, RPM, Fuel Efficiency, Error Codes |

Synthetic data generated using Python; designed to mimic real automotive data.


Key SQL Analysis:
| # | Analysis                  | Description                            |
| - | ------------------------- | -------------------------------------- |
| 1 | Average Service Cost      | Compared avg cost per component        |
| 2 | Claim-to-Service Ratio    | Model-wise claim efficiency            |
| 3 | Vehicle Reliability Score | Based on mileage per service           |
| 4 | Service Trend Analysis    | By year and vehicle age                |
| 5 | Engine Sensor Insights    | Linked overheating to lower efficiency |


Dashboard Highlights:
Built with Power BI → integrates cleaned SQL output with DAX measures and dynamic slicers.
KPIs Displayed:
•	Total Vehicles
•	Average Mileage
•	Claim Rate %
•	Reliability Score
•	Avg Service Cost
Key Visuals:
•	Claim Rate by Model (Bar Chart)
•	Service Trend by Year (Line Chart)
•	Reliability Score Comparison (Gradient Bars)
•	Service Frequency vs Vehicle Age (Column Chart)
•	Engine Temp vs Fuel Efficiency (Scatter Plot)

All visuals are interactive and respond to slicer.


Insights & Recommendations:
•	Vehicles older than 8 years show 25% higher service frequency.
•	TurboPro and AutoMax have the highest maintenance cost.
•	EcoDrive shows best claim approval rate (~88%).
•	High engine temperatures (>250°C) correspond to reduced fuel efficiency.
•	Proactive maintenance for high-mileage vehicles can cut warranty claims by ~15%.


Tools:
| Category                    | Tools Used            |
| ------------------------| ------------------------- |
| Data Cleaning and       | Python (pandas, numpy)    |
| exploration              and Excel                  |
| Data Storage & Querying | MySQL                     |
| Visualization           | Power BI                  |
| Documentation           | Excel, PowerPoint, GitHub |


Summary:
This project demonstrates an end-to-end data analytics workflow:
•	Realistic data cleaning
•	SQL-driven business analysis
•	Dynamic Power BI visualization




