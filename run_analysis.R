rm(list=ls())
library(dplyr)
library(tidyr)
library(plyr)

## Merges the training and the test sets to create one data set
x_train <- read.table("train/X_train.txt")

y_train <- read.table("train/y_train.txt")

subj_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")

y_test <- read.table("test/y_test.txt")

subj_test <- read.table("test/subject_test.txt")


x_data <- rbind(x_train, x_test)

y_data <- rbind(y_train, y_test)

# create 'subject' data set

subj_data <- rbind(subj_train, subj_test)

#################################################################################
#Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("features.txt")

# get only columns with mean() or std() in their names
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_std ]
############################################################
# Uses descriptive activity names to name the activities in the data set
# correct the column names
names(x_data) <- features[mean_std , 2]

##################################################################################

activities <- read.table("activity_labels.txt")

########################################################
# update values with correct activity names

y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name

names(y_data) <- "activity"

##################################################################################
# correct column name

names(subj_data) <- "subject"



# bind all the data in a single data set

all_data <- cbind(x_data, y_data, subj_data)
all_names<-names(all_data)

averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)

