
# Course Project 1
------------------
---
Title: "Reproducible Research Project 1"
Author: "Alberto Lamas"
Date: "23/07/2021"
---


Introduction
------------
It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the “quantified self” movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

The data for this assignment can be downloaded from the course web site:

-   Dataset: [Activity monitoring data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip)


The variables included in this dataset are:

* steps: Number of steps taking in a 5-minute interval (missing values are coded as 𝙽𝙰) </br> 
* date: The date on which the measurement was taken in YYYY-MM-DD format </br> 
* interval: Identifier for the 5-minute interval in which measurement was taken </br> 

The dataset is stored in a comma-separated-value (CSV) file and there are a total of 17,568 observations in this dataset.

Loading and preprocessing the data
----------------------------------
Show any code that is needed to

1. Load the data (i.e. read.csv())
2. Process/transform the data (if necessary) into a format suitable for your analysis

Unzip data to obtain a csv file.

``` r
# Load library
library("data.table")
library("ggplot2")

# Definir path
path <- getwd()
# Download file
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl, destfile = paste(path, 'activity.zip', sep = "/")) 
# Unzip file in data directory              )
unzip("activity.zip",exdir = "data")

# Load file in data.table
actiDT <- data.table::fread(input = "data/activity.csv")
```

What is mean total number of steps taken per day?
-------------------------------------------------
For this part of the assignment, you can ignore the missing values in the dataset.

    - Calculate the total number of steps taken per day
    - If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day
    - Calculate and report the mean and median of the total number of steps taken per day

1. Calculate the total number of steps taken per day

``` r
# Sum Total Steps by date
Tot_Steps <- actiDT[, c(lapply(.SD, sum, na.rm = FALSE)), 
                    .SDcols = c("steps"), by = .(date)] 

head(Tot_Steps)
```

Nº |date       |steps
---|-----------|-----
1: |2012-10-01 |   NA
2: |2012-10-02 |  126
3: |2012-10-03 |11352
4: |2012-10-04 |12116
5: |2012-10-05 |13294
6: |2012-10-06 |15420


1.  If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day.
