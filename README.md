# TSA Claims Analysis

## Overview
This project involves analyzing TSA Claims data from 2002 to 2017 using **SAS Studio**. The goal is to clean and preprocess the data, identify issues, and generate dynamic reports answering key questions related to claim trends, claim types, and financial statistics. 

## Objectives
- **Data Cleaning & Preprocessing**:
  - Import `TSAClaims2002_2017.csv`.
  - Remove duplicate records.
  - Standardize missing values and incorrect formats.
  - Correct case formatting for state-related fields.
  - Identify and flag date-related issues.
  - Remove unnecessary columns.
  - Apply permanent formatting for currency and date fields.
  - Assign meaningful column labels.
  - Sort data by `Incident_Date`.

- **Report Generation**:
  - Exclude rows with date issues from the analysis.
  - Generate a trend analysis of TSA claims over the years.
  - Allow dynamic user input for state-specific claim breakdowns.

## Data Cleaning Steps
1. **Importing Data**: The raw data file (`TSAClaims2002_2017.csv`) is imported into the `WORK` library as `claims_cleaned`.
2. **Handling Missing Values**: 
   - Columns `Claim_Type`, `Claim_Site`, and `Disposition`: Missing or "-" values replaced with `Unknown`.
3. **Ensuring Standard Formatting**:
   - `StateName`: Proper case formatting.
   - `State`: Uppercase format.
   - `Currency`: Formatted with a dollar sign and two decimal places.
   - `Dates`: Formatted as `01JAN2000`.
4. **Creating a Date Issue Flag** (`Date_Issues` column):
   - Identifies cases where `Incident_Date` or `Date_Received` is missing.
   - Flags cases where `Incident_Date` > `Date_Received`.
   - Flags cases outside the valid range (2002-2017).
5. **Removing Unnecessary Columns**:
   - Dropped `County` and `City` fields.
6. **Sorting Data**:
   - Arranged by `Incident_Date` in ascending order.

## Report Generation
A **single PDF report** was generated, answering the following:

1. **Date Issues Analysis**:
   - How many date issues exist in the dataset?
   - **Result:** `4,241` date issues were identified.

2. **Annual TSA Claims Trends (2002-2017)**:
   - Count of claims per year.
   - **Result:** The highest number of claims was in 2004 (`28,484`), while the lowest was in 2017 (`8,340`).
   - **Visualization:** A frequency plot of claims per year.

3. **Dynamic State-Level Analysis (User Input Required)**:
   - For a selected state, the report includes:
     - **Claim Type Frequency** (e.g., Passenger Property Loss, Property Damage, etc.).
     - **Claim Site Frequency** (e.g., Checked Baggage, Checkpoint, etc.).
     - **Disposition Frequency** (e.g., Approved in Full, Denied, Settled, etc.).
     - **Financial Overview** (Mean, Min, Max, and Sum of `Close_Amount`).

### **Example (Texas Analysis)**:
- **Claim Type Breakdown**:
  - Passenger Property Loss: `8,093`
  - Property Damage: `5,583`
- **Claim Site Breakdown**:
  - Checked Baggage: `11,139`
  - Checkpoint: `2,945`
- **Disposition Breakdown**:
  - Approved in Full: `3,279`
  - Denied: `6,369`
- **Financial Summary**:
  - Mean Close Amount: `$101`
  - Max Close Amount: `$106,000`
  - Sum of Close Amount: `$1,225,577`

## Files in This Repository
```
📂 TSA_Claims_Analysis/
 ├── 📜 TSA_Claims_Analysis.sas  # SAS script for data cleaning & report generation
 ├── 📜 TSAClaims2002_2017.csv  # Raw dataset (not uploaded due to size)
 ├── 📜 ClaimReports.pdf  # Final analysis report
 ├── 📜 README.md  # Project documentation (this file)
```

## How to Run the Code
1. Open **SAS Studio**.
2. Import `TSAClaims2002_2017.csv` into the `WORK` library.
3. Run `TSA_Claims_Analysis.sas`.
4. Review the generated `ClaimReports.pdf` for insights.

## Tools Used
- **SAS Studio** for data processing and analysis.
- **PROC FREQ, PROC FORMAT, PROC SORT, PROC REPORT** for data manipulation and summarization.
- **Macro Variables** for dynamic state selection.
- **ODS PDF** for report generation.

## Author
**Satkar Karki**  
[LinkedIn](https://www.linkedin.com/in/satkarkarki)  
[GitHub](https://github.com/satkar605)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
