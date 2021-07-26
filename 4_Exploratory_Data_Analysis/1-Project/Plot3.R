# Author: Alberto Lamas
# Load library
library("data.table")
# define path actual
path <- getwd()

# download and unzip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, file.path(path, "./data/ficheros.zip"))
unzip(zipfile = "./data/ficheros.zip")

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
# definition  driver graphics copy file png, with dimension size 504
# because have more one graph and copy a file 
png("plot3.png", width=504, height=504)

# Plot 3
plot(powerT[, dateTime], powerT[, Sub_metering_1], 
     type="l", 
     xlab="",   # Definition label x
     ylab="Energy sub metering") # Definition label y

# add lines
lines(powerT[, dateTime], 
      powerT[, Sub_metering_2],
      col="red") # Definition color "red"
# add lines 
lines(powerT[, dateTime], 
      powerT[, Sub_metering_3],
      col="blue") # Definition color "blue"

# add legend 
legend("topright"
       , col=c("black","red","blue") # Definition colosrs "black, red adn blue"
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ") # Select variables names
       ,lty=c(1,1), lwd=c(1,1))


# clean driver graphics
dev.off()
