USE healthcare_analysis;

-- Run once after 00_setup.sql and 01_data_check.sql.
-- Raw data remains unchanged.
-- Assumption: matching values across all 15 source columns
-- represent duplicate copies; retain the lowest record_id.

/*
Working on cleaning duplicate rows
*/

CREATE TABLE admissions_clean LIKE healthcare_dataset;

INSERT INTO admissions_clean
SELECT *
FROM healthcare_dataset
WHERE record_id IN (
    SELECT MIN(record_id)
    FROM healthcare_dataset
    GROUP BY
        `Name`,
        `Age`,
        `Gender`,
        `Blood Type`,
        `Medical Condition`,
        `Date of Admission`,
        `Doctor`,
        `Hospital`,
        `Insurance Provider`,
        `Billing Amount`,
        `Room Number`,
        `Admission Type`,
        `Discharge Date`,
        `Medication`,
        `Test Results`
);

-- Verify the number of records retained.
SELECT COUNT(*) AS cleaned_records
FROM admissions_clean;

-- Changing Datatype of Date columns

ALTER TABLE healthcare_analysis.admissions_clean
    MODIFY COLUMN `Date of Admission` DATE,
    MODIFY COLUMN `Discharge Date` DATE;


DESCRIBE admissions_clean;

-- Adding a new column Length of Stay

ALTER TABLE healthcare_analysis.admissions_clean
ADD COLUMN length_of_stay_days INT
GENERATED ALWAYS AS (
    DATEDIFF(`Discharge Date`, `Date of Admission`)
) STORED;

-- Checking negative Billing amount

ALTER TABLE healthcare_analysis.admissions_clean
ADD COLUMN negative_bill_flag TINYINT
GENERATED ALWAYS AS (
    CASE WHEN `Billing Amount` < 0 THEN 1 ELSE 0 END
) STORED;

SELECT SUM(negative_bill_flag) AS negative_bills
FROM healthcare_analysis.admissions_clean;

-- Retained 106 negative billing records and flagged them for review.
-- Deduplication removed 2 additional negative-bill copies.


SELECT
    SUM(LENGTH(`Gender`) <> LENGTH(TRIM(`Gender`))) AS gender_spaces,
    SUM(LENGTH(`Blood Type`) <> LENGTH(TRIM(`Blood Type`))) AS blood_type_spaces,
    SUM(LENGTH(`Medical Condition`) <> LENGTH(TRIM(`Medical Condition`))) AS condition_spaces,
    SUM(LENGTH(`Doctor`) <> LENGTH(TRIM(`Doctor`))) AS doctor_spaces,
    SUM(LENGTH(`Hospital`) <> LENGTH(TRIM(`Hospital`))) AS hospital_spaces,
    SUM(LENGTH(`Insurance Provider`) <> LENGTH(TRIM(`Insurance Provider`))) AS insurance_spaces,
    SUM(LENGTH(`Admission Type`) <> LENGTH(TRIM(`Admission Type`))) AS admission_type_spaces,
    SUM(LENGTH(`Medication`) <> LENGTH(TRIM(`Medication`))) AS medication_spaces,
    SUM(LENGTH(`Test Results`) <> LENGTH(TRIM(`Test Results`))) AS test_result_spaces
FROM healthcare_analysis.admissions_clean;

-- Checked all text columns for leading/trailing spaces; none found.

SELECT
    COUNT(*) AS cleaned_records,
    COUNT(DISTINCT record_id) AS unique_record_ids,
    SUM(`Date of Admission` IS NULL) AS missing_admission_dates,
    SUM(`Discharge Date` IS NULL) AS missing_discharge_dates,
    MIN(length_of_stay_days) AS shortest_stay_days,
    MAX(length_of_stay_days) AS longest_stay_days,
    SUM(length_of_stay_days < 0) AS negative_stays,
    SUM(negative_bill_flag) AS negative_bills
FROM healthcare_analysis.admissions_clean;









