/*=========================================================================== 
   Mid-Term Exam: TSA Claim Analysis  
   Course: BUS 507 - Business Analytics Modeling  
   Created By: Satkar Karki  
   Created On: 03/08/2025  

   Description:  
   This SAS program analyzes TSA claims data by performing data import, 
   cleaning, exploration, and reporting. It handles missing values, 
   removes duplicates, standardizes formats, and generates summary reports 
   to ensure data accuracy and usability. The program also includes a 
   flexible file path setup, allowing other users to modify it as needed 
   for efficiency.
=============================================================================*/

/* 
   Specify the directory where the 'TSAClaims2002_2017.csv' data file is stored. 
   Update the path below to match your file location before running the program.
*/

%let path=/home/u64132146/sasuser.v94/PG1;

/* Step 1 : Importing TSA Claims Dataset */
proc import 
		datafile="&path./data/TSAClaims2002_2017.csv" 
		out=WORK.c_raw dbms=csv replace;
	guessingrows=max;
	*Ensures SAS scans all rows before assigning column data types/length;
	getnames=yes;
	*Fetches the first row of the CSV file as variable names;
run;

/* Step 2 : Data Exploration */
ods noproctitle;
title "Dataset Structure and Initial Preview";

proc contents data=WORK.c_raw;
	*Previewing the content and structure of the dataset;
run;

title;
ods proctitle;

/* Checking for missing values */
ods noproctitle;
title "Missing Value Analysis for Categorical Columns";

/* Using PROC FREQ to count missing values */
proc freq data=WORK.c_raw;
	tables Claim_Type Claim_Site Disposition / missing;
	* Displays frequency counts including missing values;
	* These variables contain either a blank value (" ");
	* or a dash ("-") both of which will be cleaned further;
run;

title;
ods proctitle;

/* Step 3 : Removing Duplicate Rows */
/* Using NODUPKEY to eliminate exact duplicate records based on all columns.
The DUPOUT option stores removed duplicates in a separate dataset for validation. */
proc sort data=WORK.c_raw out=WORK.c_no_dups dupout=WORK.dups_removed nodupkey;
	by _all_;
	*Sorts by all columns and removes fully duplicated rows;
	*A total of 5 duplicate rows were isolated to the dups_removed table;
run;

/* Step 4 : Sorting the Data by Ascending Incident Date */
proc sort data=WORK.c_no_dups;
	by Incident_Date;
run;

/* Step 5 : Cleaning and Formatting Data */
data WORK.claims_cleaned;
	set WORK.c_no_dups;
 /* --- Handling Missing and Inconsistent Categorical Values --- */
    /* Replacing missing values and '-' with 'Unknown' */
 	if claim_type in ("", "-") then claim_type = "Unknown";
	if claim_site in ("", "-") then claim_site = "Unknown";
	if disposition in ("", "-") then disposition = "Unknown";

    /* Standardizing specific inconsistencies in Disposition */
    if disposition = "Closed:Canceled" then disposition = "Closed: Canceled"; /* Adding space */
    else if disposition = "Closed:Contractor Claim" then disposition = "Closed: Contractor Claim"; 
    else if disposition = "losed: Contractor Claim" then disposition = "Closed: Contractor Claim"; /* Fixing typo */
    else if disposition = "Closed:Contractor Clai" then disposition = "Closed: Contractor Claim"; /* Fixing missing letter */

    /* Extracting the first category from claim_type when multiple are listed */
    if Claim_Type IN ('Passenger Property Loss/Personal Injur', 'Passenger Property Loss/Personal Injury') then Claim_Type = 'Passenger Property Loss';
	else if Claim_Type = 'Property Damage/Personal Injury' then Claim_Type = 'Property Damage';
	
    /* --- Standardizing State & StateName Formatting --- */
	statename = propcase(statename); /* Converts state names to lowercase with proper capitalization */
	state = lowcase(state); /* Converts state abbreviations to lowercase */

    /* --- Creating date_issues Column to Flag Potential Errors --- */
   /* Initialize column and prevent possible truncation*/
    length date_issues $15;  
    date_issues = ""; 

    /* Rule 1: If either date is missing, the record is incomplete */
    if missing(incident_date) or missing(date_received) then date_issues = "Needs Review";

    /* Rule 2: Ensuring reported claims fall within TSA operational years (2002-2017) */
    else if year(incident_date) < 2002 or year(incident_date) > 2017 then date_issues = "Needs Review";
    else if year(date_received) < 2002 or year(date_received) > 2017 then date_issues = "Needs Review";

    /* Rule 3: Ensuring logical date sequence (incident_date must occur before date_received) */
    else if incident_date > date_received then date_issues = "Needs Review";

    /* --- Formatting Currency & Dates for Readability --- */
    format close_amount dollar12.2; /* Formatting claim closure amounts with $ and 2 decimal places */
    format incident_date date_received date9.; /* Formatting dates as DDMMMYYYY */

    /* --- Removing Unnecessary Columns (county & city) --- */
    drop county city; 

    /* --- Assigning Permanent Labels for Better Reporting --- */
    label 
        claim_number = "Claim Number"
        date_received = "Date Received"
        incident_date = "Incident Date"
        airport_code = "Airport Code"
        airport_name = "Airport Name"
        claim_type = "Claim Type"
        claim_site = "Claim Site"
        item_category = "Item Category"
        close_amount = "Close Amount"
        disposition = "Disposition"
        statename = "State Name"
        state = "State"
        date_issues = "Date Issues";

run;

* --- Verifying Data Processing Results --- */

/* Checking unique values after processing */
ods noproctitle;
title "Final Verification: Unique Categorical Values";

proc freq data=work.claims_cleaned order=freq;
	tables disposition claim_type claim_site date_issues / missing;
    * Ensures all values conform to predefined categories and "Needs Review" is correctly assigned;
run;

title;
ods proctitle;

/* Previewing the Cleaned Data */
ods noproctitle;
title "Preview of Cleaned TSA Claims Data";

proc print data=work.claims_cleaned (obs=10) label;
    var claim_number date_received incident_date close_amount date_issues;
    * Ensures labels and formatted values appear correctly;
run;

title;
ods proctitle;

/* Step 5: Finalizing & Exporting Report as a PDF */
ods pdf file = "&path./output/ClaimReports.pdf" 
        startpage=no style = sapphire pdftoc = 1;  
ods noproctitle;
options nodate;

/* Define a footnote for authorship */
ods escapechar='^'; /* Allows inline text styling */
footnote j=l "^S={fontsize=8pt} Report prepared by Satkar Karki"; /* Left-aligned, smaller font */

/* --- Reporting on Overall Data Issues --- */
ods proclabel 'Validation Report: Date Issues in TSA Claims';
title 'Validation Report: Claims with Date Issues';
proc freq data=WORK.claims_cleaned;
    table date_issues / missing nocum nopercent;
run;

/* --- Reporting on Claims per Year with a Plot --- */
ods proclabel 'Annual Trend: TSA Claims (2002-2017)';
title 'Annual Trend: TSA Claims (2002-2017)';
ods pdf startpage=now; /* Force a new page for better readability and organization of report */
proc freq data=WORK.claims_cleaned;
    table incident_date / nocum nopercent plots=freqplot;  
    format incident_date year4.; /* Aggregates by Year */
    where date_issues = ''; /* Exclude flagged records */
run;

/* --- Dynamic State-Level Filtering & Analysis --- */
/*  Specify the state you want to analyze by updating the value of `StateFilter`.  
   Replace "Texas" with the desired state name before running the program.  */
%let StateFilter = Texas; 

/* Overview of Claim Trends in the Selected State */
ods proclabel "&StateFilter: Claim Types, Locations, and Outcomes";
title "Breakdown of TSA Claims in &StateFilter (Type, Site & Outcome)";
ods pdf startpage=now; /* Force a new page */
proc freq data=WORK.claims_cleaned;
    table claim_type claim_site disposition / nocum nopercent;
    where date_issues = '' and statename = "&StateFilter";
run;

/* Summary Statistics for Close Amounts in Selected State */
ods proclabel "Financial Overview: TSA Claims in &StateFilter";
title "Financial Summary of TSA Claims in &StateFilter";
proc means data=WORK.claims_cleaned mean min max sum maxdec=0;
    var close_amount;
    where date_issues = '' and statename = "&StateFilter";
run;

/* Close the PDF output */
ods pdf close;



