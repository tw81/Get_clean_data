## Prepare tidy data to use for later analysis this script does the following:
## Download data sets
## Combine feature lables, subject, and activity labels into the data set, for train and test data
## Combine train and test data
## Extract all data with mean or standard deviation values
## Create a tidy data set which summarises the means of all variables by object and activity


library(dplyr)

## First, download and unzip the data
destfile = "./data/dataset.zip"
fileURL <-fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(destfile)) {
    if(!file.exists(dirname(destfile))){dir.create(dirname(destfile))}
    download.file(fileURL,destfile=destfile)
    unzip(destfile,exdir = dirname(destfile))
}


##  Clean then merge training and test sets
df_clean <- function(gtype) {  # since the process is identical for the training and test set, use a function
    
    ## add feature names to the dataset column
    fea <- read.table("./data/UCI HAR Dataset/features.txt")
    gset <- read.table(paste0("./data/UCI HAR Dataset/", gtype, "/x_", gtype, ".txt"))
    names(gset) <- fea[,2]
    
    ## add the training labels to the sets
    glab <- read.table(paste0("./data/UCI HAR Dataset/", gtype, "/y_",gtype, ".txt"))
    gset <- cbind(glab, gset)
    
    ## add the subject label
    gsub <- read.table(paste0("./data/UCI HAR Dataset/",gtype,"/subject_",gtype,".txt"))
    gset <- cbind(gsub,gset)
    names(gset)[1] <- "Subject"
    
    ## replace the training label numbers with their respective text. NB. this uses"merge" which will reorder the data. DON'T CBIND after this point
    alabs <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
    gset <- merge(alabs,gset,by.x = "V1", by.y = "V1") %>% select(-V1) ## the select command removes the label numbers
    names(gset)[1] <- "Activity"
    
    ## add a variable (called "group") to identify training or test set, then combine
    gset <- mutate(gset, group = gtype) %>% select(group, everything())  ## the select comand moves the 'group' column to the front.

}
trset <- df_clean("train")
teset <- df_clean("test")
dset <- rbind(trset,teset) # final combined dataset

## Extract only the measurements on the mean and standard deviation for each measurement
## i.e. any column names that include "mean", "Mean", or "std"
colinds <- grepl("(.*)[Mm]ean(.*)",names(dset))|grepl("(.*)std(.*)",names(dset))
colinds[1:3] <- TRUE # include the labels
dset <- dset[,colinds] # data set with only the mean and std measurements

## Create a second data set with average by group and activity
sumdat <- group_by(dset, Activity, Subject, group) %>% summarise_all(mean)

## Export the data set
write.table(sumdat, file = "Activity_data.txt", row.name = FALSE)

