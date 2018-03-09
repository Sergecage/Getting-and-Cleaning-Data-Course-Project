library(data.table)
library(dplyr)
setwd("C:/Users/Клеопатра/Documents/UCI HAR Dataset")
library(reshape2)
##load activity labels and data column names
activity_labels <- read.table("C:/Users/Клеопатра/Documents/UCI HAR Dataset/activity_labels.txt")[,2]

features <- read.table("C:/Users/Клеопатра/Documents/UCI HAR Dataset/features.txt")[,2]

extract_features <- grepl("mean|std", features)

X_test <- read.table("C:/Users/Клеопатра/Documents/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/Клеопатра/Documents/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/Клеопатра/Documents/UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_features]


y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data below
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Load and process X_train & y_train data.
X_train <- read.table("C:/Users/Клеопатра/Documents/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/Клеопатра/Documents/UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("C:/Users/Клеопатра/Documents/UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extract only the measurements 
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
write.table(tidy_data, file = "./tidy_data.txt")
