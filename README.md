Project_CleaningData
====================

Completed as a Part of Getting and Cleaning Data Courses on coursera.org

### Introduction:
The project contains 3 files<br/>
1. README.md<br/>
2. run_analysis.R<br/>
3. codeBook.txt<br/>

#### A. README.md
Contains the details about this project. <br/>

#### B. codeBook.txt
Contains the information about all the variables and summaries calculated, along with units, and any other relevant information. <br/>

#### C. run_analysis.R
The purpose of this script is to do the following tasks:- 

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Explaination of run_analysis.R

##### Reading the Files

Reading features.txt file and taking its transform so that the column names appear in a row<br/>

```{r}
library(data.table)
features<-read.table("UCI HAR Dataset/features.txt")
featues <- t(features)
dim(features)
```

<br/>Reading Training Features Matrix and Training Activity Label File<br/>
```{r}
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
dim(x_train)
dim(y_train)
```

<br/>Reading Testing Features Matrix and Testing Activity Label File<br/>
```{r}
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
dim(x_test)
dim(y_test)
```

<br/>Reading Training and Testing Subjects File<br/>
```{r}
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
dim(subject_train)
dim(subject_test)
```

##### Merging and Naming Variables to form the data set

Merging Train and Test Features into the matrix variable x<br/>
```{r}
x <- rbind(x_train,x_test)
```

<br/>Removing unnecessary characters from the features names to create descriptive names<br/>
```{r}
fenames <- as.character(features[,2])
fenames<-chartr("()", "___", fenames)
fenames<-gsub("_", "", fenames)
```

<br/>Naming the variables of the training features using the names from features file<br/>
```{r}
names(x) <- as.character(fenames)
names(x)[1:10]
```

<br/>Merging Train and Test Labels into a single column vector y and naming the variable as "activity"<br/>
```{r}
y <- rbind(y_train,y_test)
names(y) <- c("activity")
```

<br/>Merging Train and Test Subjects into a single column vector subject and naming the variable as "subject"<br/>
```{r}
subject <- rbind(subject_train,subject_test)
names(subject)<-c("subject")
```

<br/>Merging the subjects and activity labels to the complete features data matrix x to form data_all <br/>
```{r}
data_temp2 <- cbind(x,subject)
data_all <- cbind(data_temp2,y)
```

<br/>Replacing the activity numbers by their respective names <br/>
```{r}
data_all$activity <- factor(data_all$activity, labels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
head(data_all[,1:10])
```

##### Selecting Mean and Std Variables for the part 4

Creating a string vector containg the means and standard deviation of the variables which are to selected for part4.<br/>
```{r}
select_Var_Names <- fenames[grep("mean|std|activity", fenames)] 
select_Var_Names <- c(select_Var_Names,"subject","activity")
```

<br/>Selecting the relevant mean and std variables from the complete data<br/>
```{r}
data_part4 <- data_all[select_Var_Names]
head(data_part4[,1:9])
dim(data_part4)
```


##### Converting to tidy_data and writing to file
<br/>Converting the data in part4 to table format and then converting it into tidy data<br/>
<br/>Tidy data set has the average of each variable for each activity and each subject.<br/>
```{r}
data_part4 <- data.table(data_part4)
tidy_data <- data_part4[,lapply(.SD,mean),by=c("activity","subject")]

## Converting subjects to factor variable
tidy_data$subject <- factor(tidy_data$subject)

names(tidy_data)[1:15]
dim(tidy_data)
```

<br/> Writing the tidy data to the file
```{r}
write.table(tidy_data,"tidy_data.txt",row.name=FALSE)
```
