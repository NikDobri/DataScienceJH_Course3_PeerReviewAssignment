## Description of  procedure and resulting dataset                     
 
The source data for this dataset was collected by Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz for the purposes of the Human Activity Recognition Using Smartphones study. More information on the source data set is provided in the Appendix at the end of this document. The provided script (run_analysis.R) operates on the source data to generate a tidy data set (tidydata.txt) that takes the average of a subset of the variables across subject-activity groups. The source dataset, the resulting dataset upon running the script, as well as all terminology around the experiment and naming of variables are described in the code book (CodeBook.txt).

The tidy dataset can be loaded in R with the following script:

fileUrl <- "https://s3.amazonaws.com/coursera-uploads/peer-review/9ecc142db9777f061e1a052256b76c6d/tidydata.txt"  
fileUrl <- sub("^https", "http", address)  
tidydata <- read.table(url(fileUrl), header = TRUE)  
View(tidydata)

It can also be loaded from a local folder with: 

tidydata <- read.table("path//tidydata.txt", header=TRUE)


## Walk through steps of the script
### Set up
This part of the script sets up the working directory and the needed libraries

### Step 1: Merges the training and the test sets to create one data set. 
In this step we first download and unzip the data to a local subfolder in the work directory.  
Next we first merge all files related to the test subset of subjects and separately all files related to train subset of subject. As data is loaded in R the column names, V1, V2, etc, are replaced with variable names. The measurements in the files "X_test.txt" and"X_train.txt" adopt variable names from the second column of the text file "features.txt". Corresponding test and train data sets are given the same names of key variables (subject, activityID) that will be later needed to merge the test and train data. Finally we vertically rbind the train and test data sets. This completes the requirements for Step 1, and partially addresses the requirements for Step 4. The final data set at the completion of this step is named "alldata".


### Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

In this step we use grep function to select only variables that contain in the name either "subject" or "activity" or "mean" or "std". The analyst has selected to include in this subset variables that measure "meanFreq()" as these represent the weighted mean for the frequency variables. A separate line of code is also provided (commented out) to exclude the "meanFreq()" from this subset. This completes the requirements to Step 2. The final data set after this step is completed is named "datameanstd".

### Step 3: Uses descriptive activity names to name the activities in the data set. 

In this step we use the activity.labels from the dataset "activity_labels.txt" to replace the activity codes in the "datameanstd" data set from the first step. The procedure is to first merge the two data sets by the key variable "activityID creating a new variable named "activity" that houses the activity lables. Then we drop "activityID" from the new data set, and finally rearrange the variables in the resulting data set so that "subject" is the first variable, "actvity" is the second variable, and these two variables are followed by all measures. 

A choice was made in this step to note keep the activityID codes in the data set as this variable is redundant, not bringing any new information to the data set. In addition, a factor with clearly specified levels, that have a good descriptive power, is preferred in data analysis than a factor variable that houses numeric codes for the levels of the factor. This completes Step 3. The final data set after this step is completed is also named "datameanstd".

### Step 4: Appropriately labels the data set with descriptive variable names 

Part of what is required in Step 4 is accomplished in Step 1, where the measurements column names V1, V2, etc, have been replaced with the variables names stored in the "features.txt" dataset. Following the instructions in the lectures to Course 3 of the Data Science specialization, we also remove any dots from the variable names, and force all capital letters to be lowercase. The resulting variable names have the following format:

"subject"                      "activity"                     "tbodyaccmeanx"                "tbodyaccmeany"          "tbodyaccmeanz"                "tbodyaccstdx"                 "tbodyaccstdy"                 "tbodyaccstdz"                
 "tgravityaccmeanx"             "tgravityaccmeany"             "tgravityaccmeanz"             "tgravityaccstdx"             
"tgravityaccstdy"              "tgravityaccstdz"              "tbodyaccjerkmeanx"            "tbodyaccjerkmeany" (total of 81 variables, not all names are displayed here)

No further manipulation is done to the variables names. We believe that at this format the variable names are providing a good balance between readability and conciseness. Any further enhancement to the variables' names would require these names to become much longer and difficult to work with in any subsequent analysis. The code book provides all information needed to understand the labels behind these variable names. We provide a glossary of abbreviations, as well as a detailed description of each variable. For example the variable name tbodyaccmeanx is the average of the time (t) observations on the mean (mean) body acceleration (bodyacc) in the X direction (x). We did not add "ave" to the name of each measure as the whole data set is a set of average measures, and adding this extra letters to the variable names only makes them longer and less manageable. We believe that, given the codebook provides much detail on the abbreviations used and the label of each variable name, the names selected for the variables in this data set are descriptive enough. 

Please note the glossary and the example of one of the variables described in the code book:

GLOSSARY OF ABBREVIATIONS

* t - time
* f - frequency
* Acc - acceleration
* Gyro - gyroscope
* BodyAcc - body acceleration signal
* GravityAcc - gravity acceleration signal
* BodyGyro - body angular velocity signal
* BodyAccJerk - body acceleration jerk signal
* BodyGyroJerk - body angular velocity jerk signal
* XYZ - denoteS 3-axial signals in the X, Y and Z directions
* mag - ???

Example of the description of one variable in the code book:

tbodyaccmeanx	 3  
	Average of the time observations on the mean of body acceleration in the X direction  
		Continuous, normalized and bounded within [-1,1]  
		Min.   1st Qu.  Median    Mean 3rd Qu.    Max.  
		0.2216  0.2712  0.2770  0.2743  0.2800  0.3015

Given that we provide a very detailed codebook we do not believe that the names of the variables should be made even more descriptive as this will sacrifice conciseness of the variable names. All conventions for variable name format are addressed in the resulting data set. With this we believe that Step 4 is completed.  The final data set after this step is completed is also named "datameanstd".


### Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. Export the data to a txt file.       

This step of the script calculates the required average and provides the "tidy" dataset.                                                           

At the onset note that the wording of the question leads to two ambiguities in what seems to be required. First, it is not clear whether the variables that have to be averaged are the mean and std of each measurement, or the mean and std when all measurements are collapsed. We believe that the latter approach makes no sense, as it is meaningless to calculate an average across different signals, this resulting information can not be meaningfully used. As a result we make a choice that the measurements (signal-variables) are not collapsed for the purposes of taking this mean. 

This however, leads to the second ambiguity. Is a narrow or wide form of the "tidy" data set considered "tidy"?  According to Hadley Wickam's "Tidy Data" article (https://github.com/hadley/tidy-data) and the lectures to Course 3 of the Data Science sequence, tidy data is considered a dataset such that 

1. Each variable forms a column.2. Each observation forms a row.3. Each type of observational unit forms a table.

Often, and as is the case in this dataset, we may not be certain whether a variable is actually a variable or an observation, and vice versa. In the current data set. It is not clear whether the different signals should be considered observations that have two values for most subject-activity combinations, namely a mean a std and a meanFreq, for a total of 6 variables in the tidy dataset. OR, each signal should have two independent variables as is in the original "X_test.txt" and "X_train.txt" data sets., resulting in a total of 79 measurements and 81 variables for the tidy dataset. A paragraph in Wickham's paper attempts to address such ambiguities, however, not completely:

> A general rule of thumb is that it is> easier to describe functional relationships between variables (e.g., z is a linear combination> of x and y, density is the ratio of weight to volume) than between rows, and it is easier> to make comparisons between groups of observations (e.g., average of group a vs. average of> group b) than between groups of columns.

The problem is that for this dataset the signal can be both part of the observations for each subject-activity pair, and part of the variables. It would clearly be easier to group data when the signal is located in its own column, and the data takes the "narrow" form. We can then further separate time vs frequency in their own factor column, Or we can separate the axis of movement, X,Y,Z into their own facTor column. However, in this case it would be more difficult to study functional relationships in the data set. What would be the meaning of modeling the "mean" variable with any of the other 5 variables in the narrow data set? In contrast, based on our understanding of the data, it seems much more obvious how functional relationships can be formed between variables using the "wide" form of the tidy data set. For example The mean of one signal, can be a function of the mean of another signal, and the fixed effects formed by the subject in a panel data setting. In addition, tidying the data into a narrow form will lead to many NAs in some of the newly formed variables. This clearly is a move away from tidy data as indicated by David Hood in his blog "thoughtfulblock" (https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/).

Thus, we believe that the choice between the narrow vs the wide form of the tidy data depends on the purpose of the data set; what question are we trying to answer with the data. Assuming that the purpose of the dataset is to study functional relationships, our choice is to keep the wide form of the tidy data set, where each signal has two or three measures - a mean, an std, and a meanFreq - and these measures are each averaged over the 180 groups of subject-activity. Thus, once the average is calculated for all these 180 groups, the tidy data set has 180 rows and 81 columns.

We believe this is a tidy data set as:

1. Each variable forms a column, and no column should be an observation. Only one column per variable is used. 
2. Each observation forms a row. For each group of subject-activity, each observation, we have values for the average of each measurement. The observations can not be variables. 
3. We only have one observational unit, and we need only one table to store all the information. There is no other information that relates to either a subject, or an activity, that is provided in the dataset in addition to the measurements based on signals of human activity. Thus no second or third table is possible or needed.
4. The data is well categorized, and has descriptive headings to make it easier to understand what data is stored in each variable.

We believe this completes the requirements of Step 5. The resulting tidy dataset is named "tidydata.txt" and is exported via the write.table() function. The data can be read back into R with a simple "read.table("path to .txt", header=TRUE)".
 

## Appendix: Description of the source dataset                                                                            
                                                                            
Human Activity Recognition Using Smartphones Dataset
Version 1.0

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit? degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

A full description of the experiment is provided at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The Human Activity Recognition Using Smartphones Dataset is located at
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
