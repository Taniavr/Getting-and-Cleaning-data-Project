
##Read files
testY = read.table("./UCI HAR Dataset/test/Y_test.txt", head=FALSE)
testX = read.table("./UCI HAR Dataset/test/X_test.txt", head=FALSE)
subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt", head=FALSE)

trainX =read.table("./UCI HAR Dataset/train/X_train.txt", head=FALSE)
trainY =read.table("./UCI HAR Dataset/train/Y_train.txt", head=FALSE)
subject_train =read.table("./UCI HAR Dataset/train/subject_train.txt", head=FALSE)

features = read.table("./UCI HAR Dataset/features.txt", head=FALSE)
activity_labels = read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityID", "Activity"))


##concatenates the test set and the train set.
Subjectdata  <- rbind(subject_test, subject_train)
Alldata  <- rbind(testX, trainX)
Labeldata  <- rbind(testY, trainY)


## Lables the variables labels subject and activity
names(Subjectdata)  <- c("subjectID")
names(Labeldata)  <- c("ActivityID")

##adding the features lables to the data
names(Alldata) <- features$V2

##combining the three tables together:
Data <- cbind(Subjectdata, Labeldata, Alldata)

## Extracting only the variables that contain mean and std:
Data1  <- Data[,grepl("mean\\(\\)|std\\(\\)|subjectID|ActivityID", names(Data))]

##adds descriptive activity name to Data1
Data2  <- join(Data1, activity_labels, by="ActivityID", match = "first")
Data2 <- Data2[,-1] ##removes column#1 that was replaced with the descriptive activity.
Data2  <- Data2[,c(1,68,2:67)] ##re orders Activity to be the second column instead of the ast one
head(Data2,2)


##removes parentheseses, for tidier data
names(Data2) <- gsub('\\(|\\)',"",names(Data2), perl = TRUE)

##adds descriptive names to variable names
names(Data2) <- gsub('Acc',"Acceleration",names(Data2))
names(Data2) <- gsub('Gyro',"Gyroscope",names(Data2))
names(Data2) <- gsub('Mag',"Magnitude",names(Data2))
names(Data2) <- gsub('^t',"Time",names(Data2))
names(Data2) <- gsub('^f',"Frequency",names(Data2))
names(Data2) <- gsub('\\.mean',".Mean",names(Data2))
names(Data2) <- gsub('\\.std',".StandardDeviation",names(Data2))
names(Data2) <- gsub('Freq\\.',"Frequency.",names(Data2))

## creates a separate tidy data set with the average of each variable for each activity
Data_mean  <- aggregate(.~subjectID + Activity, Data2, mean)
## creates a .txt file with the tidy data set.
write.table(Data_mean, file = "tidyDataSet.txt", row.name=FALSE)