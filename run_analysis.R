# Merges the training and the test sets to create one data set.

install.packages("readr")
library(readr)
library(tidyr)
library(reshape2)
setwd("~/Desktop/Coursera/UCI HAR Dataset/train/")
file_list <- list.files(pattern = ".txt$")
file_list <- file_list[c(2,3,1)]

for (file in file_list){
        if(!exists("dataset")){
                dataset <-read.table(file)
        }else{
                temp_dataset <-read.table(file)
                dataset <-cbind(dataset,temp_dataset)
                rm(temp_dataset)
                }
}

setwd("~/Desktop/Coursera/UCI HAR Dataset/test/")
file_list2 <- list.files(pattern = ".txt$")
file_list2 <- file_list2[c(2,3,1)]

for (file in file_list2){
        if(!exists("dataset2")){
                dataset2 <-read.table(file)
        }else{
                temp_dataset <-read.table(file)
                dataset2 <-cbind(dataset2,temp_dataset)
                rm(temp_dataset)

}
}
dataset <- rbind(dataset,dataset2)

# find the measurements in the mean and sandard deviation for each measurement.

setwd("~/Desktop/Coursera/UCI HAR Dataset/")
file <- list.files(pattern="features.txt")
feature <- read.table(file)

# Extracts only the measurements on the mean and standard deviation for each measurement.

rows <-grep("mean()|std()",feature[,2],value=F) +2
dataset <-dataset[,c(1,2,rows)] 

# Extracts names from activity_labels.txt and replace those number in Column Activity.

file <- list.files(pattern="activity_labels.txt")
activity_labels <-read.table(file)
dataset[,2] <-activity_labels[dataset[,2],2]


# Extracts names of measurements from features.txt to replace the names of columns.

colnames(dataset) <- c("subject","activity",as.character(feature[rows-2,2]))

# Create new data set with the average of each variable for each activity and each subject.

dataMelt <- melt(dataset, id.vars = c("subject", "activity"))
dataCast <- dcast(dataMelt, subject + activity ~ variable, fun.aggregate = mean)
