CREATE DATABASE IF NOT EXISTS healthcare_analysis;

SELECT COUNT(*) AS rows_loaded
FROM healthcare_analysis.healthcare_dataset;

DESCRIBE healthcare_analysis.healthcare_dataset;

SELECT
    COUNT(*) AS rows_loaded,
    SUM(`Billing Amount` < 0) AS negative_bills,
    MIN(`Billing Amount`) AS lowest_bill,
    MAX(`Billing Amount`) AS highest_bill
FROM healthcare_analysis.healthcare_dataset;


-- Data Check and Cleaning

-- Adding surrogate key as the table doenst have a unique Primary key

ALTER TABLE healthcare_analysis.healthcare_dataset
ADD COLUMN record_id BIGINT UNSIGNED
NOT NULL auto_increment PRIMARY KEY FIRST;
