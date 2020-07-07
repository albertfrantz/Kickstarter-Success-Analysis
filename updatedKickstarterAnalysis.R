############################################################################################
# Author: Albert Frantz                                                                    #
# Date: July 6, 2020                                                                       #
#                                                                                          #
# Questions: Can the success of a Kickstarter campaign be predicted using: the             #
#            funding goal, the number of donor levels, the duration of the campaign,       # 
#            the product category, and the starting date and time?                         #
#                                                                                          #
# Purpose: The purpose of this analysis is to provide information to those who wish        #
#          to start a new Kickstarter campaign. This analysis will determine what factors  #
#          can increase the likelihood of success for a Kickstarter campaign.              #
#                                                                                          #
# Method: I will be using a linear probability model and logit model to assess how 7       # 
#         explanatory variables effect the rate of success of Kickstarter projects.        #
#                                                                                          #
# Data: Data was obtained from Kickstarter. Edited data can be found at:                   #
#       https://drive.google.com/file/d/1e64ftvCgvLxXXajkxPzbwG3LjJpqM5QI/view?usp=sharing #
############################################################################################


###################################################
# Importing libraries to be used in this analysis #
###################################################

install.packages("lattice", "aod", "ggplot2", "stargazer", "car") 

library(lattice)
library(aod)
library(ggplot2)
library(stargazer)
library(car)

###############################
# Importing and checking data #
###############################

kickstarterReducedData = read.csv(file.choose())
head(kickstarterReducedData) #checking data was imported correctly

#removing scientific notation from future results
options(scipen = 999) 

#####################################################################################
# Explanation of variables used:                                                    #                  
#                                                                                   #                  
# campaign_status - the response variable to be used. This is a binary variable     #
# 0 means the campaign failed and 1 means the campaign was successfully funded.     #                  
#                               												                          	#
# Continuous Variables:                                                             #                  
# goal - the funding goal of the campaign in USD.                                   #                  
#                                                                                   #                  
# levels - the number of different donor levels for the campaign.                   #				  
#                                                                                   #                 
# duration- the duration of the campaign in days.                                   # 				  	
#                                                    							                	#				  
# Categorical Variables:                                                 			      #				  
# category - the type of Kickstarter campaign (ie: photography, theater, tech ect.) #
#                                                                                   #                  
# start_day_name - the day of the week the Kickstarter campaign was started.        #
#                                                                                   #                  
# start_month_name - month the Kickstarter campaign was started.                    #
#                                                                                   #                  
# start_posting_time - time of day campaign was started.                            #
#                      between 6 AM and 12 PM = Before Noon                         #
#                      between 12 PM and 6 PM = Afternoon                           #
#                      between 6 PM and 12AM = Before Midnight                      #
#                      between 12AM and 6 AM = After Midnight                       #
# 																					                                        #				  				  																					
#####################################################################################


###########################################################
# Checking normality of variables being used for analysis #
###########################################################

#funding goal is not normal (right skew)
lattice::densityplot(~goal
                     , data = kickstarterReducedData
                     , xlab="Funding Goal ($)",
                     main="Funding Goal Density Plot")
lattice::densityplot(~log(goal)
                     , data = kickstarterReducedData
                     , xlab="Funding log(Goal) ($)"
                     , main="Funding log(Goal) Density Plot") #log transform

#the number of donor levels is not normal (right skew)
lattice::densityplot(~levels
                     , data = kickstarterReducedData
                     , xlab="Donor Levels"
                     , main="Donor Levels Density Plot")
lattice::densityplot(~log(levels)
                     , data = kickstarterReducedData
                     , xlab="log(Donor Levels)"
                     , main="log(Donor Levels) Density Plot") #log transform

#the duration of the campaign is multimodal and should be considered
lattice::densityplot(~duration
                     , data = kickstarterReducedData
                     , xlab= "Duration (days)"
                     , main="Duration of Campaign (days)")

#Checking distirubution of catagorical variables using bar chart of count
ggplot(kickstarterReducedData) + geom_bar(aes(x = category))
ggplot(kickstarterReducedData) + geom_bar(aes(x = start_day_name))
ggplot(kickstarterReducedData) + geom_bar(aes(x = start_month_name))
ggplot(kickstarterReducedData) + geom_bar(aes(x = start_posting_time))

#data conforms to all other logit and linear Probability assumptions so analysis can continue

###################################################
# Running the Logit and Linear Probability Models #
###################################################

#I will be predicting the campaign_status (success) of a Kickstarter campaign given 7 explanatory variables.
#The output will be between 0-1. The closer the value is to 1 the higher the probability of success. 

#running a linear probability model with no log transformations.
kickstarterLPM = lm (campaign_status ~ goal 
                     + levels
                     + duration
                     + category
                     + start_day_name
                     + start_month_name
                     + start_posting_time
                     , data = kickstarterReducedData)
summary(kickstarterLPM)
car::vif(kickstarterLPM) #No concern for multicollinearity

#running a linear probability model with log transformed goal. levels was not log transformed
kickstarterLPMLog = lm (campaign_status ~ log(goal) 
                        + levels 
                        + duration 
                        + category 
                        + start_day_name 
                        + start_month_name 
                        + start_posting_time
                        , data = kickstarterReducedData)
summary(kickstarterLPMLog)
car::vif(kickstarterLPMLog) #No concern for multicollinearity

#
#Logit justification:
#Logit model was also used as it will provide a more accurate prediction of campaign_status
#The issue with the logit model is it is more difficult to interpret. 
#

#Logit model with no log transformations.
kickstarterLogit = glm(campaign_status ~ goal 
                       + levels 
                       + duration 
                       + category 
                       + start_day_name 
                       + start_month_name 
                       + start_posting_time
                       , data = kickstarterReducedData
                       , family = "binomial")
summary(kickstarterLogit)
car::vif(kickstarterLogit) #No concern for multicollinearity

##################################
# Stargazer results output table #
##################################

#results output using all 3 models 
stargazer(kickstarterLogit, kickstarterLPM, kickstarterLPMLog, type = "html", 
          title            = "Kickstarter Regression Results",
          covariate.labels = c("Kickstarter Funding Goal (in dollars)", "Log Kickstarter Funding Goal (in dollars)", 
                               "Donor levels", "Duration of kickstarter (days)",
                               "Category: Comics", "Category: Dance", "Category: Design", 
                               "Category: Fashion", "Category: Film and Video", 
                               "Category: Food", "Category: Games", "Category: Music",
                               "Category: Photography", "Category: Publishing", "Category: Technology",
                               "Category: Theater", 
                               "Monday", "Saturday", "Sunday", "Thursday", "Tuesday", "Wednesday", 
                               "August", "December", "February", "January", "July", "June", 
                               "March", "May", "November", "October", "September", 
                               "Afternoon", "Before Midnight", "Before Noon"),
          dep.var.caption  = "Probabiltiy of a Kickstarter Project Being Funded",
          dep.var.labels   = "Logitistic, LPM, LogLPM", digits = 7, out="kickstaterTable.html")

################################################################################################
# Predicting the success of a specific Kickstarter campaign                                    #
#                                                                                              #
# creating a prediction for each model:                                                        #
# with a funding goal of $2000, 8 donor levels, a duration of 45 days, in the category of art, # 
# posted on a Friday, posted in June at 8AM                                                    #
################################################################################################

#predicition with logit model
predict(kickstarterLogit, newdata = data.frame(goal = 2000
                                               , levels = 8
                                               , duration = 45
                                               , category = "Art"
                                               , start_day_name = "Friday"
                                               , start_month_name = "June"
                                               , start_posting_time = "Afternoon")
                                               , type = "response")
#predicted likelihood of success: 62.1%

#preidiction with LPM and no log transforms
predict(kickstarterLPM, newdata = data.frame(goal = 2000
                                             , levels = 8
                                             , duration = 45
                                             , category = "Art"
                                             , start_day_name = "Friday"
                                             , start_month_name = "June"
                                             , start_posting_time = "Afternoon")
                                             , type = "response")
#predicited likelihood of success: 57.6%

#predicition with LPM and log transformed goal
predict(kickstarterLPMLog, newdata = data.frame(goal = 2000
                                                , levels = 8
                                                , duration = 45
                                                , category = "Art"
                                                , start_day_name = "Friday"
                                                , start_month_name = "June"
                                                , start_posting_time = "Afternoon")
                                                , type = "response")
#predicited likelihood of success: 61.8%

#comparing to mean likelihood of success
mean(kickstarterReducedData$campaign_status,na.rm=TRUE)
#mean Kickstarter campaign likelihood of success: 54.7%



############################################################################################
# Conclusion and Considerations                                                            #
#                                                                                          #
# Conclusion:                                                                              #
# A Kickstarter with the highest probability of being									                     # 
# successfully funded would have these qualities: 										                     #
# 1. A low funding goal (the lower the higher the likelihood of success)                   #
# 2. More donor levels                                                                     #
# 3. A short duration                                                                      #
# 4. In the dance category                                                                 #
# 5. Posted on a Tuesday                                                                   #
# 6. In Febuary                                                                            #
# 7. In the afternoon (12pm - 6pm)                                                         #
#                                                                                          #
# Consideration:                                                                           #
# R2 is low for all models as many other factors go into determining					             # 
# if a project will be successful.  													                             #	
# A lot of these reason may be difficult to quantify. Being able to determine overall      #
# project quality may be a big determinant of Kickstarter success.                         #
# A binary variable determining if the project creator had previously funded a project     #
# might help determine the quality of the project.                                         #
# If the creator has already successfully funded a project that may be 					           #	
# representative of if she has quality projects and therefore control for project quality. #
############################################################################################

