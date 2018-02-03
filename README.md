# Data-Cleaning-Project---Human-Activity-Recognition-Using-Smartphones-
Data Cleaning Project - Human Activity Recognition Using Smartphones

1- Read activity names from activity_labels.txt
2-Read feature names from features.txt, it has some repeated variable names
3-create new unique feature names by combining feature Row number + original feature name
e.g. ClNames <- as.character(ClNamesRep$V1) %stri+% as.character(ClNamesRep$V2)

4-Add another two names vector for activity and subject column
e.g. ClNames <- c(ClNames , "Activity" , "Subject")

5- Getting Tarin Data and modify it, getting Test Data and modify it, combine both Tarin Data and Test Data

6- Modification Details of Train set
6-1 Read Train subject from subject_train.txt
6-2 Read Train activity from y_train.txt
6-3 join activity ID with activity name, to use the name as descriptive lable 
e.g TrainActNames <- merge(x = TrainActDF, y = ActName, by = "V1", all.x = TRUE)
6-4 read the observation set from X_train.txt
6-5 add activity names and subject ID
e.g. TrainDF <- mutate(TrainDF, Activity = TrainActNames$V2)
e.g  TrainDF <- mutate(TrainDF, Subject = TrainSubDF$V1)

7-Modification Details of Test set exactly as Train set (refer to 6) 
8-Merges the training and the test sets to create one data set.
9- name the total using column names prepared before (in 3)
10-exctract only columns have mean and sum + activity and subject columns 
e.g. AllPraDF <-  select(AllDF , grep("[Mm]ean|std|Activity|Subject",ClNames))
11- remove number of IDs used which before to avoide column name duplications
12- make sure no column repeated of the traget set of variables (mean + sum)
 e.g. if(!length(ClNames2) == length(unique(ClNames2)) ) print("there are Column duplications")
13- creat the final set by Summarize over activit and subject combinations and calculating means of other variables
e.g. FinaltidyDF <- (AllPraDF %>% group_by(Activity,Subject) %>% summarise_all(funs(mean)))
14- add prefex of "average of:" to the claculated variables. 
15 write the required file for the tidy data
e.gwrite.table(FinaltidyDF,"FinaltidyDF.txt", row.names = FALSE)




