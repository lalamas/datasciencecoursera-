## Exploratory Data Analysis Project 1

Our overall goal here is simply to examine how household energy usage varies over a 2-day period in February, 2007. Your task is to reconstruct the following plots below, all of which were constructed using the base plotting system.

The four plots that you will need to construct are shown below.
### Plot1
```R
#Load library
library("data.table")

# define path actual
path <- getwd()

# download and unzip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, file.path(path, "./data/ficheros.zip"))
unzip(zipfile = "./data/ficheros.zip")

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
```
![](https://github.com/lalamas/rstudio/blob/main/4_Exploratory_Data_Analysis/1.-%20Project/plot1.png)

### Plot2
```R
#Load library
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
```
![](https://github.com/lalamas/rstudio/blob/main/4_Exploratory_Data_Analysis/1.-%20Project/plot2.png)

### Plot3

```R
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
```
![](https://github.com/lalamas/rstudio/blob/main/4_Exploratory_Data_Analysis/1.-%20Project/plot3.png)

### Plot4
```R
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
```
![](https://github.com/lalamas/rstudio/blob/main/4_Exploratory_Data_Analysis/1.-%20Project/plot4.png)
