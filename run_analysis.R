library(stringi)
library(dplyr)
library(plyr)

## Read activity names 
ActName <- read.table(".//UCI HAR Dataset//activity_labels.txt")

##Read feature names, it has some repeated variable names
ClNamesRep <- read.table(".//UCI HAR Dataset//features.txt")

##create new feature names by combining Row number + original feature name
ClNames <- as.character(ClNamesRep$V1) %stri+% as.character(ClNamesRep$V2)
##add another two names for activity and subject column
ClNames <- c(ClNames , "Activity" , "Subject")


##############Train handling####################
TrainSubDF <- read.table(".//UCI HAR Dataset//train//subject_train.txt")
TrainActDF <- read.table(".//UCI HAR Dataset//train//y_train.txt")

##3.Uses descriptive activity names to name the activities in the data set##
## join activity ID with activity name, to use the name as descriptive lable
TrainActNames <- merge(x = TrainActDF, y = ActName, by = "V1", all.x = TRUE)

##read the observation set
TrainDF <- read.table(".//UCI HAR Dataset//train//X_train.txt")
## add activity names and subject ID
TrainDF <- mutate(TrainDF, Activity = TrainActNames$V2)
TrainDF <- mutate(TrainDF, Subject = TrainSubDF$V1)

#############Test Handling######################
TestSubDF <- read.table(".//UCI HAR Dataset//test//subject_test.txt")
TestActDF <- read.table(".//UCI HAR Dataset//test//y_test.txt")

##3.Uses descriptive activity names to name the activities in the data set##
## join activity ID with activity name, to use the name as descriptive lable
TestActNames <- merge(x = TestActDF, y = ActName, by = "V1", all.x = TRUE)

##read the observation set
TestDF <- read.table(".//UCI HAR Dataset//test//X_test.txt")
## add activity names and subject ID
TestDF <- mutate(TestDF, Activity = TestActNames$V2)
TestDF <- mutate(TestDF, Subject = TestSubDF$V1)

##1.Merges the training and the test sets to create one data set.##
AllDF <- rbind(TrainDF, TestDF)

##3.Uses descriptive activity names to name the activities in the data set##
##4. Appropriately labels the data set with descriptive variable names.
## this by using column names prepared before
colnames(AllDF) <- ClNames

##2.Extracts only the measurements on the mean and standard deviation for each measurement.##
## exctract only columns have mean and sum + activity and subject columns 
AllPraDF <-  select(AllDF , grep("[Mm]ean|std|Activity|Subject",ClNames))


##4.Appropriately labels the data set with descriptive variable names.
##remove number of IDs used before to avoide column name duplications
ClNames2 <- colnames(AllPraDF)
ClNames2 <- gsub("^[0-9]*","", ClNames2)
colnames(AllPraDF) <- ClNames2
##make sure no column repeated of the traget set of variables (mean + sum)
if(!length(ClNames2) == length(unique(ClNames2)) ) print("there are Column duplications")

##5.independent tidy data set with the average of each variable for each activity and each subject.
## by summarize over activit and subject combinations and calculating means of other variables
FinaltidyDF <- (AllPraDF %>% group_by(Activity,Subject) %>% summarise_all(funs(mean)))
ClNames2 <- colnames(FinaltidyDF)

##4.Appropriately labels the data set with descriptive variable names.
## add prefex of average of: because the data are average of variables 
ClNames2 <- c(rep("averag of:", length(ClNames2))) %stri+% ClNames2
ClNames2[1:2] <- c("Activity" , "Subject")
colnames(FinaltidyDF) <- ClNames2

##write the required file for the tidy data
write.table(FinaltidyDF,"FinaltidyDF.txt", row.names = FALSE)



