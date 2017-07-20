## Getting and Cleaning Data Course Project

if (!file.exists("./data")) {
  dir.create("./data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url = fileUrl, destfile = "./data/Dataset.zip")

# Unzip dataset to /data directory
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

## Merging the training and the test sets to create one data set
# Reading files
# Reading training files
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing files
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature files
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Reading activity files
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Assigning column names
colnames(x_train) <- features[ ,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[ ,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activityLabels) <- c("activityID", "activityType")

# Merging all data in one set
mergedTrain <- cbind(y_train, subject_train, x_train)
mergedTest <- cbind(y_test, subject_test, x_test)
Alldata <- rbind(mergedTrain, mergedTest)

## Extracting only the measurements on the mean and standard deviation for each measurement
# Reading column names
ColNames <- colnames(Alldata)

# Searching for IDs, mean and standard deviation
mean_and_std <- (grepl("activityID", ColNames) |
                 grepl("subjectID", ColNames) |
                 grepl("mean..", ColNames) |
                 grepl("std..", ColNames)
                 )

# Subsetting data
mean_and_std_subset <- Alldata[ , mean_and_std == TRUE]

## Using descriptive activity names to name the activities in the data set
setwithActivityNames <- merge(mean_and_std_subset, activityLabels, by = "activityID", all.x = TRUE)

## Appropriately labels the data set with descriptive variable names
# Prefix "t" is replaced by "time"
names(setwithActivityNames) <- gsub("^t", "time", names(setwithActivityNames))

# Prefix "f" is replaced by "frequency"
names(setwithActivityNames) <- gsub("^f", "frequency", names(setwithActivityNames))

# "Acc" is replaced by "Accelerometer"
names(setwithActivityNames) <- gsub("Acc", "Accelerometer", names(setwithActivityNames))

# "Gyro" is replaced by "Gyroscope"
names(setwithActivityNames) <- gsub("Gyro", "Gyroscope", names(setwithActivityNames))

# "Mag" is replaced by "Magnitude"
names(setwithActivityNames) <- gsub("Mag", "Magnitude", names(setwithActivityNames))

# "BodyBody" is replaced by "Body"
names(setwithActivityNames) <- gsub("BodyBody", "Body", names(setwithActivityNames))


## Creating a second, independent tidy data set with the average of each variable for each activity and each subject
# Making second tidy data set

secondDataset <- aggregate(.~subjectID + activityID, setwithActivityNames, mean)
secondDataset <- secondDataset[order(secondDataset$subjectID, secondDataset$activityID), ]

# Writing second tidy data set in txt file
write.table(secondDataset, "Second Tidy Dataset.txt", row.names = FALSE)















