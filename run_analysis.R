if (require("dplyr")) {
  install.packages(dplyr)
}

library(dplyr)

if (!file.exists("UCI HAR Dataset")) {
  temp <- tempfile()
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, temp)
  unzip(temp)
  rm(temp)
}

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
sub_all <- rbind(sub_train, sub_test)

features_selected <- features[grep("(?i)mean|std", features[ , 2]), ]
X <- X[ ,features_selected[ , 1]]

colnames(Y) <- "label"
Y$activity <- factor(Y$label, labels = as.character(activity_labels[ , 2]))
activity <- Y$activity

colnames(X) <- features[features_selected[ , 1], 2]

colnames(sub_all) <- "subject"
combine <- cbind(X, activity, sub_all)
temp <- group_by(combine, activity, subject)
final <- summarize_all(temp, funs(mean))

write.table(final, file = "./Final_data.txt", row.names = FALSE, col.names = TRUE)

