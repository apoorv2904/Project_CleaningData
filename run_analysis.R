
library(data.table)

## Reading features.txt file and taking its transform so that the column names appear in a row

features<-read.table("UCI HAR Dataset/features.txt")
featues <- t(features)
dim(features)

## Reading Training Features Matrix and Training Activity Label File

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
dim(x_train)
dim(y_train)


## Reading Testing Features Matrix and Testing Activity Label File

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
dim(x_test)
dim(y_test)


## Reading Training and Testing Subjects File

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
dim(subject_train)
dim(subject_test)


## Merging Train and Test Features into the matrix variable x

x <- rbind(x_train,x_test)

## Removing unnecessary characters from the features names to create descriptive names
fenames <- as.character(features[,2])
fenames<-chartr("()", "___", fenames)
fenames<-gsub("_", "", fenames)

## Naming the variables of the training features using the names from features file

names(x) <- as.character(fenames)
names(x)[1:10]

## Merging Train and Test Labels into a single column vector y and naming the variable as "activity"

y <- rbind(y_train,y_test)
names(y) <- c("activity")


## Merging Train and Test Subjects into a single column vector subject and naming the variable as "subject"
subject <- rbind(subject_train,subject_test)
names(subject)<-c("subject")


## Merging the subjects and activity labels to the complete features data matrix x to form data_all 

data_temp2 <- cbind(x,subject)
data_all <- cbind(data_temp2,y)


## Replacing the activity numbers by their respective names

data_all$activity <- factor(data_all$activity, labels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
head(data_all[,1:10])


## Creating a string vector containg the means and standard deviation of the variables which are to selected for part4.

select_Var_Names <- fenames[grep("mean|std|activity", fenames)] 
select_Var_Names <- c(select_Var_Names,"subject","activity")


## Selecting the relevant mean and std variables from the complete data
data_part4 <- data_all[select_Var_Names]
head(data_part4[,1:9])
dim(data_part4)


## Converting the data_part4 to table format and then converting it into tidy_data 
## Tidy data set has the average of each variable for each activity and each subject.

data_part4 <- data.table(data_part4)
tidy_data <- data_part4[,lapply(.SD,mean),by=c("activity","subject")]

## Converting subjects to factor variable

tidy_data$subject <- factor(tidy_data$subject)

names(tidy_data)[1:15]
dim(tidy_data)

##  Writing the tidy data to the file
write.table(tidy_data,"tidy_data.txt",row.name=FALSE)

