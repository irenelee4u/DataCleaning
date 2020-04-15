Getting and Cleaning Data Project

This project is to create a tidy dataset from different tables from various files, as cleaning, grouping via binding. Details of analysis can be found in run_analysis.R and descriptions of variables, data, and transformations or work in the codebook.

The zip file to download and unzip:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The project will include:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

======================================================================
When unzipping "UCI HAR Dataset.zip" file, it has the following files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

In order to  read the files, assign a variable in order to read each file:
==
subject_test <- read.table("./test/subject_test.txt", header=FALSE)
subject_train <- read.table("./train/subject_train.txt",header=FALSE)
X_test <- read.table("./test/X_test.txt",header=FALSE)
X_train <- read.table("./train/X_train.txt",header=FALSE)
y_test <- read.table("./test/y_test.txt",header=FALSE)
y_train <- read.table("./train/y_train.txt",header=FALSE)

activity_labels <- read.table("./activity_labels.txt", header = FALSE)
features <- read.table("./features.txt", head=FALSE) 
==

When done with assigning all files to variables to read, merge the training and the test sets to create one data set. Basically, we will create a table binding X_train and X_test, Y_train and Y_test, subject_test and subject_train by rows(rbind), and features by columns (cbind).
==
subject <- rbind(subject_train, subject_test)
activity <- rbind(y_train, y_test)
dataSet <- rbind(X_train, X_test)
names(subject) <- c("subject")
names(activity) <- c("activity")
names(dataSet) <- features$V2

datacomb <- cbind(subject,activity)
data <- cbind(dataSet, datacomb)
==

Then, extract only the measurements on the mean and standard deviation for each measurement.
==
MeanStd <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2) ]
selectedNames <- c(as.character(MeanStd),"subject","activity")
dataSet <- subset(data,select=selectedNames)
==

Replace descriptive activity names to name the activities in the data set in order to show labels appropriately:

- prefix "t" is replaced by "time"
- "Acc" is replaced by "Accelerometer"
- "Gyro" is replaced by "Gyroscope"
- prefix "f" is replaced by "frequency"
- "Mag" is replaced by "Magnitude"
- "BodyBody" is replaced by "Body"

==
names(dataSet)[1] <- "Subject"
names(dataSet)[2] <- "Activity"
names(dataSet) <-gsub("^t", "time", names(dataSet))
names(dataSet)<-gsub("^f", "frequency", names(dataSet))
names(dataSet)<-gsub("Acc", "Accelerometer", names(dataSet))
names(dataSet)<-gsub("Gyro", "Gyroscope", names(dataSet))
names(dataSet)<-gsub("Mag", "Magnitude", names(dataSet))
names(dataSet)<-gsub("BodyBody", "Body", names(dataSet))
==

From the data set above, we will need to create a second, independent tidy data set with the average of each variable for each activity and each subject.
==
library(plyr)
Data2<-aggregate(. ~subject + activity, dataSet, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
==
