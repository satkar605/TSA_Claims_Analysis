# TSA Claims Analysis (2002–2017)

## Project Overview
This project analyzes airport claims submitted to the Transportation Security Administration (TSA) from 2002 to 2017. Using **SAS Studio**, the analysis focuses on cleaning and standardizing the data, identifying claims with potential inconsistencies, and generating a dynamic report that reveals claim trends and financial patterns across time and U.S. states. The final output is a user-driven PDF report, enabling customized insights based on selected state inputs.

## Business Challenge
The TSA maintains a record of claims related to property damage, theft, injury, and other issues reported by air travelers. However, the raw data contains inconsistencies in date formats, missing values, and irregular text formatting. Without cleaning and structured reporting, TSA leadership and public oversight bodies cannot draw clear insights about trends, high-risk locations, or average payout metrics. A reliable analysis is needed to support transparency, operational reviews, and data-driven communication.

## Data Summary
- **Source**: TSAClaims2002_2017.csv (provided for academic use)
- **Timeframe**: January 2002 – December 2017
- **Grain**: Individual claim submissions
- **Key Fields**: `Claim_Type`, `Claim_Site`, `Disposition`, `Close_Amount`, `Incident_Date`, `State`
- **Limitations**: Inconsistencies in item descriptions and missing values in key fields; Item Category not standardized due to heterogeneous entries across years.

## Key Business Questions
- How many TSA claims were filed each year from 2002 to 2017?
- What proportion of claims contain date-related issues?
- What are the most common types, sites, and outcomes of claims filed in each U.S. state?
- What is the financial exposure (min, max, average, and total claim settlement) at the state level?

## Analytical Approach
The analysis followed a two-step process:
1. **Data Cleaning & Preparation**
   - Removed fully duplicated records
   - Standardized formatting of `State`, `StateName`, and date fields
   - Replaced missing or invalid values in key categorical fields with `"Unknown"`
   - Created a `Date_Issues` flag to identify missing, reversed, or out-of-range dates
   - Dropped irrelevant columns (`County`, `City`)
   - Applied permanent formatting to monetary and date fields
   - Sorted final dataset by `Incident_Date` for reporting clarity

2. **Dynamic Report Generation**
   - Filtered out all claims with date issues before reporting
   - Created summary reports and visualizations using `PROC FREQ`, `PROC REPORT`, and macro-driven logic
   - Enabled user-specified state selection for localized insights

## Findings and Interpretations

### 1. Date Quality Check
- **4,241 claims** flagged with date issues (e.g., missing fields or logical errors)
- These were excluded from the final analysis to ensure validity

### 2. Claim Volume Trends (2002–2017)
- Highest number of claims: **2004** with **28,484**
- Lowest number of claims: **2017** with **8,340**
- Trend indicates a steady decline in claim volume after 2004  
  *→ Suggests possible improvements in TSA processes or policy shifts*

### 3. State-Level Insights (Example: Texas)
For the state of Texas, the report produced the following breakdown:
- **Top Claim Types**:
  - Passenger Property Loss: 8,093
  - Property Damage: 5,583
- **Top Claim Sites**:
  - Checked Baggage: 11,139
  - Checkpoint: 2,945
- **Dispositions**:
  - Denied: 6,369
  - Approved in Full: 3,279
- **Financial Summary**:
  - Mean: $101
  - Max: $106,000
  - Total Close Amount: $1,225,577

## Business Recommendations
- **Flag and review airports with consistently high claim counts post-2004**
- **Investigate common claim types at major checkpoints to improve loss prevention**
- **Review TSA process improvements made post-2004 that may correlate with the declining trend**
- **Consider deeper audit into high-payout claims (>$10,000) to identify fraud risks or systemic issues**

## Assumptions and Limitations
- **Date Approximations**: Incident and received dates were not cross-verified beyond logical checks. Travel duration or claim delay was not calculated.
- **Dynamic Reporting**: State-level analysis requires user input via macro variables, not an interactive dashboard.
- **Formatting Constraints**: Some data fields were inconsistently formatted across years (e.g., `Item_Category`), limiting their utility.
- **Currency Representation**: Close_Amount analysis assumes all values are in USD without accounting for inflation.

## Repository Structure
```
TSA_Claims_Analysis/
│
├── TSA_Claims_Analysis.sas        # Main SAS script (data cleaning + report)
├── TSAClaims2002_2017.csv         # Raw input dataset (excluded from repo due to size)
├── ClaimReports.pdf               # Final output report
├── README.md                      # Project documentation
```

## How to Reproduce the Analysis
1. Open **SAS Studio**
2. Import the dataset `TSAClaims2002_2017.csv` into the WORK library
3. Run the script `TSA_Claims_Analysis.sas`
4. Review the generated `ClaimReports.pdf` for visual summaries and statistics

## Tools and Techniques
- **Platform**: SAS Studio
- **Procedures**: `PROC IMPORT`, `PROC FREQ`, `PROC FORMAT`, `PROC REPORT`, `PROC SORT`
- **Features Used**: Macro variables, permanent formatting, user-driven filters, ODS PDF output

## Author
**Satkar Karki**  
🔗 [LinkedIn](https://www.linkedin.com/in/satkarkarki)  
🔗 [GitHub](https://github.com/satkar605)

