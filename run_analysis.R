#Download file and set working directory
setwd("~/Desktop/data/UCI HAR Dataset")
list.files("~/Desktop/data/UCI HAR Dataset")
#Create path to files
pathdata = file.path("~/Desktop/data", "UCI HAR Dataset")
files <- list.files(pathdata, recursive = TRUE)

#Read data sets for train, test, features, activity files
#Training tables
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
#Test tables
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
#Features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)
#Activity data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#Labeling columns for the train data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
#Labeling columns for the the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
#Labeling columns for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')

#Merge train and test data
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
#Create primary data table of train and test
train_and_test = rbind(mrg_train, mrg_test)

#Extract mean and std dev
#Read available values
colNames = colnames(train_and_test)
#Subset mean and std dev for corresponding data
mean_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#Subset creation of mean and std dev
subset_mean_std <- train_and_test[ , mean_std == TRUE]
#Set activity names
dataWithActivityNames = merge(subset_mean_std, activityLabels, by='activityId', all.x=TRUE)

# Create Tidy Set
myTidySet <- aggregate(. ~subjectId + activityId, dataWithActivityNames, mean)
myTidySet <- myTidySet[order(myTidySet$subjectId, myTidySet$activityId),]
#Create new text file with new data set 
write.table(myTidySet, "myTidySet.txt", row.name=FALSE)