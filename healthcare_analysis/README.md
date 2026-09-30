# Healthcare Admissions and Billing Analysis

A MySQL portfolio project exploring hospital admissions, length of stay, and billing patterns.

**Status (September 29, 2026):** Initial data checks completed. Data cleaning and business analysis are next.

## Dataset and tools

- Source file: `data_source/healthcare_dataset.csv`
- 55,500 records and 15 original columns
- Database/table: `healthcare_analysis.healthcare_dataset`
- Tools: MySQL and MySQL Workbench

## Files

| File | Purpose |
| --- | --- |
| `setup.sql` | Table setup, including a generated `record_id` primary key |
| `01_data_check.sql` | Missing-value, date, duplicate, category, and numeric checks |
| `data_source/healthcare_dataset.csv` | Original source data |

The generated `record_id` identifies an imported row, not a unique patient or verified admission.

## Checks completed

| Check | Finding |
| --- | --- |
| Import count | All 55,500 records loaded |
| Missing values | No NULL values across the 15 source columns; no empty or space-only text values |
| Dates | Both date columns parsed successfully; no discharge dates precede admission |
| Duplicates | 534 matching groups, containing 1,068 rows and 534 extra copies |
| Categories | Reviewed admission type, medical condition, gender, test results, blood type, insurance provider, and medication |
| Age | 13–89; no negative ages |
| Billing | 108 negative amounts; range from −2,008.49 to 52,764.28 |
| Room numbers | 101–500 |

Duplicate checks compare all 15 source columns and exclude `record_id`. Negative bills remain unchanged because their meaning has not been established.

## Next steps

1. Create a separate cleaned table while preserving the imported data.
2. Document the duplicate-handling decision and flag negative bills.
3. Convert dates and prepare length of stay for analysis.
4. Compare admissions, stay length, and billing by admission type and medical condition.

## Running the checks

Import the source CSV into `healthcare_analysis.healthcare_dataset` using MySQL Workbench. Run the setup statements as needed, then run `01_data_check.sql`. Run the primary-key creation statement only once; repeating it after `record_id` exists will cause an error.
