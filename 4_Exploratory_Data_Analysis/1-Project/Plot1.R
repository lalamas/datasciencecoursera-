# Author: Alberto Lamas
##
#Load library
library("data.table")

# select Work Directory
setwd("./4_Exploratory_Data_Analysis/1.- Project")

#Reads in data from file 
powerT <- data.table::fread(input = "./data/household_power_consumption.txt")
# Visualization Table 
head(powerT)

# Visualization Stadistics Table
# out: Min Date - 2007-02-01
#      Max Data - 2007-02-02
summary(powerT)

# Vertification Variable Type "Date" and "Global_active_power"
# out: Date -> Character and Global_active_power -> Numeric
class(powerT$Date)
class(powerT$Global_active_power)

# Change Date Variable Type character --> Date
powerT[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), 
        .SDcols = c("Date")]

# Filter Dates for 2007-02-01 and 2007-02-02
powerT <- powerT[(Date >= "2007-02-01") 
                   & (Date <= "2007-02-02")]

# Prevents printing in scientific notation
powerT[, Global_active_power := lapply(.SD, as.numeric), 
        .SDcols = c("Global_active_power")]

## Plot1  - Histogram Global Active Power
hist(powerT[, Global_active_power], # select  table and variables
     main="Global Active Power",   # definition title
     xlab="Global Active Power (kilowatts)",  # definition label X
     ylab="Frequency",   # definition label Y
     col="Red")          # definition color "red" for histograma

# definition  driver graphics copy file png, with dimension size 504
dev.copy(png,file = "plot1.png", width=504, height=504)

# clean driver graphics
dev.off()
