-- ==============================================
-- Section 1: Vehicle table insights
-- ==============================================

-- 1. Different vehicle model.

SELECT DISTINCT(model) AS model
FROM  vehicles;

-- 2. Average mileage per model and year.

SELECT model, year, ROUND(AVG(mileage),2) AS average_mileage
FROM vehicles
GROUP BY model, year
ORDER BY year
;

-- 3. Count of vehicles per region.

SELECT region, COUNT(vehicle_id) AS vehicle_count
FROM vehicles
GROUP BY region
ORDER BY vehicle_count
;

-- 4. Vehicle having mileage above 100000 Km.

SELECT vehicle_id, model, mileage 
FROM vehicles
WHERE mileage > 100000
ORDER BY mileage DESC
;

-- 5. Vehicle count by manufacturing year.

SELECT year, COUNT(vehicle_id) AS vehicle_count
FROM vehicles
GROUP BY year
ORDER BY year 
;


-- ==============================================
-- Section 2. Service records table insights
-- ==============================================

-- 1. total number of service records.

SELECT COUNT(*) AS total_records
FROM service_records
;

-- 2.  Most frequently replaced component.

SELECT component_replaced, COUNT(component_replaced) replaced_count
FROM service_records
GROUP BY component_replaced
ORDER BY replaced_count DESC
LIMIT 1
; 

-- 3. Average and total service cost per component. 

SELECT component_replaced, ROUND(AVG(cost),2) AS avg_cost, SUM(cost) AS total_cost
FROM service_records 
GROUP BY component_replaced
ORDER BY total_cost DESC
;

-- 4. Average service cost by vehicle.

SELECT model, ROUND(AVG(COST),2) AS avg_service_cost 
FROM vehicles AS v
JOIN service_records AS s
	ON v.vehicle_id = s.vehicle_id
GROUP BY model
ORDER BY avg_service_cost DESC
;

-- 5. Most common issue type reported. 

SELECT issue_type, COUNT(issue_type) AS most_common_issue
FROM service_records
GROUP BY issue_type
ORDER BY most_common_issue DESC 
LIMIT 1
;

-- 6. How has a number of services changed over time. 

SELECT DATE_FORMAT(service_date, "%y-%m") AS serv_date, COUNT(service_id) AS service_count
FROM service_records
GROUP BY serv_date
ORDER BY serv_date
;


-- ==============================================
-- Section 3. Warranty claims table insights 
-- ==============================================

-- 1. Number of claims by claim status. 

SELECT claim_status, COUNT(claim_status) AS claim_status_number
FROM warranty_claims
GROUP BY claim_status
;

-- 2. Average claim amount by status. 

SELECT claim_status, ROUND(AVG(claim_amount),2) AS average_claim_amount
FROM warranty_claims
GROUP BY claim_status
ORDER BY claim_status
;

-- 3. Component with highest claim amount.

SELECT component, SUM(claim_amount) AS total_claims
FROM warranty_claims
GROUP BY component
ORDER BY total_claims DESC
LIMIT 1;

-- 4. Trend of claims over time. 

SELECT DATE_FORMAT(claim_date,"%y-%m") AS trend, COUNT(claim_id) AS number_of_claims
FROM warranty_claims
GROUP BY trend
ORDER BY trend
;

-- 5. Claim to service ratio per model.

SELECT model, COUNT(DISTINCT service_id) AS  total_services, COUNT(DISTINCT claim_id) AS total_claims,
ROUND(COUNT(DISTINCT claim_id) / COUNT(DISTINCT service_id),2) AS ratio
FROM vehicles AS v
LEFT JOIN service_records AS s
	ON v.vehicle_id = s.vehicle_id
LEFT JOIN warranty_claims AS w
	ON v.vehicle_id = w.vehicle_id
GROUP BY model
;


-- ==============================================
-- Section 4. Sensor data table insights
-- ==============================================

-- 1. Average engine temprature by model.

SELECT model, ROUND(AVG(engine_temp),2) AS average_temp
FROM vehicles AS v
JOIN sensor_data AS s
	ON v.vehicle_id = s.vehicle_id
GROUP BY model
ORDER BY average_temp
;

-- 2. Vehicle with engine temprature over 250.

SELECT vehicle_id, engine_temp
FROM sensor_data
WHERE engine_temp > 250
ORDER BY engine_temp
;

-- 3. Average RPM and fuel efficiency by model.

SELECT model, ROUND(AVG(rpm),2) AS average_RPM, ROUND(AVG(fueL_efficiency),2) AS average_fuel_effieiency
FROM vehicles AS v
JOIN sensor_data AS s
	ON v.vehicle_id = s.vehicle_id
GROUP BY model
ORDER BY model
;

-- 4. Most frequent error codes excluding error_code N/a.

SELECT error_code, COUNT(error_code) AS frequent_error_code
FROM sensor_data 
WHERE error_code <> 'N/A'
GROUP BY error_code
ORDER BY frequent_error_code DESC
LIMIT 1
;

-- 5. Trend of average engine temprature over time.

SELECT DATE_FORMAT(timestamp, "%y-%m") AS trend_over_time, AVG(engine_temp) AS average_temp
FROM sensor_data
GROUP BY trend_over_time
ORDER BY trend_over_time
;


-- ==============================================
-- =========== Key Analytical Insights ==========
-- ==============================================

-- Q1. Do vehicle with higher mileage make more service visits.

WITH service_summary AS (
	SELECT v.vehicle_id, COUNT(service_id) AS service_count
    FROM vehicles AS v
    JOIN service_records AS s
		ON v.vehicle_id = s.vehicle_id
	GROUP BY vehicle_id
),
summary AS (
	SELECT v.vehicle_id, model, mileage, service_count
    FROM vehicles AS v
    LEFT JOIN service_summary AS ss
		ON v.vehicle_id = ss.vehicle_id
	ORDER BY mileage DESC
)

SELECT model,
	CASE 
		WHEN mileage < 20000 THEN "<20K"
        WHEN mileage BETWEEN 20000 AND 50000 THEN "20K - 50K"
        WHEN mileage BETWEEN 50000 AND 80000 THEN "50K - 80K"
        WHEN mileage BETWEEN 80000 AND 100000 THEN "80K - 100K"
        ELSE ">100K"
	END AS mileage_band,
    ROUND(AVG(service_count),2) AS average_service_per_vehicle, COUNT(vehicle_id) AS count_of_total_vehicles
    FROM summary
    GROUP BY mileage_band, model
    ORDER BY model, FIELD(mileage_band,"<20K","20K - 50K","50K - 80K","80K - 100K",">100K")
;


-- Q2. Vehicle Age VS Service count trends.

WITH first_service AS (
	SELECT v.vehicle_id, MIN(service_date) AS first_service_date
	FROM vehicles AS v
	JOIN service_records AS s
		ON v.vehicle_id = s.vehicle_id
	GROUP BY v.vehicle_id
),
vehicle_age AS (
	SELECT v.vehicle_id, model,
	TIMESTAMPDIFF(YEAR, first_service_date, CURDATE()) AS vehicle_age_years
	FROM vehicles AS v
	JOIN first_service AS fs 
		ON v.vehicle_id = fs.vehicle_id
)

SELECT vehicle_id, model,
	CASE 
		WHEN vehicle_age_years <1 THEN "<1 Year"
        WHEN vehicle_age_years BETWEEN 1 AND 2 THEN "1-2 Years"
        WHEN vehicle_age_years BETWEEN 2 AND 3 THEN "2-3 Years"
        ELSE ">3 Years"
	END AS age_bucket
FROM vehicle_age
ORDER BY FIELD(age_bucket, "<1 Year", "1-2 Years", "2-3 Years", ">3 Years")
;

-- Q3. Top 3 model by average mileage.

WITH average_milage_per_model AS (
	SELECT model, ROUND(AVG(mileage),2) AS average_mileage 
    FROM vehicles 
    GROUP BY model
),
ranking AS (
SELECT model, average_mileage, ROW_NUMBER() OVER (ORDER BY average_mileage) AS top_3
FROM average_milage_per_model
)

SELECT *
FROM ranking
WHERE top_3 <= 3
;


-- Q4. Percentage of vehicles with warranty claims.

WITH vehicle_count AS (
	SELECT model, COUNT(vehicle_id) AS total_vehicle
	FROM vehicles 
	GROUP BY model 
),
claims AS (
	SELECT model, COUNT(DISTINCT v.vehicle_id) AS vehicle_with_claims
    FROM vehicles AS v
    JOIN warranty_claims AS w
		ON v.vehicle_id = w.vehicle_id
	GROUP BY model
)

SELECT vc.model, vc.total_vehicle,
COALESCE(c.vehicle_with_claims, 0) AS vehicle_with_claims,
ROUND(COALESCE(c.vehicle_with_claims, 0)/ vc.total_vehicle * 100,2) AS claim_percentage
FROM vehicle_count as vc
JOIN claims as c
	ON vc.model = c.model
ORDER BY claim_percentage DESC
;

-- Q5. Service frequency by Vehicle age.

WITH vehicle_age AS (
	SELECT vehicle_id, model, YEAR(CURDATE()) - year AS age
    FROM vehicles 
),
service_frequency AS (
	SELECT vehicle_id, COUNT(service_date) AS service_count
    FROM service_records
    GROUP BY vehicle_id
)

SELECT v.vehicle_id,model, age, service_count,
	CASE
		WHEN service_count <3 THEN "Low"
        WHEN service_count BETWEEN 3 AND 7 THEN "Medium"
        ELSE "High"
	END AS frequency_of_service
FROM vehicle_age AS v
JOIN service_frequency AS s
	ON v.vehicle_id = s.vehicle_id
ORDER BY service_count
;


-- Q6. Active vehicle trends.

WITH total_registered_vehicle AS (
	SELECT year, COUNT(vehicle_id) AS total_vehicles
    FROM vehicles 
    GROUP BY year
),
average_mileage_per_year AS (
	SELECT year, ROUND(AVG(mileage),2) AS average_mileage
    FROM vehicles 
    GROUP BY year
)

SELECT v.year, total_vehicles, average_mileage
FROM total_registered_vehicle AS v
JOIN average_mileage_per_year AS a
	ON v.year = a.year
ORDER BY v.year
;

-- Q7. Model reliability score.

WITH service_count AS (
	SELECT model, COUNT(service_id) AS total_service
    FROM vehicles AS v
    JOIN service_records AS s
		ON v.vehicle_id = s.vehicle_id
	GROUP BY model
),
model_mileage AS (
	SELECT model, ROUND(AVG(mileage),2) AS average_mileage
    FROM vehicles 
    GROUP BY model
)
SELECT s.model, average_mileage, total_service, ROUND(average_mileage/ total_service,2) AS reliability_score
FROM service_count AS s
JOIN model_mileage as m
	ON s.model = m.model
ORDER BY reliability_score DESC
;