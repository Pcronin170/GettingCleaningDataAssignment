##################################################
#R course project
##################################################


#################################################
#Import all the files


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

#####################################################
#1. Merge training and test sets to 
combined = data.table(rbind(train,test))
class(combined)

######################################################
#2. Extract only measurements with mean and standard deviation
vectorNames <- names(combined)
meanRows = grepl("mean()",vectorNames)
stdRows = grepl("std()",vectorNames)
meanFreq = grepl("meanFreq()",vectorNames)
includeColumns = vectorNames[(meanRows | stdRows) & !meanFreq ]
data_MeanStd = subset(combined,select = c(includeColumns))

###################################################3
#4. Appropriately label data set with descriptive variable names

#Nice names for file
newNames <-
        c('Body Acceration mean  X Axis',
          'Body Acceration mean Y Axis',
          'Body Acceration mean Z Axis',
          'Body Acceration  standard deviation X',
          'Body Acceration  standard deviation Y',
          'Body Acceration  standard deviation Z',
          'Gravity Acceleration mean X Axis',
          'Gravity Acceleration meanY Axis',
          'Gravity Acceleration meanZ Axis',
          'Gravity Acceleration standard deviation X Axis',
          'Gravity Acceleration standard deviationY Axis',
          'Gravity Acceleration standard deviationZ Axis',
          'Body Acceration Jerkmean  X Axis',
          'Body Acceration Jerkmean Y Axis',
          'Body Acceration Jerkmean Z Axis',
          'Body Acceration Jerk standard deviation X',
          'Body Acceration Jerk standard deviation Y',
          'Body Acceration Jerk standard deviation Z',
          'Gyroscope mean X Axis',
          'Gyroscope meanY Axis',
          'Gyroscope meanZ Axis',
          'Gyroscope standard deviation X Axis',
          'Gyroscope standard deviation Y Axis',
          'Gyroscope standard deviation Z Axis',
          'Body Gyro Jerk Signals mean X Axis',
          'Body Gyro Jerk Signals meanY Axis',
          'Body Gyro Jerk Signals meanZ Axis',
          'Body Gyro Jerk Signals standard deviation X Axis',
          'Body Gyro Jerk Signals standard deviationY Axis',
          'Body Gyro Jerk Signals standard deviationZ Axis',
          'Body Acceration Magmean ',
          'Body Acceration Mag-standard deviation',
          'Gravity Acceleration Magnitudemean ',
          'Gravity Acceleration Magnitude standard deviation',
          'Body Acceration JerkMagmean ',
          'Body Acceration JerkMag standard deviation',
          'Body Gyro Magnitude mean',
          'Body Gyro Magnitude standard deviation',
          'Body Gyro Jerk Magnitude mean',
          'Body Gyro Jerk Magnitude standard deviation',
          'Body Acceleration mean X Axis',
          'Body Acceleration meanY Axis',
          'Body Acceleration meanZ Axis',
          'Body Acceleration standard deviation X Axis',
          'Body Acceleration standard deviationY Axis',
          'Body Acceleration standard deviationZ Axis',
          'Body Accelaration Jerk mean X Axis',
          'Body Accelaration Jerk meanY Axis',
          'Body Accelaration Jerk meanZ Axis',
          'Body Accelaration Jerk standard deviation X Axis',
          'Body Accelaration Jerk standard deviation Y Axis',
          'Body Accelaration Jerk standard deviation Z Axis',
          'Body gyroscope mean  X Axis',
          'Body gyroscope mean Y Axis',
          'Body gyroscope mean Z Axis',
          'Body gyroscope  standard deviation X',
          'Body gyroscope  standard deviation Y',
          'Body gyroscope  standard deviation Z',
          'Body Acceleration Magnitudemean ',
          'Body Acceleration Magnitude-standard deviation',
          'Body Body Acceleration Jerk Magnitude mean ',
          'Body Body Acceleration Jerk Magnitude standard deviation',
          'Body Body Gyroscope Magnitudemean',
          'Body Body Gyroscope Magnitude standard deviation',
          'Body Body Gyroscope Jerk Magnitude mean',
          'Body Body Gyroscope Jerk Magnitude standard deviation')

#Save namese to file
names(data_MeanStd) <- newNames

#Calculate averages of each file
Data_Averages <- lapply(data_MeanStd,mean)
Data_STD <- lapply(data_MeanStd,sd) 
meanAndStd <- cbind(Data_Averages,Data_STD)



###################################################
#5. Creates tidy dat set with average of each variable
#for each activity and each subject

library(plyr)
library(reshape2)

data.ByActivity = cbind(combined$activity,data_MeanStd)
names(data.ByActivity) = c("activity",newNames)

###################################################
#3. Replace numbers with activity text

activity.reference = data.table(1:6,c("Walking","Walking_Upstairs","Walking_Downstairs","Sitting","Standing","Laying"))

names(activity.reference) = c("activity","activity_text")

data.ByActivity = merge(activity.reference,
                        data.ByActivity,
                        by = "activity")

combineMelt <- melt(data.ByActivity,id=c("activity_text"),measure.vars=newNames)

sumData <- dcast(combineMelt,activity_text ~ variable,mean,na.rm = TRUE)
sumData

#6. Write out to file
write.table(sumData,row.name = FALSE, file = "tidyData.txt")

