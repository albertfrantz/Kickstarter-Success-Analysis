# Kickstarter-Success-Analysis
This study quantifies the factors that may lead to a successful Kickstarter campaign. Using Kickstarter data and logit and linear probability models this analysis provides information on the factors that can increase the chance of a successful Kickstarter campaign. The factors included in this analysis include the type of campaign, posting date and time, funding goal, incentives, and other pieces making up Kickstarter campaigns. This research can provide concrete advice for those seeking to successfully fund a Kickstarter campaign.

# Data Sources
Data was webscraped from Kickstarter and provided by General Assmebly during the application process. The full data set can be found here. 

# Data Cleaning
Data was cleaned using MySQL. 
what was changed from the original file:
1. Removed all live kickstarter campaigns as one is unable to analyze their sucess.
2. Combined Film &amp; Video with Film & Video.
3. Deleted all observations with campaign goals below $100 and above $1,000,000. Removing these observations mean conclusions can only apply to those within the goal range of $100-$1,000,000.
4. Created a binary variable for success based on status. Where:
1 = succesfully funded Kickstarter campaign
0 = failed, suspended, or postponed campaign.
5. Deterimed the start date of the campaign given the funded date and duration.
6. Determined the start day name (ie: Monday)
7. Determined the start month name (ie: June)
8. Determined the start posting time (ie: afternoon)
9. Dropped all columns not needed for this analysis.

The final orginization of the data can be found below in Table 1.

Table 1. Data Orginization

project_id | category | goal ($) | levels | duration (days) | start_date | campaign_status | start_day_name | start_posting_time | start_month_name  
----- | ------ | ---------- | ---------- | ---------- | --------- | ---------------- | ------------- | -------------- | ---
3409 | Film & Video | 10500 | 7 | 30.00 | 7/20/2011 19:28 | 1 | Wednesday | Before Midnight | July
126581 | Games | 4000 | 5 | 47.18 | 6/15/2010 23:40 | 0 | Tuesday | Before Midnight | June
237090 | Film & Video | 6000 | 13 | 32.22 | 3/6/2012 20:57 | 1 | Tuesday | Before Midnight | March

Variable descriptions:
* project_id - identifier for the Kickstarter campaign. 
* category - the type of campaign (ie: dance, publishing, ect).
* goal - the funding goal in USD of the campaign.
* levels - the number of funding donor reward levels for the campaign.
* duration - the number of days the campaign was live.
* start_date - the datetime the campaign was posted.
* campaign_status - a binary variable for determining if the campaign was sucessfull:
  * 1 = succesful 
  * 0 = failure.
* start_day_name - the day of the week the campaign was started.
* start_posting_time - the time of day the campaign was posted: 
  * between 6 AM and 12 PM = Before Noon                         
  * between 12 PM and 6 PM = Afternoon                           
  * between 6 PM and 12AM = Before Midnight                       * between 12AM and 6 AM = After Midnight
* start_month_name - the month the campaign was posted.

# Data Exploration
I first checked the normality of the continous variables used. The standard density plots of each numerical variable used in this analysis can be found in Figure 1.

From these density plots we can see that the continous varaibles are not normally distruted. Both goal and levels are right skewed and it may be worth transforming those variables. The log transformed goal and levels density plots can be found in figure 2. Duration was found to be mulitmodal, which makes sense since the kickstarter duration break up seems to be mostly 30, 45 and 60 day campaigns. 

# Models

I fit three different models to analyze the success of Kickstarter campaigns. I first fit a linear probabilty model to determine the liklihood of success on the binary variable campaign_status. I then fit a linear probabilty model with log transformed goal as this variable due to its non-normality. Finally, because linear probabilty models can, in theory, produce values below 0 and above 1 I also included a logit model. The logit model would not allow for values below 0 or above 1. The models can be found below:

* Model 1: LPM
  * campaign_status ~ goal + levels + duration + category + start_day_name + start_posting_time + start_month_name
* Model 2: LPM with log transformed goal
  * campaign_status ~ log(goal) + levels + duration + category + start_day_name + start_posting_time + start_month_name
* Model 3: Logit
  * campaign_status ~ goal + levels + duration + category + start_day_name + start_posting_time + start_month_name

Before continuing I also check each models VIF to determine if there was a concering amount of multicollinerity present. There was not. These results can be found in table 2.

Table 2. Maximum VIF

Model | Maximum VIF 
----- | ------
Model 1 | 1.049 
Model 2 | 1.23
Model 3 | 1.19

# Results

Regression results of all three models can be found below in table 3. More clear findings can be found in the conclusion section. 


# things to do: import photos, results, predictions, conclusion
# Predictions

# Conclusion












