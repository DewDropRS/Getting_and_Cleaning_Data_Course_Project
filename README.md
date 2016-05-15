# Getting_and_Cleaning_Data_Course_Project
Course Project for Getting and Cleaning Data-3rd course in the Data Science Specialization

## Description
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Note about some decisons I made...
I decided to use the variable names in the features file and just cleaned them up to make more human readable and created unique names for those that were duplicated. I also decided to row bind my data instead of column bind. I did not want to have a very wide data frame. I added a column called source so that I know which dataset the subject originated from.

## Project Script
### run_analysis.R
> Steps

1. load libraries
2. set working directory
3. read in all relevant data files
4. examine the data: run function str() to view table information
5. generate valid column names from the features table
  + human readable, remove dashes and parenthesis
  + ensure all variable names are unique
  + apply new names to data frames, x_train and x_test
6. add new columns, source, subjectid, and activity
7. merge x_train.txt and x_test.txt using rbind()
8. use select to find all columns that contain "mean", "std" in the variable name and save to new data frame
9. summarize-get the mean of all measures group by subjectid and activity

## Please see CodeBook.Rmd for code, results, and notes. Code was embedded using code chunks.




