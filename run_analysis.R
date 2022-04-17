library(dplyr)

features <- read.table("./UCI HAR Dataset/features.txt")[,2];
train_df1 <- read.table("./UCI HAR Dataset/train/X_train.txt",col.names = features);
train_df2 <- read.table("./UCI HAR Dataset/train/y_train.txt",col.names = c("Activity"));
train_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = c("Subject"));
train_df3 <- cbind(train_sub,train_df2,train_df1);
train_df3 <- train_df3 %>% select(Subject,Activity,contains("std"), contains("mean"));
test_df1 <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names = features);
test_df2 <- read.table("./UCI HAR Dataset/test/y_test.txt",col.names = c("Activity"));
test_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt",col.names = c("Subject"));
test_df3 <- cbind(test_sub,test_df2,test_df1);
test_df3 <- test_df3 %>% select(Subject,Activity,contains("mean"), contains("std"));
final_df <- rbind(train_df3,test_df3);
final_df <- arrange(final_df,Subject, Activity);
final_df$Subject <- as.factor(final_df$Subject);
final_df$Activity <- as.factor(final_df$Activity);
levels(final_df$Activity) <- c("WALKING","WALKING UPSTAIRS","WALKING DOWNSTAIRS","SITTING","STANDING","LAYING");
names(final_df) <- gsub("^t","Time",names(final_df));
names(final_df) <- gsub("^f","Frequency",names(final_df));
names(final_df) <- gsub("Acc","Accelerometer",names(final_df));
names(final_df) <- gsub("Gyro","Gyroscope",names(final_df));
names(final_df) <- gsub("Mag","Magnitude",names(final_df));
names(final_df) <- gsub("BodyBody","Body",names(final_df));
names(final_df) <- gsub("tBody","TimeBody",names(final_df));
names(final_df) <- gsub("angle","Angle",names(final_df));
names(final_df) <- gsub("gravity","Gravity",names(final_df));
names(final_df) <- gsub("-mean()",".Mean",names(final_df));
names(final_df) <- gsub("-std()",".STD",names(final_df));
names(final_df) <- gsub("-freq()",".Frequency",names(final_df));
summarized_df <- final_df %>% group_by(Subject,Activity) %>% summarise(across(everything(), mean))

write.table(summarized_df, "tidydata.csv")
