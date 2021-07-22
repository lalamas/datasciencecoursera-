# Author: Alberto Lamas
# Load library
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

# definition  driver graphics copy file png, with dimension size 504
# because have more one graph and copy a file 
png("plot4.png", width=504, height=504)

# definition matriz graphics 2 x 2, for include 4 plots  
par(mfrow=c(2,2))

# Plot 1
plot(powerT[, dateTime], 
     powerT[, Global_active_power], 
     type="l", 
     xlab="", 
     ylab="Global Active Power")

# Plot 2
plot(powerT[, dateTime],
     powerT[, Voltage], 
     type="l", 
     xlab="datetime", 
     ylab="Voltage")

# Plot 3
plot(powerT[, dateTime], 
     powerT[, Sub_metering_1], 
     type="l", 
     xlab="", 
     ylab="Energy sub metering")
# add lines
lines(powerT[, dateTime],
      powerT[, Sub_metering_2], 
      col="red")
# add lines
lines(powerT[, dateTime], 
      powerT[, Sub_metering_3],
      col="blue")
# add legend
legend("topright", col=c("black","red","blue")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       , lty=c(1,1)
       , bty="n"
       , cex=.5) 

# Plot 4
plot(powerT[, dateTime], 
     powerT[,Global_reactive_power], 
     type="l", 
     xlab="datetime", 
     ylab="Global_reactive_power")
# clean driver graphics
dev.off()
