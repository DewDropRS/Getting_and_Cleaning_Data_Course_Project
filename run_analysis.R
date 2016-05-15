##******************************************************************************
## 		Script name:	run_analysis.R
## 		Course:				Getting and Cleaning Data
##		Assignment: 	Course Project
## 		Author: 			Rocio Ana-Sofia Segura
##		R-version: 		3.1.2
## 		Packages: 		data.table, dplyr
## 		Description:	
## 		The purpose of this project is to demonstrate your ability to collect, 
##		work with, and clean a data set. The goal is to prepare tidy data that 
##		can be used for later analysis. You will be graded by your peers on a 
##		series of yes/no questions related to the project. You will be required 
##		to submit: 1) a tidy data set as described below, 2) a link to a Github 
##		repository with your script for performing the analysis, and 3) a code 
##		book that describes the variables, the data, and any transformations or 
##		work that you performed to clean up the data called CodeBook.md. You 
##		should also include a README.md in the repo with your scripts. This repo 
##		explains how all of the scripts work and how they are connected.
##******************************************************************************
## 		One of the most exciting areas in all of data science right now is wearable 
##		computing - see for example this article . Companies like Fitbit, Nike, and 
##		Jawbone Up are racing to develop the most advanced algorithms to attract new 
##		users. The data linked to from the course website represent data collected 
##		from the accelerometers from the Samsung Galaxy S smartphone. A full 
##		description is available at the site where the data was obtained:

## 		http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
##******************************************************************************
## 		Here are the data for the project:
## 		https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##******************************************************************************
## Review Criteria

## 1.The submitted data set is tidy. 
## 2.The Github repo contains the required scripts.
## 3.GitHub contains a code book that modifies and updates the available codebooks 
## 	with the data to indicate all the variables and summaries calculated, along 
## 	with units, and any other relevant information.
## 4.The README that explains the analysis files is clear and understandable.
## 5.The work submitted for this project is the work of the student who submitted it.
##******************************************************************************
## You should create one R script called run_analysis.R that does the following. 
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.From the data set in step 4, creates a second, independent tidy data set with 
##	the average of each variable for each activity and each subject.
##******************************************************************************
## Notes on tidy data:
## One variable per column
## Each observation on its own row
## One table for every kind of variable (make sure you have an id column if you need to link tables)
## Be descriptive when choosing variable names
## Codebook (information about variables (ex. units?, summary choices). Put in Markdown file.
## Study Design (how you collected the data). Put in Markdown file.
## Instruction list-can be this R script
##******************************************************************************
## Steps
## 1. load libraries
## 2. set working directory
## 3. read in all relevant data files
## 4. examine the data: run function str() to view table information
## 5. generate valid column names from the features table
##      human readable, remove dashes and parenthesis
##      ensure all variable names are unique
##      apply new names to data frames, x_train and x_test
## 6. add new columns, source, subjectid, and activity
## 7. merge x_train.txt and x_test.txt using rbind()
## 8. use select to find all columns that contain "mean", "std" in the variable name and save to new data frame
## 9. summarize-get the mean of all measures group by subjectid and activity
## 10. output summary dataset to txt file
##******************************************************************************


## 1. load libraries

library(data.table)
library(dplyr)

## 2. set the working directory

setwd("~/coursera/GettingAndCleaningData/data")
getwd()

## 3. Import relevant raw data (not in its most raw form but calling it raw data here since this 
## is the most raw form available to me).

xtrain		      <- read.table("/Users/rociosegura/coursera/GettingAndCleaningData/data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
xtest			      <- read.table("/Users/rociosegura/coursera/GettingAndCleaningData/data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
features 	      <- read.table("/Users/rociosegura/coursera/GettingAndCleaningData/data/UCI HAR Dataset/features.txt", header = FALSE)
subject_test 	  <- read.table("/Users/rociosegura/coursera/GettingAndCleaningData/data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subject_train 	<- read.table("/Users/rociosegura/coursera/GettingAndCleaningData/data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
ytrain 	        <- read.table("/Users/rociosegura/coursera/GettingAndCleaningData/data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
ytest 	        <- read.table("/Users/rociosegura/coursera/GettingAndCleaningData/data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
actlabels       <- read.table("/Users/rociosegura/coursera/GettingAndCleaningData/data/UCI HAR Dataset/activity_labels.txt", header = FALSE)

## join activity labels to ytrain and ytest
ytrain <- merge(ytrain, actlabels, by = "V1")
ytrain <- setnames(ytrain, old='V2', new = 'activity')

ytest <- merge(ytest, actlabels, by = "V1")
ytest <- setnames(ytest, old='V2', new = 'activity')

## 4. Examine the data    
dflist <- list(xtrain, xtest, features, subject_test, subject_train, ytrain,ytest, actlabels)
dfnames <- list("xtrain","xtest","features","subject_test", "subject_train","ytrain","ytest","actlabels")

mystrfxn <- function(x,y) {
  
  for(i in 1:length(x)) {
    print(paste('Data Frame Name: ' , y[i]))
    str(x[i])
  }
  return
}

mystrfxn(x = dflist, y = dfnames)

## 5. Generate valid column names     
## Get column names from features data frame and save to new vector named features2
## Process names so that variables are human readable

features2 <- mutate(features, tmpvarname = gsub("\\(\\)","", V2), newvarnames = gsub("-","_", tmpvarname))

## select the varialbe (newvarnames) that corresponds to the processed varialbe names
varnames <- as.vector(t(select(features2, newvarnames)))

## There are values (vector of column names) in varnames that are duplicated
## Use make.names with unique equal to TRUE so that all column names get a unique value.
## Save to a new vector named validvarnames
validvarnames <-  make.names(varnames, unique = TRUE)

## use validvarnames vector as the source for the new names
oldtrainnames <- names(xtrain)
xtrain <- setnames(xtrain, old = oldtrainnames, new = validvarnames)

oldtestnames <- names(xtest)
xtest <- setnames(xtest, old = oldtestnames, new = validvarnames)

## 6. add new columns, source, subjectid, and activity

## Add a new column to identify whether test or train data
xtrain  <- mutate(xtrain, source="train")
xtest   <- mutate(xtest, source="test")

## Add a subject id and activity column from subject_test/train and ytest/xtest
xtrain <- cbind(subjectid=subject_train$V1, activity = ytrain$activity, xtrain)
xtest <- cbind(subjectid=subject_test$V1, activity = ytest$activity, xtest)

## 7. merge x_train.txt and x_test.txt using rbind()
train_test_appended <- rbind(xtrain, xtest) 

## Arrange subjectid and source so they appear as the first columns
train_test_appended <- train_test_appended %>%
  select(source, everything())
train_test_appended <- train_test_appended %>%
  select(subjectid, everything())

## 8. use select to find all column names that contain "mean", "std" or "source"
acc_mean_std_analset <- train_test_appended %>%
  select(matches('mean_|std_|source|subjectid|activity')) 
str(acc_mean_std_analset)

## 9. summarize-get the mean of all measures group by subjectid, source and  activity

acc_mean_std_avg <- acc_mean_std_analset %>% group_by(subjectid, source, activity) %>% summarise_each(funs(mean))
str(acc_mean_std_avg)
head(acc_mean_std_avg, 5)

## 10. output summary dataset to txt file
## use write.table() using row.name=FALSE

write.table(acc_mean_std_avg, file = 'acc_mean_std_avg.txt', row.names = FALSE, sep = "\t")