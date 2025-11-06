CREATE DATABASE warranty_analysis;
USE warranty_analysis;

SELECT * FROM vehicles_clean;
SELECT COUNT(*) FROM vehicles_clean;

SELECT * FROM service_records_clean;
SELECT COUNT(*) FROM service_records_clean;

SELECT * FROM warranty_claims_clean;
SELECT COUNT(*) FROM warranty_claims_clean;

SELECT * FROM sensor_data_clean;
SELECT COUNT(*) FROM sensor_data_clean;

CREATE TABLE vehicles
SELECT * FROM vehicles_clean;

CREATE TABLE service_records
SELECT * FROM service_records_clean;

CREATE TABLE warranty_claims
SELECT * FROM warranty_claims_clean;

CREATE TABLE sensor_data
SELECT * FROM sensor_data_clean;

