## Data download, unzip, and libraries
library(data.table)
library(reshape2)

# file download
fileName <- "UCI HAR Dataset.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"

# File download verification. If file does not exist, download to working directory.
if(!file.exists(fileName)){
        download.file(url,fileName, method = "curl") 
}

# File unzip verification. If the directory does not exist, unzip the downloaded file.
if(!file.exists(dir)){
        unzip("UCI HAR Dataset.zip", files = NULL, exdir=".")
}

## Read Data
# assign to different variables to read different tables
subject_test <- read.table("./test/subject_test.txt", header=FALSE)
subject_train <- read.table("./train/subject_train.txt",header=FALSE)
X_test <- read.table("./test/X_test.txt",header=FALSE)
X_train <- read.table("./train/X_train.txt",header=FALSE)
y_test <- read.table("./test/y_test.txt",header=FALSE)
y_train <- read.table("./train/y_train.txt",header=FALSE)

activity_labels <- read.table("./activity_labels.txt", header = FALSE)
features <- read.table("./features.txt", head=FALSE) 

## 1. Merges the training and the test sets to create one data set.
#merging data from different data sets with cbind and rbind
subject <- rbind(subject_train, subject_test)
activity <- rbind(y_train, y_test)
dataSet <- rbind(X_train, X_test)
names(subject) <- c("subject")
names(activity) <- c("activity")
names(dataSet) <- features$V2

datacomb <- cbind(subject,activity)
data <- cbind(dataSet, datacomb)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# a vector of mean and std only
MeanStd <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2) ]
selectedNames <- c(as.character(MeanStd),"subject","activity")
dataSet <- subset(data,select=selectedNames)

## 3. Uses descriptive activity names to name the activities in the data set
# Column Naming for Activity and Subject
## 4. Appropriately labels the data set with descriptive activity names.
#abbrebiations to full labels
names(dataSet)[1] <- "Subject"
names(dataSet)[2] <- "Activity"

names(dataSet) <-gsub("^t", "time", names(dataSet))
names(dataSet)<-gsub("^f", "frequency", names(dataSet))
names(dataSet)<-gsub("Acc", "Accelerometer", names(dataSet))
names(dataSet)<-gsub("Gyro", "Gyroscope", names(dataSet))
names(dataSet)<-gsub("Mag", "Magnitude", names(dataSet))
names(dataSet)<-gsub("BodyBody", "Body", names(dataSet))


## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
library(plyr)
Data2<-aggregate(. ~subject + activity, dataSet, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
