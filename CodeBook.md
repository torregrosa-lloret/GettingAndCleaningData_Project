Code Book
================

The function *run_analysis.R* loads and tidy data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the [site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) where the data was obtained.

## Variables

The variables of this script are the following:

* Directories
  * **dirData**: (*chr*) Char vector containing the path to the "data" directory. 
  * **dirTrain**: (*chr*) Char vector containing the path to the "data/train" directory.
  * **dirTest**: (*chr*) Char vector containing the path to the "data/test" directory.

* Raw datasets
  * **features**: (*data.frame*, 561 obs. of 2 variables). Raw data.frame containing the names of the variables of the datasets, obtained after reading the file "./data/features.txt".
  * **activities**: (*data.frame*, 6 obs. of 2 variables). Raw data.frame containing the names and labels of the activities performed in the experiment, obtained after reading the file "./data/activity_labels.txt".
  * **xTrain**: (*data.frame*, 7532 obs. of 561 variables). Raw data.frame containing the values for the variables, obtained after reading the file "./data/train/X_train.txt".
  * **yTrain**: (*data.frame*, 7532 obs. of 1 variable). Raw data.frame containing the labels for the activities performed in the train dataset, obtained after reading the file "./data/train/Y_train.txt".
  * **subjectTrain**: (*data.frame*, 7532 obs. of 1 variable). Raw data.frame containing the code of the subject performing the experiments, obtained after reading the file "./data/train/subject_train.txt".
  * **xTest**: (*data.frame*, 2947 obs. of 561 variables). Raw data.frame containing the values for the variables, obtained after reading the file "./data/test/Y_test.txt".
  * **yTest**: (*data.frame*, 2947 obs. of 1 variable). Raw data.frame containing the labels for the activities performed in the test dataset, obtained after reading the file "./data/test/Y_test.txt".
  * **subjectTest**: (*data.frame*, 2947 obs. of 1 variable). Raw data.frame containing the code of the subject performing the experiments, obtained after reading the file "./data/test/subject_test.txt".

* Processed variables
  * **data**: (*data.frame*, 10299 obs. of 68 variables) Processed data.frame result of merging all the train and test datasets and selecting only the variables containing the mean or the standard deviation.
  * **tidyData**: (*tibble*, 10299 obs. of 68 variables) Data.frame table of the "data".
  * **averageTidyData**: (*tibble*, 180 obs. of 68 variables) Tidy data set with the average of each variable for each activity and each subject.

## Transformations

In this section the transformation applied to the raw datasets will be explained.

### 0. Loading of packages and raw datasets

In the first part of the script all the necessary packages and the raw datasets are loaded. Moreover, the variable names are assigned according to the names in the "features" data frame.

```
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
```

### 1. Merging of the training and the test sets to create one data set

In this part, the datasets are merged into one, according to the instructions of the assignment. The resulting dataset is assigned to the variable "data".

```
# Merge train dataset
xTrain <- cbind(xTrain, yTrain, subjectTrain)
# Merge test dataset
xTest <- cbind(xTest, yTest, subjectTest)
# Merge train and test dataset
data <- rbind(xTrain, xTest)
```
### 2. Extraction of only the measurements on the mean and standard deviation for each measurement

In this part, we select only the variables containing the strins "mean()" and "std()". Note the use of "\\" when using regular expressions in order to include the parenthesis as part of the expression. The reason to include the parenthesis is to avoid selecting the variables of the "meanFreq()".

```
data <- data[, grepl("mean\\(\\)",colnames(data)) 
             | grepl("std\\(\\)",colnames(data))
             | grepl("activity",colnames(data))
             | grepl("subject",colnames(data))]
```

### 3. Assigning descriptive activity names to name the activities in the data set

In this part, we assign the names of the activities to the activity codes in the dataset.

```
data$activity <- activities$name[data$activity]
```

### 4. Labeling the data set with descriptive variable names

In this part, we substitute the variable names (using the *gsub* function), assigning more descriptive variable names. The labeling was performed as following:

* t -> time
* f -> frequency
* Acc -> Acceletometer
* Gyro -> Gyroscope
* Mag -> Magnitude
* -mean() -> Mean
* -std() -> SD
* BodyBody -> Body

```
colnames(data)<-gsub("^t", "time", names(data))
colnames(data)<-gsub("^f", "frequency", names(data))
colnames(data)<-gsub("Acc", "Accelerometer", names(data))
colnames(data)<-gsub("Gyro", "Gyroscope", names(data))
colnames(data)<-gsub("Mag", "Magnitude", names(data))
colnames(data)<-gsub("-mean\\(\\)", "Mean", names(data))
colnames(data)<-gsub("-std\\(\\)", "SD", names(data))
colnames(data)<-gsub("BodyBody", "Body", names(data))
```

Finaly, we convert the data into a table data.frame.

```
tidyData <- tbl_df(data)
```

### 5. Creation of an independent tidy data set with the average of each variable for each activity and each subject.

In this part, we create an independent tidy data set with the average of each variable for each activity and each subject. Thus, we first grouped the data (using the function *group_by*) by activity and subject. Finally we write the tidy dataset as .txt file.

```
averageTidyData <- tidyData %>%
        group_by(activity, subject)%>%
        summarise_all(funs(mean))

write.table(averageTidyData, "TidyData.txt")
```