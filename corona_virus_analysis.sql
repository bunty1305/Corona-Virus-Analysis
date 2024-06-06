SELECT * FROM corona_virus.corona_virus_dataset;

DESCRIBE corona_virus_dataset;

# Changing the value of Date column
UPDATE corona_virus_dataset
SET Date = str_to_date(Date, '%d-%m-%Y');

# Changing data type from text to date of Date column
ALTER TABLE corona_virus_dataset
MODIFY COLUMN Date DATE;

# Renaming columns
ALTER TABLE corona_virus_dataset
RENAME COLUMN Province TO province,
RENAME COLUMN `Country/Region` TO country_or_region,
RENAME COLUMN Latitude TO latitude,
RENAME COLUMN Longitude TO longitude,
RENAME COLUMN Date To date,
RENAME COLUMN Confirmed TO confirmed,
RENAME COLUMN Deaths TO deaths,
RENAME COLUMN Recovered TO recovered;

# Checking null values
SELECT
	SUM(CASE WHEN province IS NULL THEN 1 ELSE 0 END) AS province_null_counts,
    SUM(CASE WHEN country_or_region IS NULL THEN 1 ELSE 0 END) AS country_or_region_null_counts,
    SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) AS latitude_null_counts,
	SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) AS longitude_null_counts,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) date_null_counts,
    SUM(CASE WHEN confirmed IS NULL THEN 1 ELSE 0 END) AS confirmed_null_counts,
    SUM(CASE WHEN deaths IS NULL THEN 1 ELSE 0 END) AS deaths_null_counts,
    SUM(CASE WHEN recovered IS NULL THEN 1 ELSE 0 END) AS recovered_null_counts
FROM corona_virus_dataset;                           

# Check total number of rows
SELECT COUNT(*) AS num_rows
FROM corona_virus_dataset;                           -- 78986 rows

# Check what is start_date and end_date
SELECT
	MIN(date) AS start_date,
    MAX(date) AS end_date
FROM corona_virus_dataset;                            -- start_date: 2020-01-22 and end_date: 2021-06-13

# Number of month present in dataset
SELECT 
	COUNT(DISTINCT DATE_FORMAT(date, '%Y-%m')) AS num_months
FROM corona_virus_dataset;                                              -- Number of months present: 18

# Monthly average for confirmed, deaths, recovered
SELECT 
	DATE_FORMAT(date, '%m-%Y') AS months,
	ROUND(AVG(confirmed), 2) AS avg_confirmed, 
    ROUND(AVG(deaths), 2) AS avg_deaths, 
    ROUND(AVG(recovered), 2) AS avg_recovered
FROM corona_virus_dataset
GROUP BY months;

# Minimum values of confirmed, deaths, recovered per year
SELECT 
	DATE_FORMAT(date, '%Y') AS year,
    MIN(confirmed) AS min_confirmed,
    MIN(deaths) AS min_deaths,
    MIN(recovered) AS min_recovered
FROM corona_virus_dataset
GROUP BY year
ORDER BY year;

# Maximum values of confirmed, deaths, recovered per year
SELECT 
	extract(YEAR FROM date) AS year,
    MAX(confirmed) AS max_confirmed,
    MAX(deaths) AS max_deaths,
    MAX(recovered) AS max_recovered
FROM corona_virus_dataset
GROUP BY year
ORDER BY year;

# Total number of case of confirmed, deaths, recovered each month
SELECT 
	DATE_FORMAT(date, '%m-%Y') AS months,
	SUM(confirmed) AS total_confirmed,
    SUM(deaths) AS total_deaths,
    SUM(recovered) AS total_recovered
 FROM corona_virus_dataset
 GROUP BY months;
 
 # Country having highest number of the Confirmed case
 SELECT 
	country_or_region,
    SUM(confirmed) AS total_confirmed
FROM corona_virus_dataset
GROUP BY country_or_region
ORDER BY total_confirmed DESC
LIMIT 1;                                                           -- US (United States)

# Find Country having lowest number of the death case
SELECT 
	country_or_region,
    SUM(deaths) AS total_deaths
FROM corona_virus_dataset
GROUP BY country_or_region
ORDER BY total_deaths ASC
LIMIT 1;                                                             -- DOMINICA

# Find top 5 countries having highest recovered case
SELECT 
	country_or_region,
    SUM(recovered) AS total_recovered
FROM corona_virus_dataset
GROUP BY country_or_region
ORDER BY total_recovered DESC
LIMIT 5;                                                                  -- INDIA, BRAZIL, US, TURKEY, RUSSIA

# Check how corona virus spread out with respect to confirmed case (Eg.: total confirmed cases, their average, variance & STDEV)
SELECT 
	SUM(confirmed) AS total_confirmed,
    ROUND(AVG(confirmed), 0) AS avg_confirmed,
    ROUND(VARIANCE(confirmed), 0) AS var_confirmed,
    ROUND(STDDEV(confirmed), 0) AS stddev_confirmed
FROM corona_virus_dataset;

# Check how corona virus spread out with respect to deaths per month (Eg.: total confirmed cases, their average, variance & STDEV)
SELECT 
	DATE_FORMAT(date, '%m-%Y') AS months,
	SUM(deaths) AS total_deaths,
    ROUND(AVG(deaths), 0) AS avg_deaths,
    ROUND(VARIANCE(deaths), 0) AS var_deaths,
    ROUND(STDDEV(deaths), 0) AS stddev_deaths
FROM corona_virus_dataset
GROUP BY months;

# Check how corona virus spread out with respect to recovered cases (Eg.: total confirmed cases, their average, variance & STDEV)
SELECT 
	SUM(recovered) AS total_recovered,
    ROUND(AVG(recovered), 2) AS avg_recovered,
    ROUND(VARIANCE(recovered), 2) AS var_recovered,
    ROUND(STDDEV(recovered), 2) AS stddev_recovered
FROM corona_virus_dataset;