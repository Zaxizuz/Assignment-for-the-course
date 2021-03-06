---
title: "Human Activity Recognition Using Smartphones Dataset"
author: "Sen Lin"
date: "7/8/2017"

---


# Introduction
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

In this exercise, the code conbinds all the data and shows the result in a tidy form.

The dataset includes the following files:
----------------------------------------
1.README.md       
2.Codebook.md     
3.run-analysis.R  
4.results.txt      


'README.md': explaination of the clear and understandable dataset.  

'Codebook.md': A file including descriptions of every column.

'run-analysis.R': The code which is designed for cleaning the raw data set.

'results.txt': The result generated by the code. 

# How the code works
## Step 1 Merges the training and the test sets to create one dataset

```{}
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
```

The dataset includes 30 volunteers' data and merges them into one data set.

## Step 2 Extracts only the measurements on the mean and standard deviation for each measurement

```{}
setwd("~/Desktop/Coursera/UCI HAR Dataset/")
file <- list.files(pattern="features.txt")
feature <- read.table(file)

rows <-grep("mean()|std()",feature[,2],value=F) +2
dataset <-dataset[,c(1,2,rows)] 
```

This process extracts the names of the features including mean and standard deviation.
Then, forming a new dataset only including those measurements to replace the original dataset.


## Step 3 Uses descriptive activity names to name the activities in the data set

```{}
file <- list.files(pattern="activity_labels.txt")
activity_labels <-read.table(file)
dataset[,2] <-activity_labels[dataset[,2],2]
```

This step reads the file including all the names of activities. And it names all the data in Column Activity based on the numbers in the column.

## Step 4 Appropriately labels the data set with descriptive variable names

```{}
colnames(dataset) <- c("subject","activity",as.character(feature[rows-2,2]))
```

The code extracts those names from the data, feature, which is the data loaded from features.txt.
After that, we replace those names of measurements with names from the data, feature.

## Step 5 
From the data set in step4, creates a second, independent tidy data set withe the average
of each variable for each activity and each subject.

```{}
dataMelt <- melt(dataset, id.vars = c("subject", "activity"))
dataCast <- dcast(dataMelt, subject + activity ~ variable, fun.aggregate = mean)
```

In this step, we rearrange the data set based on their subject and activity.
With the funciton, dcast, we can get the average of each variable for each activity and each subject.





License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
