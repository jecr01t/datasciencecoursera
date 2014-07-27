# This program assumes the Samsung data exists in a subdirectory called 'data'
# The code could have written more defensively in the sense of informing the
# user about a possible unsatisfied condition regarding the location of the data files.

library(plyr)

# Set working directory
# Remove when committing to repo
#setwd("")


# Feature labels
featureLabels <- read.table("data/features.txt", 
                            col.names = c("Column", "Feature Name"),
                            stringsAsFactors = FALSE)


# subject numbers
subjectTrainNumbers <- read.table("data/train/subject_train.txt", 
                                  col.names = c("Subject"),
                                  stringsAsFactors = FALSE)

subjectTestNumbers <- read.table("data/test/subject_test.txt", 
                                 col.names = c("Subject"))


subjectTrainActivity <- read.table("data/train/y_train.txt",
                                   col.names = "Activity")


subjectTestActivity <- read.table("data/test/y_test.txt",
                                  col.names = "Activity")


subjectTrainFeatures <- read.table("data/train/X_train.txt",
                                   row.names = NULL, stringsAsFactors = FALSE)
names(subjectTrainFeatures) <- featureLabels[,2]

subjectTestFeatures <- read.table("data/test/X_test.txt",
                                  row.names = NULL, stringsAsFactors = FALSE)
names(subjectTestFeatures) <- featureLabels[,2]

# 
frameTraining <- cbind(subjectTrainNumbers, subjectTrainActivity, subjectTrainFeatures)
frameTest <- cbind(subjectTestNumbers, subjectTestActivity, subjectTestFeatures)

# 1. Merges the training and the test sets to create one data set.
tidyDSet <- rbind(frameTraining, frameTest)



# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# This call is key in selecting the variable names that will be filtered out from
# the data
meanStdFeatureVars <- grep("(mean|std)", names(tidyDSet), value = TRUE)
tidyVars <- c("Subject","Activity",meanStdFeatureVars)

tidyDSet <- tidyDSet[,(names(tidyDSet) %in% tidyVars)]

# 5. Creates a second, independent tidy data set with the average of each variable
# for each activity and each subject. 
tidyDSet <- ddply(tidyDSet, .(Subject, Activity), colMeans)

activityLabels <- read.table("data/activity_labels.txt", 
                             col.names = c("Activity_ID", "Activity"),
                             stringsAsFactors = FALSE)

# 3. Uses descriptive activity names to name the activities in the data set
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

# 4. Appropriately labels the data set with descriptive variable names.
names(tidyDSet) <- tidyDSetNames


write.table(tidyDSet, file="tidyDataset_Coursera-GettingAndCleaningData.txt", row.names = FALSE)

