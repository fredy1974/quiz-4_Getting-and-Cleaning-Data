library(dplyr)
library(data.table)
library(tidyr)

setwd("C:/Fredy/UCI HAR Dataset")

## Read data frame
subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")
X_test <- read.table("X_test.txt")
X_train <- read.table("X_train.txt")
y_test <- read.table("y_test.txt")
y_train <- read.table("y_train.txt")

labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")  

## Questions
# Merges the training and the test sets to create one data set.
dataTable <- rbind(X_train,X_test)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
MeanStdOnly <- grep("mean()|std()", features[, 2]) 
dataTable <- dataTable[,MeanStdOnly]

# Uses descriptive activity names to name the activities in the data set
act_group <- factor(dataTable$activity)
levels(act_group) <- activity_labels[,2]
dataTable$activity <- act_group

# Appropriately labels the data set with descriptive activity names.
CleanFeatureNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(dataTable) <- CleanFeatureNames[MeanStdOnly]

# combine test and train of subject data and activity data, give descriptive lables
subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(y_train, y_test)
names(activity) <- 'activity'

dataTable <- cbind(subject,activity, dataTable)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

write.table(dataTable, "TidyData.txt", row.name=FALSE)
