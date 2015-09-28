##################################################
#R course project
##################################################

#Import training set wtih titles
setwd("h:/coursera/GettingCleaningData")
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")

#Import Testing data
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")

#Import features
features = read.table("./UCI HAR Dataset/features.txt")
features = features[,c("V2")]

#Rename training and testing data with feature names
names(train_x) = features
names(test_x) = features

#Add outcomes to data
names(train_y) = c("activity")
names(test_y) = c("activity")

#Combine the type of activity together
train = cbind(train_y,train_x)
test = cbind(test_y,test_x)

library(data.table)

#Merge training and test sets to 
combined = data.table(rbind(train,test))
class(combined)

######################################################
#Extract only measurements with mean and standard deviation

vectorNames <- names(combined)
meanRows = grepl("mean()",vectorNames)
stdRows = grepl("std()",vectorNames)
meanFreq = grepl("meanFreq()",vectorNames)
includeColumns = vectorNames[(meanRows | stdRows) & !meanFreq ]

write(includeColumns,"names.txt")


###################################################3
#Calcualtes Mean and Standard deviation

data_MeanStd = subset(combined,select = c(includeColumns))
Data_Averages <- lapply(data_MeanStd,mean)
Data_STD <- lapply(data_MeanStd,sd) 
meanAndStd <- cbind(Data_Averages,Data_STD)


###################################################
#Creates tidy dat set with average of each variable
#for each activity and each subject

library(plyr)
library(reshape2)

data.ByActivity = cbind(combined$activity,data_MeanStd)
names(data.ByActivity) = c("activity",includeColumns)

#Replace numbers with activity
activity.reference = data.table(1:6,c("Walking","Walking_Upstairs","Walking_Downstairs","Sitting","Standing","Laying"))

names(activity.reference) = c("activity","activity_text")

data.ByActivity = merge(activity.reference,
                        data.ByActivity,
                        by = "activity")

combineMelt <- melt(data.ByActivity,id=c("activity_text"),measure.vars=includeColumns)

sumData <- dcast(combineMelt,activity_text ~ variable,mean,na.rm = TRUE)
sumData

write.table(sumData,row.name = FALSE, file = "tidyData.txt")

