/******************************
** File: kickstarterDataCleaning  
** Desc: This file cleans the kickstarter data to make it useable
**		 for regression analysis
** Auth: Albert Frantz
** Date: July 4, 2020
*******************************/

/*creating database for kickstarter data */
CREATE DATABASE	kickstarter;
USE kickstarter;

/*Creating kickstarter records table */
CREATE TABLE kickstarterRecords(
	project_id INT,
    category VARCHAR(100),
    stat VARCHAR(50),
    goal INT,
    pledged INT,
    backers INT,
    funded_date VARCHAR(100),
    funded_datetime DATETIME,
    levels INT,
    updates INT,
    comments INT,
    duration DOUBLE(4,2)
);

/*I used MySQL Workbench to import the Kickstarter CSV file

/*Checking data was imported correctly*/
SELECT * FROM kickstarterRecords;

/*Deleting all currently live Kickstarter Postings */
DELETE FROM kickstarterRecords WHERE stat = "live";

/*Data cleaning catagories film &amp video is film and video */
UPDATE kickstarterRecords
SET category = REPLACE(category, 'Film &amp; Video', 'Film & Video')
WHERE category LIKE 'Film &amp; Video';

/*Having data only for kickstarter campaigns between $100 and $1,000,000 */
DELETE FROM kickstarterRecords WHERE goal>1000000 OR goal<100;

/*Adding columns for variables that will be added */
ALTER TABLE kickstarterRecords
ADD start_date DATETIME, 
ADD campaign_status INT,
ADD duration_minutes INT,
ADD start_day_name VARCHAR(30),
ADD start_posting_time VARCHAR(30),
ADD start_month_name VARCHAR(30);

/*Getting binary status for success
	1 = succesfully funded Kickstarter campaign
    0 = failed, suspended, or postponed campaign*/
UPDATE kickstarterRecords SET campaign_status = 
CASE
	WHEN stat = "successful" THEN 1
    ELSE 0 
END
;

/*Need to convert to minutes to get to properly find start datetime */
UPDATE kickstarterRecords SET duration_minutes =
duration*1440 /*1440 minutes in a day*/
;

/*Getting start datetime based on end date and duration of campaign*/
UPDATE kickstarterRecords SET start_date =
DATE_SUB(funded_datetime, INTERVAL duration_minutes MINUTE)
;

/*Getting start date day name */
UPDATE kickstarterRecords SET start_day_name =
DAYNAME(start_date)
;

/*Getting start date day month */
UPDATE kickstarterRecords SET start_month_name =
MONTHNAME(start_date)
;

/* Getting daytimes 
	between 6 AM and 12 PM = Before Noon
	between 12 PM and 6 PM = Afternoon 
	between 6 PM and 12AM = Before Midnight
	between 12AM and 6 AM = After Midnight*/
UPDATE kickstarterRecords SET start_posting_time =
CASE
	WHEN HOUR(start_date) BETWEEN 6 and 12 THEN "Before Noon"
    WHEN HOUR(start_date) BETWEEN 12 AND 18 THEN "Afternoon"
    WHEN HOUR(start_date) BETWEEN 18 AND 24 THEN "Before Midnight"
    ELSE "After Midnight"
END
;

/*Dropping un-needed columns */
ALTER TABLE kickstarterRecords 
	DROP COLUMN stat, 
    DROP COLUMN funded_date, 
    DROP COLUMN funded_datetime,
    DROP COLUMN duration_minutes,
    DROP COLUMN pledged,
    DROP COLUMN backers,
    DROP COLUMN updates,
    DROP COLUMN comments
    ; 
    
/*Export kickstarterRecords through mySQL Workbench as CVS */
