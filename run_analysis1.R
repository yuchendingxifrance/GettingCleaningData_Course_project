library(dplyr)

## load the data
### reading the testing data and add columns activity and subject 
testData<-read.table("./UCI HAR Dataset/X_test.txt")
testSubject<-read.table("./UCI HAR Dataset/subject_test.txt")
testLabel<-read.table("./UCI HAR Dataset/y_test.txt")

testData<-cbind(testSubject,testLabel,testData)

### reading the training data and add the columns activity and subject 
trainData<-read.table("./UCI HAR Dataset/X_train.txt")
trainSubject<-read.table("./UCI HAR Dataset/subject_train.txt")
trainLabel<-read.table("./UCI HAR Dataset/y_train.txt")

trainData<-cbind(trainSubject,trainLabel,trainData)

### merge data and assign the variable names to its columns
mergedData<-rbind(trainData,testData)

features<-read.table("./UCI HAR Dataset/features.txt")
features$V2<-as.character(features$V2)

activities<-read.table("./UCI HAR Dataset/activity_labels.txt")


names(mergedData)<-c("subject","activity",features$V2)


## extract the columns only contain mean and standard deviation data
mergedData<-mergedData[,c(1,2,grep("mean|std",names(mergedData)))]
str(mergedData)

### use descriptive activity names that are provided in activity_labels file
mergedData$subject<-factor(mergedData$subject)
levels(mergedData$activity)<-c("walking","walking_upstairs","walking_downstairs",
                               "sitting","standing","laying")


### tidy the variable names and remove the special characters
names(mergedData)<-gsub("\\(\\)-|\\(\\)|-","",names(mergedData))
names(mergedData)<-gsub("^t","time",names(mergedData))
names(mergedData)<-gsub("^f","frequency",names(mergedData))
names(mergedData)<-gsub("mean","Mean",names(mergedData))
names(mergedData)<-gsub("std","StandardDeviation",names(mergedData))
names(mergedData)<-gsub("freq","Frequency",names(mergedData))
names(mergedData)<-gsub("gyro","Gyroscope",names(mergedData))
names(mergedData)<-gsub("mag","Magnitude",names(mergedData))
names(mergedData)<-gsub("acc","Accelerometer",names(mergedData))


## summarize means of each variable grouped by activity and subject
TidyData<-mergedData%>% group_by(subject,activity)%>% summarize_all(mean)

write.table(TidyData,file="tidyData",row.name=FALSE)




























