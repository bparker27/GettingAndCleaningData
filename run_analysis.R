#check if required packages are installed and install them if not
packages <- c("data.table", "dataMaid", "rmarkdown")
newPackages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new.packages) > 0){
  install.packages(newPackages)
}
sapply(packages, require, character.only = TRUE, quietly = TRUE)
rm(list = c("packages", "newPackages"))

#define file locations
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "./UCI HAR Dataset.zip"
unzipDirectory <- "./UCI HAR Dataset/"
featureFile <- "features.txt"
xTrainFile <- "train/X_train.txt"
yTrainFile <- "train/y_train.txt"
subjectTrainFile <- "train/subject_train.txt"
xTestFile <- "test/X_test.txt"
yTestFile <- "test/y_test.txt"
subjectTestFile <- "test/subject_test.txt"
activityNamesFile <- "activity_labels.txt"

#download file if it hasnt been downloaded yet
if (!file.exists(zipFile)){
  download.file(URL, zipFile, mode = 'wb')
  unzip(zipFile, exdir = getwd())
}
rm(list = c("URL", "zipFile"))

#read measure names and convert to character vector
features <- read.table(paste(unzipDirectory, featureFile, sep = ""), header = FALSE)
featureNames <- as.character(features[, 2])
rm(list = c("features", "featureFile"))

#read training data
xTrainData <- read.table(paste(unzipDirectory, xTrainFile, sep = ""), header = FALSE)
yTrainData <- read.table(paste(unzipDirectory, yTrainFile, sep = ""), header = FALSE)
subjectTrainData <- read.table(paste(unzipDirectory, subjectTrainFile, sep = ""), header = FALSE)
rm(list = c("xTrainFile", "yTrainFile", "subjectTrainFile"))

#combine training data and assign names
trainData <- data.table(subjectTrainData, yTrainData, xTrainData)
colnames(trainData) <- c("subjectId", "activityId",featureNames)
rm(list = c("xTrainData", "yTrainData", "subjectTrainData"))
   
#read test data
xTestData <- read.table(paste(unzipDirectory, xTestFile, sep = ""), header = FALSE)
yTestData <- read.table(paste(unzipDirectory, yTestFile, sep = ""), header = FALSE)
subjectTestData <- read.table(paste(unzipDirectory, subjectTestFile, sep = ""), header = FALSE)
rm(list = c("xTestFile", "yTestFile", "subjectTestFile"))

#combine test data and assign names
testData <- data.table(subjectTestData, yTestData, xTestData)
colnames(testData) <- c("subjectId", "activityId", featureNames)
rm(list = c("xTestData", "yTestData", "subjectTestData"))

#combine data tables
combinedData <- data.table(rbind(trainData, testData))
rm(list = c("trainData", "testData"))

#filter feature character vector for fields with "mean" or "std" (keep subject and activity)
subsetColumnNames <- c("subjectId", "activityId", grep("mean|std", featureNames, value = TRUE))
rm("featureNames")

#subset combine data to only include desired columns 
subsetCombinedData <- combinedData[, c(subsetColumnNames), with = FALSE]
rm(list = c("combinedData", "subsetColumnNames"))

#read activty names
activities <- read.table(paste(unzipDirectory, activityNamesFile, sep = ""), header = FALSE)
colnames(activities) <- c("activityId", "activityName")
rm(list = c("unzipDirectory", "activityNamesFile"))

#merge activity names to subset of combine data
combinedDataWithActivity <- merge(subsetCombinedData, activities, by = "activityId")
rm(list = c("subsetCombinedData", "activities"))

#create a vector of names to be cleaned and start subbing, then assign the names back to the data
newNames <- names(combinedDataWithActivity)
newNames <- gsub("\\(\\)", "", newNames)
newNames <- gsub("-", "_", newNames)
newNames <- gsub("^t", "time", newNames)
newNames <- gsub("Acc", "Accelerometer", newNames)
newNames <- gsub("_mean", "_Mean", newNames)
newNames <- gsub("_std", "_StandardDeviation", newNames)
newNames <- gsub("_X$", "_X_Axis", newNames)
newNames <- gsub("_Y$", "_Y_Axis", newNames)
newNames <- gsub("_Z$", "_Z_Axis", newNames)
newNames <- gsub("Gyro", "Gyroscope", newNames)
newNames <- gsub("Mag", "Magnitude", newNames)
newNames <- gsub("^f", "frequency", newNames)
colnames(combinedDataWithActivity) <- newNames
rm("newNames")

#get the mean of all fields for each subject and activity
tidyData <- aggregate(combinedDataWithActivity, 
                      by = list(subject = combinedDataWithActivity$subjectId, 
                                activity = combinedDataWithActivity$activityName),
                      FUN = mean)
rm("combinedDataWithActivity")

#remove undesired columns
excludeNames <- c("activityId", "subjectId", "activityName")
tidyData <- tidyData[, c(!(names(tidyData) %in% excludeNames))]
rm("excludeNames")

#write tidy data to file
write.table(x = tidyData, file = "tidyData.txt", row.names = FALSE)
makeCodebook(tidyData, replace = TRUE)
rm("tidyData")
