# The provided script (run_analysis.R) operates on the source data to generate a tidy data set (tidydata.txt) 
# that takes the average of a subset of the variables across subject-activity groups. The source dataset, 
# the resulting dataset upon running the script, as well as all terminology around the experiment and naming 
# of variables are described in the code book (CodeBook.txt).

#############
### setup ###
#############

# This part of the script sets up the working directory and the needed libraries
rm(list = ls())
setwd("//Users//nikolaydobrinov//Documents//work//Courses//R//WorkDirectory//Course3_peer_graded_coding_assignment")

library(dplyr)
library(tidyr)

###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###
### Step 1: Merges the training and the test sets to create one data set.     ###
###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###

# In this step we first download and unzip the data to a local subfolder in the work directory.  
# Next we first merge all files related to the test subset of subjects and separately all files 
# related to train subset of subject. As data is loaded in R the column names, V1, V2, etc, 
# are replaced with variable names. The measurements in the files "X_test.txt" and"X_train.txt" 
# adopt variable names from the second column of the text file "features.txt". Corresponding 
# test and train data sets are given the same names of key variables (subject, activityID) 
# that will be later needed to merge the test and train data. Finally we vertically rbind 
# the train and test data sets. This completes the requirements for Step 1, and partially 
# addresses the requirements for Step 4. The final data set at the completion of this step 
# is named "alldata".

#################################################
### download the data and unzip the csv files ###
#################################################

# download the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Data/activity.zip",method="curl")
# list.files("./Data")

# unzip the files        
zipFile<- "./Data/activity.zip"
outDir<-"./Data"
unzip(zipFile,exdir=outDir)

########################################
### read the data and rename columns ###
########################################

# Note that in this step as we read the data we immediately replace the V1-V... variable names with appropriate variable labels
# the variables in the 'measures.txt' data sets take their names from the features.txt data set

# read data on labels and features
activity <- read.table("./Data/UCI HAR Dataset/activity_labels.txt", header=FALSE, col.names=c("activityID", "activity"))
features <- read.table("./Data/UCI HAR Dataset/features.txt", header=FALSE, col.names=c("featureID", "feature"))

# read test data
measures_test <- read.table("./Data/UCI HAR Dataset/test/X_test.txt", header=TRUE, col.names=features$feature)
subj_test <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt",header=TRUE, col.names="subject")
activity_test <- read.table("./Data/UCI HAR Dataset/test/y_test.txt",header=TRUE, col.names="activityID")

# read train data
measures_train <- read.table("./Data/UCI HAR Dataset/train/X_train.txt", header=TRUE, col.names=features$feature)
subj_train <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt",header=TRUE, col.names="subject")
activity_train <- read.table("./Data/UCI HAR Dataset/train/y_train.txt",header=TRUE, col.names="activityID")

#######################
### merge data sets ###
#######################
testdata <- cbind(subj_test,activity_test,measures_test)
traindata <- cbind(subj_train,activity_train,measures_train)
alldata <- rbind(testdata,traindata) # this merges all the data


###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###
### Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. ###
###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###

# In this step we use grep function to select only variables that contain in the name either "subject" 
# or "activity" or "mean" or "std". The analyst has selected to include in this subset variables that measure 
# "meanFreq()" as these represent the weighted mean for the frequency variables. A separate line of code is 
# also provided (commented out) to exclude the "meanFreq()" from this subset. This completes the requirements 
# to Step 2. The final data set after this step is completed is named "datameanstd".

# subset the data frame using grep on the names of the variables
# note that this code of line also matches the meanFreq() because these are also means, albeight weighted means
datameanstd <- alldata[,grep("subject|activity|mean|std",names(alldata), value=TRUE)]

# if one wishes to not match the meanFreq() variables, then the following code can be used.
# datameanstd <- data[,grep("subject|activity|\\.mean\\.|\\.std\\.",names(data), value=TRUE)]


###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###
### Step 3: Uses descriptive activity names to name the activities in the data set. ###
###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###

# In this step we use the activity.labels from the dataset "activity_labels.txt" to replace the activity 
# codes in the "datameanstd" data set from the first step. The procedure is to first merge the two datasets 
# by the key variable "activityID creating a new variable named "activity" that houses the activity lables. 
# Then we drop "activityID" from the new data set, and finally rearrange the variables in the resulting dataset 
# so that "subject" is the first variable, "actvity" is the second variable, and these two variables 
# are followed by all measures. 
# 
# A choice was made in this step to note keep the activityID codes in the data set as this variable is redundant, 
# not bringing any new information to the data set. In addition, a factor with clearly specified levels, that 
# have a good descriptive power, is preferred in data analysis than a factor variable that houses numeric codes 
# for the levels of the factor. This completes Step 3. The final data set after this step is completed is also 
# named "datameanstd".

# replace activityID with activity.labels
datameanstd <- merge(datameanstd,activity,by.x="activityID",by.y="activityID") # assigns activity.label to activityID
datameanstd <- select(datameanstd,-activityID) # removes the activity ID columns that is not needed
datameanstd <- select(datameanstd, subject, activity, everything()) # relocates activity to be the second column

###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###
### Step 4: Appropriately labels the data set with descriptive variable names ###
###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###

# Part of what is required in Step 4 is accomplished in Step 1, where the measurements column names V1, V2, etc, 
# have been replaced with the variables names stored in the "features.txt" dataset. Following the instructions 
# in the lectures to Course 3 of the Data Science specialization, we also remove any dots from the variable names, 
# and force all capital letters to be lowercase.

colnames(datameanstd) <- tolower(gsub("\\.","",names(datameanstd)))
# names(datameanstd)

# No further manipulation is done to the variables names. We believe that at this format the variable names are 
# providing a good balance between readability and conciseness. Any further enhancement to the variables' names 
# would require these names to become much longer and difficult to work with in any subsequent analysis. The code book 
# provides all information needed to understand the labels behind these variable names. Also see the "ReadMe.md" file for more details.

###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###
### Step 5: From the data set in step 4, creates a second, independent tidy data set ###
### with the average of each variable for each activity and each subject.            ###
### Export the data.                                                                 ###
###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###

# We believe that the choice between the narrow vs the wide form of the tidy data depends on the purpose 
# of the data set; what question are we trying to answer with the data. Assuming that the purpose of 
# the dataset is to study functional relationships, our choice is to keep the wide form of the tidy data set, 
# where each signal has two or three measures - a mean, an std, and a meanFreq - and these measures are each 
# averaged over the 180 groups of subject-activity. We provide much needed detail in our reasoning to making
# this particular choice in the ReadMe.md file. Thus, once the average is calculated for all these 180 groups, 
# the tidy data set has 180 rows and 81 columns. 

# group the data by combinations of subject+activity, this gives you 180 combinations
# then take the mean of each column
datameanstd_groupmean <- datameanstd %>% group_by(subject,activity) %>% summarise_each(funs(mean))
# View(datameanstd_groupmean)

# write the data to a file
write.table(datameanstd_groupmean,file="tidydata.txt", row.name=FALSE)
tidydata <- read.table("tidydata.txt", header=TRUE) # this is the code needed to read the data back into R
