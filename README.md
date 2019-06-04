# Get_clean_data
Assignment for Getting and Cleaning data


The script 'run_analysis.R' downloads the activity datasets as a zip file and then unzips it and stores it in the location specified within the 'unzip' command.

A function df_clean is created to clean and merge the data in each of the 'train' and 'test' sets. 

The function reads in the X_train.txt data (or the X_test.txt data) as a data frame and renames the 561 columns according to the labels listed in the 'features.txt' dataset, which is a vector of length 561. This ensures that the column (variable) names are descriptive, as required for tidy data.  

The function then reads in the activity labels (y_train.txt or y_test.txt), and cbinds these to the dataset. The activity labels, from 1-6 indicate the type of activity being recorded. The training labels set has the same number of rows, and corresponds to, the dataset. The training label column name is left as V1 (this is addressed later).

The function then reads in the subject data set (sunject_train or subject_test) and cbinds these to the dataset. the subject dataset has values 1-30 corresonding with the person/subject being studied. The column is named "Subject", thereby providing a descriptive name as required by tidy data.

Then, the function reads in the activity descriptions (activiy_labels.txt) and performs a merge of the activity labels and the datset, using the "V1" column as the common id, to add the activity descriptions ("walking", "laying", etc.) into the dataset. The column containing the activtiy description is renamed as "Activtiy" and the "V1" column containing the activity labels (1-6) is removed. the data is therefore descriptive.

Finally, a column is added, using the 'mutate' function to indicate whether the record has come from the 'train' set or the 'test' set. The column containing this data is given the descriptive name "group". The 'test' and 'train' datasets are created by calling the df_clean function, and passing either "test" or "train" as an argument. The test and train data sets are then combined using a row bind and the resulting dataset is stored in the variable 'dset'. This data set contains each observation on each row, with descriptive (subject, activity, and group) and numeric variables (the 561 'features') describing the data and the observations.

The dset data is then refined by extracting from the 561 'feature' variables only those which describe a mean or standard deviation. This is done using the grepl function to subset from dset, based on regular expressions to identify all column labels containing "mean, "Mean", or "std". 

Finally, a 'group_by' operation is used to group the data set by the decriptive variables(subject, activity, and group) and then the 'summarise' function is used to calcuate the mean of all the extracted 'feature' variables. These are read into the variable 'sumdat' which is then written as a table file named 'Activity_data.txt', (the file can be read back in to R using the command read.table, passing the filename as an argument).

The code book "Activity_data_codebook.pdf" describes the "Activity_data.txt" data set.