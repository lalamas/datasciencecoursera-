# Reproducible Research Project 1

- Author: "Alberto Lamas"
- Date: "23/07/2021"


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
    - If you do not understand the difference between a histogram and a barplot, 
      research the difference between them. Make a histogram of the total number of steps taken each day
    - Calculate and report the mean and median of the total number of steps taken per day

1.  Calculate the total number of steps taken per day

``` r
# Sum Total Steps by date
Tot_Steps <- actiDT[, c(lapply(.SD, sum, na.rm = FALSE)), 
                    .SDcols = c("steps"), by = .(date)] 

head(Tot_Steps)
```
Out ->
Nº |date       |steps
---|-----------|-----
1: |2012-10-01 |   NA
2: |2012-10-02 |  126
3: |2012-10-03 |11352
4: |2012-10-04 |12116
5: |2012-10-05 |13294
6: |2012-10-06 |15420

2.  If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day.

![](https://github.com/lalamas/datasciencecoursera-/blob/main/5_Reproducible_Research/1.project/histogram.png)

``` r
# Plot
ggplot(Tot_Steps, aes(x = steps)) +
  theme_light() +
  geom_histogram(fill="steelblue") +
  labs(title = "Histogram - Daily Steps", x = "Steps", y = "Frequency")
```
3.  Calculate and report the mean and median of the total number of steps taken per day.

``` r
# Calculate mean and median steps per day
Tot_Steps[, .(Mean_Steps = mean(steps, na.rm = TRUE), 
              Median_Steps = median(steps, na.rm = TRUE))]
```
Out ->
Mean_Steps| Median_Steps
----------|------------
10766.19  |      10765

What is the average daily activity pattern?
-------------------------------------------

1.- Make a time series plot (i.e.type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis).

![](https://github.com/lalamas/datasciencecoursera-/blob/main/5_Reproducible_Research/1.project/Rplot01.png)

``` r
# Dfinition date.table interval steps
interVal <- actiDT[, c(lapply(.SD, mean, na.rm = TRUE)), 
                   .SDcols = c("steps"), by = .(interval)] 

ggplot(interVal, aes(x = interval , y = steps)) + 
  geom_line(color="steelblue", size=0.4) + 
  geom_point(color="blue", size = 0.01) +
  labs(title = "Average Daily Steps", x = "Interval", y = "Avg.Steps/day") +
  theme(
    plot.title = element_text(color = "blue",size=12,face="bold.italic",hjust = 1),
    axis.title.x = element_text(color="black", size=7, face="bold"),
    axis.title.y = element_text(color="black", size=7, face="bold")
)

```
2.- Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
``` r
# Calculate Max interval activity
interVal[steps == max(steps), .(max_interval = interval)]
```
Out ->
    max_interval
         835

Imputing missing values
-----------------------
Note that there are a number of days/intervals where there are missing values (coded as \color{red}{\verb|NA|}NA). The presence of missing days may introduce bias into some calculations or summaries of the data.
1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
``` r
# Calculate Nº missing values
actiDT[is.na(steps), .N ]
```
Out -> 2304
2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
``` r
# Calculate Nº missing values
actiDT[is.na(steps), .N ]
```
3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
``` r
# Create dataset 
data.table::fwrite(x = actiDT, file = "data/new_activity.csv", quote = FALSE)
```
4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?.

![](https://github.com/lalamas/datasciencecoursera-/blob/main/5_Reproducible_Research/1.project/Rplot2.png)

``` r
# date.table <- Total Steps by date
Tot_Steps <- actiDT[, c(lapply(.SD, sum)), 
                    .SDcols = c("steps"), by = .(date)] 

# Mean/Meaiand of steps/day
Tot_Steps[, .(Mean_Steps = mean(steps), 
                Median_Steps = median(steps))]
# plot 
ggplot(Tot_Steps, aes(x = steps)) + 
  geom_histogram(fill = "steelblue",binwidth=600 ) + 
  labs(title = "Daily Steps", x = "Steps", y = "Frequency")+
  theme(
    plot.title = element_text(color = "blue",size=12,face="bold.italic",hjust = 1),
    axis.title.x = element_text(color="black", size=7, face="bold"),
    axis.title.y = element_text(color="black", size=7, face="bold")
  )
```
Median Tot_Steps
``` r
# Median 
mean(Tot_Steps$steps)
```
Out -> 9354.23

Median Tot_Steps
``` r
# Median 
median(Tot_Steps$steps)
```
Out -> 10395

Are there differences in activity patterns between weekdays and weekends?
-------------------------------------------------------------------------
For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day.

``` r
# Create two variables and filters datas
actiDT[, date := as.POSIXct(date, format = "%Y-%m-%d")]
actiDT[, `day_week`:= weekdays(x = date, abbreviate = TRUE)]
actiDT[grepl(pattern = "Mon|Tue|Wed|Thu|Fri", x = `day_week`), 
            "weekday/weekend"] <- "weekday"
actiDT[grepl(pattern = "Sat|Sun", x = `day_week`), 
            "weekday/weekend"] <- "weekend"
actiDT[, `weekday/weekend` := as.factor(`weekday/weekend`)]

tail(actiDT)
```
Out -> 
Nº |  steps   |    date| interval| day_week| weekday/weekend
---|---------|--------|-------|-------|--------  
1: |   NA |2012-11-30     |2330      |Fri         |weekday
2: |   NA |2012-11-30     |2335      |Fri         |weekday
3: |   NA |2012-11-30     |2340      |Fri         |weekday
4: |   NA |2012-11-30     |2345      |Fri         |weekday
5: |   NA |2012-11-30     |2350      |Fri         |weekday
6: |   NA |2012-11-30     |2355      |Fri         |weekday


2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.

![](https://github.com/lalamas/datasciencecoursera-/blob/main/5_Reproducible_Research/1.project/Rplot3.png)

``` r
# Filter with median steps
actiDT[is.na(steps), "steps"] <- actiDT[, c(lapply(.SD, median, na.rm = TRUE)), 
                                        .SDcols = c("steps")]
# Filter with mean by weebday/weekend
interVal <- actiDT[, c(lapply(.SD, mean, na.rm = TRUE)), 
                   .SDcols = c("steps"), 
                   by = .(interval, `weekday/weekend`)] 
# plot
ggplot(interVal , aes(x=interval , y=steps, color=`weekday/weekend`)) + 
  geom_line() + 
  labs(title="Daily Steps Weekday/Weekend", x="Interval", y="No.Steps") + 
  facet_wrap(~`weekday/weekend`, nrow=2, ncol=1) +
  theme(
    plot.title = element_text(color="blue", size=12, face="bold.italic",hjust = 0.5),
    axis.title.x = element_text(color="black", size=7, face="bold"),
    axis.title.y = element_text(color="black", size=7, face="bold")
  )
```
