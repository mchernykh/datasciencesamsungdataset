###How To
1. Place "UCI HAR Dataset" dataset folder into folder with run_analysis.R script.
2. Install data.table package
3. run script run_analysis.R

### Results
- run_analysis.R script analyses "UCI HAR Dataset" folder with data
- "UCI HAR Dataset\full" folder contaions data for merged test+train set of observations
- "UCI HAR Dataset\full\overall_full.txt" contains subject, activity and 66 features (mean / std)
- "UCI HAR Dataset\full\overall_grouped_full.txt" contains subject, activity and mean values for each of 66 features for each pair of (subject, activity)

### run_analysis.R
"UCI HAR Dataset" folder must be in the folder with this script.
script requires data.table package for creating "UCI HAR Dataset\full\overall_grouped_full.txt" dataset

1. script searches for "*_test.txt" files in data folder and merges them with corresponding "*_train.txt" files line by line storing into "full" folder/
2. script seeks for features named like "*-mean()*" and "*-std()*" and extract all values of these features. "*meanFreq*" features are not included in resulting datasets.
3. script extracts character activity names
4. script merges subject, activity name and 66 features into one dataset "UCI HAR Dataset\full\overall_full.txt"
5. script summarise dataset from step 4 calculating mean for each features grouped by (subject, activity) pair and stores result into "UCI HAR Dataset\full\overall_grouped_full.txt"
