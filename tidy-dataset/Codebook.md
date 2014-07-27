# Getting and Cleaning Data - Course Project

Following, the process of transforming the raw data (Samsung data)
that can be obtained [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The origin of the raw data and a full description can be obtained
[here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The program assumes the Samsung data exists in a subdirectory called 'data'.
The code could have written more defensively in the sense of informing the
user about a possible unsatisfied condition regarding the location of the 
data files. Due to time constrains that was not possible.

The steps taken by the script can be divided in two groups:

1. Reading data
2. Transforming data

## Reading data
1. Extracts feature labels
