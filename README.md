# GettingAndCleaningData
This is the final project for the Coursera "Getting and Cleaning Data" course, part of the Data Science Specialization.

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

My notes:

I start by checking if required packages are installed and install them if not. You'll see that I am removing unneeded variables and I progress through the code, just to keep a clean environment. Then I define variables for all of the necessary files and directories. Then I check to see if the zip file has already been download and avoid downloading it again to save on processesing time, if it is already downloaded I also skip unzipping it an additional time.

Once the file has been unzipped, I starting reading the data files into their own variables. I start with the feature file, which contains all of the column names for the measures. Then I read the three training data files and combined them into one data table, and I repeat the process for the three test data files. I bind the training and test data together into a single table, and then I assign the features as column names.

The next step is to get only the column names that include "mean" or "std", and I use the resulting column names to subset the data to only include items that are a mean or a standard deviation. Then I added the more descriptive activity names by reading the activity file and merging it into my data subset. Next I clean up the column names that came from the feature file to be more descriptive.

Lastly, I aggregate the data by the subject and the activity to get the mean of all the mean and std columns, write the cleaned aggregate data to a file, and create the codebook.

