setwd('./')
X_train <- read.csv('UCI HAR Dataset/train/X_train.txt', sep='', header=FALSE)
Y_train <- read.csv('UCI HAR Dataset/train/Y_train.txt', sep='', header=FALSE)
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

X_test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
Y_test <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

Data <- rbind(X_train,X_test)

Col  <- grep('.*mean\\().*|.*std\\().*', features[,2])

Data <- Data[,Col]

Data <- cbind(Data,rbind(cbind(Y_train,subject_train),cbind(Y_test,subject_test)))

tmp <- lapply(features[Col,2],as.character)
colnames(Data) <- c(tmp, "Activity", "Subject")

activityLabels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

tidy_data <- aggregate(Data, by=list(Activity = Data$Activity, Subject=Data$Subject), mean)

for (tmp in activityLabels$V1){
        tidy_data$Activity <- gsub(tmp,activityLabels[tmp,2],tidy_data$Activity)
}
index <- dim(tidy_data)[2]
tidy_data[,index-1] <- NULL
tidy_data[,index] <- NULL
write.table(tidy_data,'tidy_data.txt',sep='\t',row.name=FALSE)
