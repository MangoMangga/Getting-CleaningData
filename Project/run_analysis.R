library(plyr)

## Read all data from local dir 
trainset <- read.table("./train/X_train.txt")
testset <- read.table("./test/X_test.txt")
testlabel <- read.table("./test/y_test.txt")
trainlabel <- read.table("./train/y_train.txt")
subjtrain <- read.table("./train/subject_train.txt")
subjtest <- read.table("./test/subject_test.txt")

## 1. merges the training dataset and the test dataset
dtset <- rbind(trainset,testset)
dtlabel <- rbind(trainlabel,testlabel)
dtsubj <- rbind(subjtrain,subjtest)

## 2.Extracts only the measurements on the mean 
##   and standard deviation for each measurement 
features <- read.table("features.txt",stringsAsFactors = F)
MeanStd <- grep("mean[^F]|std",features[,2])
dtMeanStd <- dtset[,MeanStd]

## 3.Name the activities in the data set
##   Uses descriptive activity names
activityLabel <- read.table('./activity_labels.txt')
activityLabel[, 2] <- gsub("_","",activityLabel[,2])
activityLabel[, 2] <- tolower(as.character(activityLabel[, 2]))
names(dtlabel) <- "activities"
dtlabel[,1] <- activityLabel[dtlabel[,1],2]


## 4. Appropriately labels the data set 
##    with descriptive activity names

names(dtsubj) <- "subjectId"
cleanData <- cbind(dtsubj,dtMeanStd,dtlabel)
write.table(cleanData, "TidyDataset.txt",row.names = F)   

## 5. Create independent dataset from step 4
avgDataset <- ddply(cleanData, .(subjectId, activities)
                 , .fun=function(x){ colMeans(x[,c(3:67)]) })

write.table(avgData, "AvgDataset.txt",row.names = F)   
