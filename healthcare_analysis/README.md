# Healthcare Admissions and Billing Analysis

A MySQL portfolio project exploring admission volume, hospital stays, and billing patterns.

**Status (September 30, 2026):** Data checks, cleaning, and exploratory analysis completed. SQL scripts and exported results are included.

## Dataset and tools

- Tools: MySQL and MySQL Workbench
- Source file: `data_source/healthcare_dataset.csv`
- Original dataset: 55,500 records and 15 columns
- Cleaned dataset: 54,966 records
- Database: `healthcare_analysis`
- Raw table: `healthcare_dataset`
- Cleaned table: `admissions_clean`
- Admission dates: May 8, 2019–May 7, 2024

## Project files

| File or folder | Purpose |
|---|---|
| `00_setup.sql` | Database setup and surrogate primary key |
| `01_data_check.sql` | Missing values, dates, duplicates, categories, and numeric checks |
| `02_data_cleaning.sql` | Duplicate removal, date conversion, and generated columns |
| `03_analysis.sql` | Analysis queries and observations |
| `data_source/` | Original dataset |
| `results/` | Exported analysis results |

## Data checks

| Check | Finding |
|---|---|
| Import count | 55,500 records loaded |
| Missing values | No NULL or blank values across the 15 source columns |
| Dates | No conversion failures or discharge dates before admission |
| Duplicates | 534 matching groups containing 1,068 rows and 534 extra copies |
| Categories | Reviewed condition, admission type, gender, blood type, insurance, medication, and test results |
| Age | 13–89; no negative ages |
| Billing | 108 negative amounts; range −2,008.49 to 52,764.28 |
| Room numbers | 101–500 |

## Data cleaning

The original table was preserved. Cleaning was performed in a separate table, `admissions_clean`.

- Retained one row per group matching across all 15 source columns, choosing the smallest `record_id`.
- Removed 534 extra copies, leaving 54,966 records.
- Converted admission and discharge columns from `TEXT` to `DATE`.
- Added `length_of_stay_days` as a stored generated column using `DATEDIFF`.
- Added `negative_bill_flag` as a stored generated column.
- Retained negative billing amounts because their meaning is unconfirmed.
- Checked all text columns for leading and trailing ordinary spaces; none were found.

Duplicate removal assumes matching rows represent extra copies. Without an original admission identifier, this assumption cannot be independently verified.

### Final validation

| Check | Result |
|---|---:|
| Cleaned records | 54,966 |
| Unique record IDs | 54,966 |
| Missing admission dates | 0 |
| Missing discharge dates | 0 |
| Shortest stay | 1 day |
| Longest stay | 30 days |
| Negative stays | 0 |
| Negative bills retained and flagged | 106 |

Deduplication removed two extra copies with negative billing amounts.


## Key findings

### Medical conditions

- Arthritis had the most admissions: 9,218.
- Arthritis also accounted for the most total hospital days: 142,918.
- Asthma had the fewest admissions, 9,095, but ranked second in total hospital days, 142,585.
- Asthma had the longest average stay: 15.68 days.
- Average stays across conditions were similar, ranging from 15.43 to 15.68 days.
- Obesity had the highest average bill, 25,804.36; Cancer had the lowest, 25,152.32.

### Admission types

- Average stays ranged from 15.40 days for Urgent to 15.58 days for Emergency.
- Elective admissions had the highest average bill: 25,612.14.
- Differences in average stays and billing were small across admission types.

### Age groups

- The 65+ group had the most admissions: 16,923.
- Average stays ranged from 15.32 to 15.58 days.
- The under-18 group contained only 116 records, so its average needs cautious interpretation.

### Insurance providers

- Medicare had the highest average bill: 25,628.32.
- UnitedHealthcare had the lowest: 25,414.51.
- The difference was 213.81, approximately 0.84% of the lower average.
- Cigna had the most admission records: 11,139.

### Monthly admissions

- Full-month counts ranged from 772 in February 2022 to 1,003 in August 2020.
- The monthly table showed no obvious sustained increase or decrease.
- May 2019 and May 2024 were partial months because the dataset begins May 8, 2019 and ends May 7, 2024.
- These boundary months should be excluded from full-month comparisons.
- Different month lengths also affect admission counts.

### Impact of negative bills

| Measure | Including negative bills | Excluding negative bills |
|---|---:|---:|
| Average billing amount | 25,544.31 | 25,594.63 |
| Total billing amount | 1,404,068,339.23 | 1,404,121,601.31 |

- Negative bills affected 106 records, approximately 0.19% of admissions.
- Excluding them increased average billing by 50.33, approximately 0.20%.
- Total billing increased by 53,262.08.
- The average difference was calculated before rounding.
- All other reported billing averages include negative bills.

## Exported results

- [Medical condition summary](results/medical_condition_summary.csv)
- [Admission type summary](results/admission_type_summary.csv)
- [Age group summary](results/age_group_summary.csv)
- [Insurance provider summary](results/insurance_provider_summary.csv)
- [Monthly admissions](results/monthly_admissions.csv)
- [Negative billing impact](results/negative_bill_impact.csv)

The `patients_admitted` header in some exports represents admission records, not unique patients.

## How to reproduce

1. Create the `healthcare_analysis` database using the database-creation statement in `00_setup.sql`.
2. Import the source CSV into `healthcare_dataset` using MySQL Workbench's Table Data Import Wizard.
3. Complete the remaining setup statements, adding `record_id` only once.
4. Run `01_data_check.sql`.
5. Run `02_data_cleaning.sql` once to create and prepare `admissions_clean`.
6. Run the queries in `03_analysis.sql`.
7. Export each summary result as a CSV with column headers into `results/`.

## Limitations

- `record_id` identifies a row, not a unique patient or independently verified admission.
- Findings describe this dataset and do not establish clinical causes or hospital performance.
- Insurance comparisons do not show that providers cause billing differences.
- Age groups span unequal ranges, and population totals are unavailable; counts do not measure admission risk.
- Total hospital days sum elapsed stays and do not directly measure occupancy or capacity.
- Negative bills may represent adjustments or errors; their meaning is unconfirmed.
- Billing currency and dataset provenance have not yet been documented.
- Billing amounts should not be interpreted as verified payments or revenue.