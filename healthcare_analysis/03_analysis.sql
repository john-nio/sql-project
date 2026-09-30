USE healthcare_analysis;

DESCRIBE admissions_clean

-- Which medical conditions have the most admissions, and how does average length of stay differ?
SELECT
    `Medical Condition`,
    COUNT(*) AS no_of_admissions,
    SUM(length_of_stay_days) AS total_hospital_days,
    ROUND(AVG(length_of_stay_days), 2) AS avg_stay_days,
    ROUND(AVG(`Billing Amount`), 2) AS avg_bill
FROM admissions_clean
GROUP BY `Medical Condition`
ORDER BY total_hospital_days DESC;

/*
- Arthritis has the most admissions: 9,218.
- Asthma has the longest average stay: 15.68 days.
- Counts and average stays are similar across conditions. 
- The difference between the longest and shortest average stay is only 0.25 days, roughly six hours.
- Total hospital days are similar across conditions.
*/


-- Do emergency, urgent, and elective admissions differ in average stay?

SELECT `Admission Type`, COUNT(*) AS patients_admitted, AVG(length_of_stay_days) AS avg_stay_days,
ROUND(AVG(`Billing Amount`), 2) AS avg_bill
FROM admissions_clean
GROUP BY `Admission Type`;

-- Average stays are similar across admission types (15.40–15.58 days).
-- Average bills range from 25,505.33 to 25,612.14, including negative bills.
-- How do admission counts and average stays differ across age groups?

SELECT
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age < 35 THEN '18–34'
        WHEN Age < 50 THEN '35–49'
        WHEN Age < 65 THEN '50–64'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS no_of_admissions,
    ROUND(AVG(length_of_stay_days), 2) AS avg_stay_days
FROM healthcare_analysis.admissions_clean
GROUP BY age_group
ORDER BY MIN(Age);

-- The 65+ group has the highest admission count (16,923).
-- Average stays vary little across age groups (15.32–15.58 days).
-- The under-18 group contains only 116 records.

-- How do billing amounts differ by insurance provider?

SELECT `Insurance Provider`, COUNT(*) AS patients_admitted, AVG(length_of_stay_days) AS avg_stay_days,
ROUND(AVG(`Billing Amount`), 2) AS avg_bill
FROM admissions_clean
GROUP BY `Insurance Provider`

-- Average bills range from 25,414.51 to 25,628.32 across providers,
-- including negative bills. These averages are descriptive;
-- they do not establish that the insurer causes billing differences.

-- How does admission volume change by month? Are the first and last months complete?
SELECT
    DATE_FORMAT(`Date of Admission`, '%Y-%m') AS admission_month,
    COUNT(*) AS no_of_admissions
FROM admissions_clean
GROUP BY admission_month
ORDER BY admission_month;
-- Monthly admission counts show no obvious sustained trend.

SELECT
    MIN(`Date of Admission`) AS first_admission_date,
    MAX(`Date of Admission`) AS last_admission_date
FROM admissions_clean;

-- Admission dates span 2019-05-08 to 2024-05-07.
-- May 2019 and May 2024 are partial months.
-- Exclude these boundary months when comparing full-month counts.


-- How much do the 106 negative bills affect overall billing summaries?

SELECT
    COUNT(*) AS total_admissions,
    SUM(negative_bill_flag) AS negative_bills,
    ROUND(AVG(`Billing Amount`), 2) AS avg_bill_all,
    ROUND(
        AVG(CASE
            WHEN negative_bill_flag = 0 THEN `Billing Amount`
        END), 2
    ) AS avg_bill_nonnegative,
    ROUND(
        AVG(CASE
            WHEN negative_bill_flag = 0 THEN `Billing Amount`
        END) - AVG(`Billing Amount`), 2
    ) AS average_difference,
    ROUND(SUM(`Billing Amount`), 2) AS total_bill_all,
    ROUND(
        SUM(CASE
            WHEN negative_bill_flag = 0 THEN `Billing Amount`
        END), 2
    ) AS total_bill_nonnegative
FROM healthcare_analysis.admissions_clean;


-- Negative bills affect 106 of 54,966 records (approximately 0.19%).
-- Excluding them increases average billing by 50.33 (approximately 0.20%)
-- and total billing by 53,262.08.
-- Retain and flag these records because their meaning is unconfirmed.
