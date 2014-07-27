library(plyr)

# Set working directory
# Remove when committing to repo
#setwd("")


# Feature labels
featureLabels <- read.table("data/features.txt", 
                            col.names = c("Column", "Feature Name"),
                            stringsAsFactors = FALSE)


# Training and Test subject numbers
# Each row specifies an observation made by a particular
# subject enumerated in an ID number (from 1 - 30)
subjectTrainNumbers <- read.table("data/train/subject_train.txt", 
                                  col.names = c("Subject"),
                                  stringsAsFactors = FALSE)

subjectTestNumbers <- read.table("data/test/subject_test.txt", 
                                 col.names = c("Subject"))


## Extract activity IDs per observation
# With subjectTrainNumbers and subjectTestNumbers, for
# each subject, they performed a particular action enumerated
# between 1 - 6.  Each number should be replaced with
# the particular action they are performing
# Consult activityLabels for this lookup
subjectTrainActivity <- read.table("data/train/y_train.txt",
                                   col.names = "Activity")


subjectTestActivity <- read.table("data/test/y_test.txt",
                                  col.names = "Activity")


# Extract the observations per subject per activity
# With subjectTrainActivity and subjectTestActivity,
# for each kind of action the particular subject is doing,
# these are the observation vectors that result
subjectTrainFeatures <- read.table("data/train/X_train.txt",
                                   row.names = NULL, stringsAsFactors = FALSE)
names(subjectTrainFeatures) <- featureLabels[,2]

subjectTestFeatures <- read.table("data/test/X_test.txt",
                                  row.names = NULL, stringsAsFactors = FALSE)
names(subjectTestFeatures) <- featureLabels[,2]

# 
frameTraining <- cbind(subjectTrainNumbers, subjectTrainActivity, subjectTrainFeatures)
frameTest <- cbind(subjectTestNumbers, subjectTestActivity, subjectTestFeatures)


# Now extract the columns that have mean() and std() only
# This completes Step #2 - mean() columns first followed by std()
# Note: We offset the meanStdVarNames vector by 3 as we are placing
# 3 new columns before the features themselves
#frameTrainingTidy <- frameTraining[,(names(frameTraining) %in% meanStdFeatureVars)]
#frameTestTidy <- frameTest[,(names(frameTest) %in% meanStdFeatureVars)]


# 1. Merges the training and the test sets to create one data set.
tidyDSet <- rbind(frameTraining, frameTest)



# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# This call is key in selecting the variable names that will be filtered out from
# the data
meanStdFeatureVars <- grep("(mean|std)", names(tidyDSet), value = TRUE)
tidyVars <- c("Subject","Activity",meanStdFeatureVars)

tidyDSet <- tidyDSet[,(names(tidyDSet) %in% tidyVars)]

# Then sort based on subject number
# tidyDSet contains the processing steps from 1 - 4
#tidyDSet <- tidyDSet[order(tidyDSet$Subject),]

# 5. Creates a second, independent tidy data set with the average of each variable
# for each activity and each subject. 
tidyDSet <- ddply(tidyDSet, .(Subject, Activity), colMeans)

activityLabels <- read.table("data/activity_labels.txt", 
                             col.names = c("Activity_ID", "Activity"),
                             stringsAsFactors = FALSE)

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
tidyDSet$Activity <- sapply(
  tidyDSet$Activity,
  function(x)activityLabels[(activityLabels$Activity_ID==x),2]
)

tidyDSetNames <- sub("\\.$","",
                       sub("^t","Time.",
                           sub("^f","FFT.",
                               gsub("\\W+",".",tidyVars, perl = TRUE)
                               )
                           )
                       )

#tidyDSetNames <- c("Subject", "Activity", tidyDSetNames)

names(tidyDSet) <- tidyDSetNames

write.table(tidyDSet, file="tidyDataset_Coursera-GettingAndCleaningData.txt", row.names = FALSE)

