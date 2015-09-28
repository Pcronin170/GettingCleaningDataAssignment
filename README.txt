This readme file contains the explanation for how the data analysis was done for the Coursera Getting and Cleaning data project.

Step 0 - All the files were loaded and merged into a single file.  This requried combining the training and testing data sets

Step 1 - The Training and testing data sets were merged.  It was unnecessary to merge them on an Id because training/testing data is split already

Step 2 - A regular expression was used to extract only the measurements with means and standard devaitions. They were indicated by mean() and std()

Step 3 - Nice labels were given to the variables

Step 4 - A tidy data set was created with the mean and standard devaition of the variables.  This was essentially a mean of means and a standard devaition of standard deviations.

Step 5 - The activity names were replaced with the actual values instead of the factor form.  This is to make it easier for people to understand the variables.

