# Descriptive Statistics in SQL
This repository provides T-SQL scripts for computing central tendency and dispersion measures.

# Summary

Within this repository, I show how one can use T-SQL to compute the mode and variation ratio; the median and interquartile range; and, the mean and standard deviation of a single variable with multiple categories. For this exercise, I created a database, the LawEnforcementEmployees database, with two tables: Agency and EmployeePopulation. I populated these tables using a sample of data collected from online data located on the FBI's Crime Data Explorer web application. To keep things manageable, my dataset is limited to having only total officer counts between 2014 and 2023 from the Anchorage Police Department in Alaska and the St. Louis Metropolitan Police Department in Missouri.
Below, I include references to the Crime Data Explorer web application and literature on statistics, T-SQL functions, and T-SQL window functions.

# References

Data set:

Federal Bureau of Investigations/Crime Data Explorer. 2024. “Law Enforcement Employees Data.” https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/downloads.

References:

Ben-Gan, Itzik. 2020. T-SQL Window Functions: For data analysis and beyond. 2nd ed. Microsoft Press.

Microsoft. 2023. “Aggregate Functions.” Microsoft Online Reference. Microsoft: https://learn.microsoft.com/en-us/sql/t-sql/functions/aggregate-functions-transact-sql?view=sql-server-ver17

Vogt, W. Paul, and R. Burke Johnson. 2016. The SAGE Dictionary of Statistics & Methodology: A Nontechnical Guide for the Social Sciences. 5th ed. Los Angeles, CA: SAGE Publications.

Weisberg, Herbert. 1992. Central Tendency and Variability. Newbury Park, CA: SAGE Publications.
