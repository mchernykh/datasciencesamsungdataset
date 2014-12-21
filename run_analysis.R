# merge test and train datasets into full dataset, makes two tidy datasets
data_directory <- "UCI HAR Dataset"
full_data_directory_name <- "full"


# checking existence of folder with data
stopifnot(file.exists(data_directory))
setwd(data_directory)


# (1) merging test and train datasets
all_files <- list.files(recursive = TRUE)
test_files <- all_files[grepl("_test.txt", all_files, fixed = TRUE)]
train_files <- gsub("test", "train", test_files, fixed = TRUE)
full_files <- gsub("test", "full", test_files, fixed = TRUE)

if (!file.exists(full_data_directory_name))
{
	dir.create(full_data_directory_name)
	dir.create(file.path(full_data_directory_name, "Inertial Signals"))
}

merge_text_datafiles <- function(x_filename, y_filename, output_filename)
{
	# reading data as raw text split by lines, no '*' in data
	xtable <- read.table(x_filename, colClasses = "character", sep = '*')
	ytable <- read.table(y_filename, colClasses = "character", sep = '*')
	merged <- rbind(xtable, ytable, deparse.level = 0)
	write.table(merged, output_filename, col.names = FALSE, quote = FALSE, row.names = FALSE) 
}

invisible(mapply(merge_text_datafiles, test_files, train_files, full_files))


# (2, 4) extracting mean and std measures instead of all 561 features
feature_filename <- "features.txt"
con <- file(feature_filename, "r")
feature_lines <- readLines(con, skipNul = TRUE)
close(con)

feature_names <- sapply(strsplit(feature_lines, " ", fixed = TRUE), function(x) x[2])
meanstd_features <- grepl("-mean()", feature_lines, fixed = TRUE) | grepl("-std()", feature_lines, fixed = TRUE) # ignoring meanFreq features

feature_file_full <- file.path(full_data_directory_name, "X_full.txt")
features <- read.table(feature_file_full) 
names(features) <- feature_names
extracted_features <- features[,meanstd_features]


# (3) using descriptive activity names
activityLabels <- read.table("activity_labels.txt", colClasses = "character")[[2]]

activity_file_full <- file.path(full_data_directory_name, "y_full.txt")
activities <- read.table(activity_file_full)
activities[,1] <- factor(activities[,1], labels = activityLabels)
names(activities) <- "activity"


# merging (2,3,4) in one tidy dataset and adding subject index
subject_file_full <- file.path(full_data_directory_name, "subject_full.txt")
subject <- read.table(subject_file_full, colClasses = "factor")
names(subject) <- "subject"

tidy_dataset <- cbind(subject, activities, extracted_features)

output_filename_tidy_first = file.path(full_data_directory_name, "overall_full.txt")
write.table(tidy_dataset, output_filename_tidy_first, col.names = TRUE, quote = FALSE, row.names = FALSE) 


# (5) creating dataset with average variable value for each (activity, subject) pair
library(data.table)
dt <- data.table(tidy_dataset)
dt_grouped <- dt[, lapply(.SD, mean), by = "subject,activity"]
setnames(dt_grouped, names(dt_grouped)[c(-1,-2)], paste("avg-",names(dt_grouped)[c(-1,-2)], sep = ""))

output_filename_tidy_second = file.path(full_data_directory_name, "overall_grouped_full.txt")
write.table(dt_grouped, output_filename_tidy_second, col.names = TRUE, quote = FALSE, row.names = FALSE) 

detach(package:data.table)






