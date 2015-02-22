setwd("C:/Users/538132/desktop/datascience/data")
library(plyr)
library(reshape2)
library(data.table)
#Load Train Variables
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

#Load Activity labels
activity_labels <- read.table("./activity_labels.txt")[,2]

#Load Column Label
col_labels <- read.table ("./features.txt") [,2]


#extract columns
extract_features <- grepl("mean|std", col_labels)
names(x_test) = col_labels

# Extract the mean and standard deviation for each measurement
x_test = x_test[,extract_features]

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

#bind the dat
test_data <- cbind(as.data.table(subject_test), y_test, x_test)
head(test_data)
summary(test_data)

#repeat for train Data
extract_features <- grepl("mean|std", col_labels)
names(x_train) = col_labels

# Extract the mean and standard deviation for each measurement
x_train = x_train[,extract_features]

# Load activity labels
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

#bind the dat
train_data <- cbind(as.data.table(subject_train), y_train, x_train)
head(train_data)
summary(test_data)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)


write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
