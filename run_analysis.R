## Import packages
library(dplyr)

## Folders containing the data
dirData <- file.path(".","data")
dirTrain <- file.path(dirData, "train")
dirTest <- file.path(dirData, "test")

## Load datasets
features <- read.table(file.path(dirData,"features.txt"), 
                       col.names = c("num", "name"),
                       stringsAsFactors = FALSE)                      # Feature Names
activities <- read.table(file.path(dirData,"activity_labels.txt"), 
                         col.names = c("label", "name"),
                         stringsAsFactors = FALSE)                    # Activity Names

xTrain <- read.table(file.path(dirTrain,"X_train.txt"))               # Train Dataset
colnames(xTrain) <- features$name
yTrain <- read.table(file.path(dirTrain,"Y_train.txt"),
                     col.names = "activity")                          # Labels of the train Dataset
subjectTrain <- read.table(file.path(dirTrain, "subject_train.txt"),
                           col.names = "subject")                     # Subject who performed the activity

xTest <- read.table(file.path(dirTest,"X_test.txt"))                  # Test Dataset
colnames(xTest) <- features$name 
yTest <- read.table(file.path(dirTest,"Y_test.txt"),
                    col.names = "activity")                              # Labels of the train Dataset
subjectTest <- read.table(file.path(dirTest, "subject_test.txt"),
                          col.names = "subject")                      # Subject who performed the activity

## 1. Merge the training and the test sets to create one data set
# Merge train dataset
xTrain <- cbind(xTrain, yTrain, subjectTrain)
# Merge test dataset
xTest <- cbind(xTest, yTest, subjectTest)
# Merge train and test dataset
data <- rbind(xTrain, xTest)

## 2. Extract only the measurements on the mean and standard deviation for each measurement
data <- data[, grepl("mean\\(\\)",colnames(data)) 
             | grepl("std\\(\\)",colnames(data))
             | grepl("activity",colnames(data))
             | grepl("subject",colnames(data))]

## 3. Use descriptive activity names to name the activities in the data set
data$activity <- activities$name[data$activity]

## 4. Appropriately label the data set with descriptive variable names
colnames(data)<-gsub("^t", "time", names(data))
colnames(data)<-gsub("^f", "frequency", names(data))
colnames(data)<-gsub("Acc", "Accelerometer", names(data))
colnames(data)<-gsub("Gyro", "Gyroscope", names(data))
colnames(data)<-gsub("Mag", "Magnitude", names(data))
colnames(data)<-gsub("-mean\\(\\)", "Mean", names(data))
colnames(data)<-gsub("-std\\(\\)", "SD", names(data))
colnames(data)<-gsub("BodyBody", "Body", names(data))

tidyData <- tbl_df(data)

## 5. From the data set in step 4, create a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
averageTidyData <- tidyData %>%
        group_by(activity, subject)%>%
        summarise_all(funs(mean))

write.table(averageTidyData, "TidyData.txt", row.name=FALSE)
