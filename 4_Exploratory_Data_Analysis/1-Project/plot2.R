# Author: Alberto Lamas
#Load library
library("data.table")

# select Work Directory
setwd("./4_Exploratory_Data_Analysis/1.- Project")

#Reads in data from file 
powerT <- data.table::fread(input = "./data/household_power_consumption.txt",
                             na.strings="?")
# Visualization Table 
head(powerT)

# Visualization Stadistics Table
# out: Min Date - 2007-02-01
#      Max Data - 2007-02-02
summary(powerT)


# Prevents Scientific Notation
powerT[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Making a POSIXct date 
powerT[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter Dates for 2007-02-01 and 2007-02-03
powerT <- powerT[(dateTime >= "2007-02-01") 
                   & (dateTime < "2007-02-03")]

## Plot2  -
plot(x = powerT[, dateTime], 
     y = powerT[, Global_active_power], 
     type="l", 
     xlab="",  # No definition label X
     ylab="Global Active Power (kilowatts)") # definition label y

# definition  driver graphics copy file png, with dimension size 504
dev.copy(png,file = "plot2.png", width=504, height=504)

# clean driver graphics
dev.off()