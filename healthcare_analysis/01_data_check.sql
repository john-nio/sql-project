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

-- Checking for Null Values

SELECT
    COUNT(*) AS total_records,
    SUM(`Name` IS NULL OR TRIM(`Name`) = '') AS missing_names,
    SUM(`Age` IS NULL) AS missing_ages,
    SUM(
        `Date of Admission` IS NULL
        OR TRIM(`Date of Admission`) = ''
    ) AS missing_admission_dates,
    SUM(
        `Discharge Date` IS NULL
        OR TRIM(`Discharge Date`) = ''
    ) AS missing_discharge_dates,
    SUM(`Billing Amount` IS NULL) AS missing_bills,
    SUM(`Gender` IS NULL OR TRIM(`Gender`) = '') AS missing_gender,
    SUM(`Blood Type` IS NULL OR TRIM(`Blood Type`) = '') AS missing_blood_type,
    SUM(`Medical Condition` IS NULL OR TRIM(`Medical Condition`) = '') AS missing_condition,
    SUM(`Doctor` IS NULL OR TRIM(`Doctor`) = '') AS missing_doctor,
    SUM(`Hospital` IS NULL OR TRIM(`Hospital`) = '') AS missing_hospital,
    SUM(`Insurance Provider` IS NULL OR TRIM(`Insurance Provider`) = '') AS missing_insurance,
    SUM(`Room Number` IS NULL) AS missing_room_number,
    SUM(`Admission Type` IS NULL OR TRIM(`Admission Type`) = '') AS missing_admission_type,
    SUM(`Medication` IS NULL OR TRIM(`Medication`) = '') AS missing_medication,
    SUM(`Test Results` IS NULL OR TRIM(`Test Results`) = '') AS missing_test_results
FROM healthcare_analysis.healthcare_dataset;

-- No Null values found in  15 columns

-- Checking for Invalid dates

SELECT
    SUM(STR_TO_DATE(`Date of Admission`, '%Y-%m-%d') IS NULL)
        AS invalid_admission_dates,
    SUM(STR_TO_DATE(`Discharge Date`, '%Y-%m-%d') IS NULL)
        AS invalid_discharge_dates,
    SUM(
        STR_TO_DATE(`Discharge Date`, '%Y-%m-%d')
        < STR_TO_DATE(`Date of Admission`, '%Y-%m-%d')
    ) AS discharge_before_admission
FROM healthcare_analysis.healthcare_dataset;

-- Both date columns parsed successfully.
-- No discharge dates precede admission dates.

-- Checking for duplicates

SELECT
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
    `Test Results`,
    COUNT(*) AS occurrences
FROM healthcare_analysis.healthcare_dataset
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
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

SELECT
    COUNT(*) AS duplicate_groups,
    SUM(occurrences) AS rows_in_duplicate_groups,
    SUM(occurrences - 1) AS extra_copies
FROM (
    SELECT COUNT(*) AS occurrences
    FROM healthcare_analysis.healthcare_dataset
    GROUP BY
        `Name`, `Age`, `Gender`, `Blood Type`,
        `Medical Condition`, `Date of Admission`,
        `Doctor`, `Hospital`, `Insurance Provider`,
        `Billing Amount`, `Room Number`, `Admission Type`,
        `Discharge Date`, `Medication`, `Test Results`
    HAVING COUNT(*) > 1
) AS duplicate_summary;

-- Found 534 duplicate groups, each containing 2 records.
-- These groups contain 1,068 rows, including 534 extra copies.


-- Inspecting Category Labels

SELECT
    `Admission Type`,
    COUNT(*) AS records
FROM healthcare_analysis.healthcare_dataset
GROUP BY `Admission Type`
ORDER BY records DESC;


/* # Admission Type, records
'Elective', '18655'
'Urgent', '18576'
'Emergency', '18269'
*/



SELECT
    `Medical Condition`,
    COUNT(*) AS records
FROM healthcare_analysis.healthcare_dataset
GROUP BY `Medical Condition`
ORDER BY records DESC;

/* Medical Condition, records
'Arthritis', '9308'
'Diabetes', '9304'
'Hypertension', '9245'
'Obesity', '9231'
'Cancer', '9227'
'Asthma', '9185'
*/


SELECT `Gender`, COUNT(*) AS records
FROM healthcare_analysis.healthcare_dataset
GROUP BY `Gender`;

/* # Gender, records
'Male', '27774'
'Female', '27726'
*/

SELECT `Test Results`, COUNT(*) AS records
FROM healthcare_analysis.healthcare_dataset
GROUP BY `Test Results`;

/* # Test Results, records
'Normal', '18517'
'Inconclusive', '18356'
'Abnormal', '18627'
*/


SELECT `Blood Type`, COUNT(*) AS records
FROM healthcare_analysis.healthcare_dataset
GROUP BY `Blood Type`;
/* # Blood Type, records
'B-', '6944'
'A-', '6969'
'O+', '6917'
'AB+', '6947'
'A+', '6956'
'B+', '6945'
'AB-', '6945'
'O-', '6877'
*/
SELECT `Insurance Provider`, COUNT(*) AS records
FROM healthcare_analysis.healthcare_dataset
GROUP BY `Insurance Provider`;
/* # Insurance Provider, records
'Blue Cross', '11059'
'Medicare', '11154'
'UnitedHealthcare', '11125'
'Cigna', '11249'
'Aetna', '10913'
*/
SELECT `Medication`, COUNT(*) AS records
FROM healthcare_analysis.healthcare_dataset
GROUP BY `Medication`;
/* # Medication, records
'Paracetamol', '11071'
'Lipitor', '11140'
'Penicillin', '11068'
'Ibuprofen', '11127'
'Aspirin', '11094'
*/


-- Checking Numerical Ranges


SELECT
    MIN(`Age`) AS minimum_age,
    MAX(`Age`) AS maximum_age,
    SUM(`Age` < 0) AS negative_ages,
    MIN(`Billing Amount`) AS minimum_bill,
    MAX(`Billing Amount`) AS maximum_bill,
    SUM(`Billing Amount` < 0) AS negative_bills,
    MIN(`Room Number`) AS minimum_room_number,
    MAX(`Room Number`) AS maximum_room_number
FROM healthcare_analysis.healthcare_dataset;




