Exploratory Data Analysis Project
========================================================

Introduction
-------------

Fine particulate matter ($PM_{2.5}$) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of $PM_{2.5}$. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the [EPA National Emissions Inventory web site] (http://www.epa.gov/ttn/chief/eiinformation.html).

For each year and for each type of PM source, the NEI records how many tons of $PM_{2.5}$ were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

Data
---------

The data for this assignment are available from the course web site as a single zip file:

* [Data for Peer Assessment] (https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip) [29Mb]

The zip file contains two files:

$PM_{2.5}$ Emissions Data (``summarySCC_PM25.rds``): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of **tons** of $PM_{2.5}$ emitted from a specific type of source for the entire year. Here are the first few rows.


```
##     fips      SCC Pollutant Emissions  type year
## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
```


* ``fips``: A five-digit number (represented as a string) indicating the U.S. county
* ``SCC``: The name of the source as indicated by a digit string (see source code classification table)
* ``Pollutant``: A string indicating the pollutant
* ``Emissions``: Amount of PM2.5 emitted, in tons
* ``type``: The type of source (point, non-point, on-road, or non-road)
* ``year``: The year of emissions recorded

Source Classification Code Table (``Source_Classification_Code.rds``): This table provides a mapping from the SCC digit strings int he Emissions table to the actual name of the $PM_{2.5}$ source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source ??10100101?? is known as ??Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal??.

You can read each of the two files using the ``readRDS()`` function in R. For example, reading in each file can be done with the following code:


```r
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```


as long as each of those files is in your current working directory (check by calling ``dir()`` and see if those files are in the listing).

Assignment
---------------

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999??2008. You may use any R package you want to support your analysis.

### Questions

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

1. Have total emissions from $PM_{2.5}$ decreased in the United States from 1999 to 2008? Using the **base** plotting system, make a plot showing the total $PM_{2.5}$ emission from all sources for each of the years 1999, 2002, 2005, and 2008.
2. Have total emissions from $PM_{2.5}$ decreased in the **Baltimore City**, Maryland (``fips == "24510"``) from 1999 to 2008? Use the base plotting system to make a plot answering this question.
3. Of the four types of sources indicated by the ``type`` (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999??2008 for **Baltimore City**? Which have seen increases in emissions from 1999??2008? Use the **ggplot2** plotting system to make a plot answer this question.
4. Across the United States, how have emissions from coal combustion-related sources changed from 1999??2008?
5. How have emissions from motor vehicle sources changed from 1999??2008 in **Baltimore City**?
6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in **Los Angeles County**, California (``fips == "06037"``). Which city has seen greater changes over time in motor vehicle emissions?

### Making and Submitting Plots

For each plot you should

* Construct the plot and save it to a **PNG file**.
* Create a separate R code file (``plot1.R``, ``plot2.R``, etc.) that constructs the corresponding plot, i.e. code in plot1.R constructs the plot1.png plot. Your code file should include code for reading the data so that the plot can be fully reproduced. You should also include the code that creates the PNG file. Only include the code for a single plot (i.e. ``plot1.R`` should only include code for producing ``plot1.png``)
* Upload the PNG file on the Assignment submission page
* Copy and paste the R code from the corresponding R file into the text box at the appropriate point in the peer assessment.
-------------------------------------------------------------------------------------------------
### Solutions for the questions 

#### Download and Loading Files "Common for all Questions"
----------------------------------------------------
```R
# Loadlibrary 
library("data.table")

# Definition variables for files
ssc_file <- "./data/Source_Classification_Code.rds"
nei_file <- "./data/summarySCC_PM25.rds"
zip_file <- "./data/dataFiles.zip"

# select Work Directory
setwd("./4_Exploratory_Data_Analysis/2-Project")

# view pwd actual
path <- getwd()

# Donwload files and save in local directory
if(!file.exists(nei_file) && !file.exists(ssc_file) ){
  print("Download file")
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "./data/dataFiles.zip", sep = "/"))
  # unzip files in pwd actual
  unzip(zipfile=zip_file, exdir="./data")

  #Check its existence fiel zip
  if (file.exists(zip_file)) {
      #Delete file if it exists
      file.remove(zip_file)
  }
  
}else{
  print("File exists in local")
}

# Load files in data.table
sscT <- data.table::as.data.table(x = readRDS(file = ssc_file))
neiT <- data.table::as.data.table(x = readRDS(file = nei_file))

# Dimension table's
# sscT -> 11717 - 15
# neiT -> 6497651 - 6
dim(sscT)
dim(neiT)

```
### Question 1
Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

![Plot 1](https://github.com/lalamas/datasciencecoursera-/blob/main/4_Exploratory_Data_Analysis/2-Project/pics/plot1.png)

```R
# Prevents histogram 
neiT[, Emissions := lapply(.SD, as.numeric), 
     .SDcols = c("Emissions")]

totalNei <- neiT[, lapply(.SD, sum, na.rm = TRUE), 
                 .SDcols = c("Emissions"), by = year]

# definition  driver graphics copy file png, with dimension size 504
dev.copy(png,file = "./pics/plot1.png", width=504, height=504)

# plot barr
barplot(totalNei[, Emissions]
        , names = totalNei[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions over the Years")

# clean driver graphics
dev.off()
```
### Question 2
Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (\color{red}{\verb|fips == "24510"|}fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
![Plot 2](https://github.com/lalamas/datasciencecoursera-/blob/main/4_Exploratory_Data_Analysis/2-Project/pics/plot2.png)
```R
# Prevents histogram 
neiT[, Emissions := lapply(.SD, as.numeric), 
     .SDcols = c("Emissions")]

totalNei <- neiT[fips=='24510', lapply(.SD, sum, na.rm = TRUE), 
                 .SDcols = c("Emissions"), 
                 by = year]

# definition  driver graphics copy file png, with dimension size 504
dev.copy(png,file = "./pics/plot2.png", width=504, height=504)

# Plot 2
barplot(totalNei[, Emissions]
        , names = totalNEI[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions over the Years")

# clean driver graphics
dev.off()
```
### Question 3
Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999???2008 for Baltimore City? Which have seen increases in emissions from 1999???2008? Use the ggplot2 plotting system to make a plot answer this question.
![Plot 3](https://github.com/lalamas/datasciencecoursera-/blob/main/4_Exploratory_Data_Analysis/2-Project/pics/plot3.png)
```R
# Subset NEI - Baltimore
baltimore <- neiT[fips=="24510",]

# Plot 3
ggplot(baltimore,
  aes(factor(year),Emissions)) + # fill=as.factor(cyl)
  theme_light() +
  facet_grid(.~type,scales = "free",space="free") + 
  geom_bar(stat="identity",width=0.5, fill="steelblue") +
  guides(fill="none") +
  labs(x="year", y=expression("Total PM-Emission")) + 
  labs(title=expression("PM-Emissions-Baltimore City (1999-2008)-")
)

# definition  driver graphics copy file png, with dimension size 504
dev.copy(png,file = "./pics/plot3.png", width=504, height=504)

# clean driver graphics
dev.off()
```
### Question 4
Across the United States, how have emissions from coal combustion-related sources changed from 1999???2008?
![Plot 4](https://github.com/lalamas/datasciencecoursera-/blob/main/4_Exploratory_Data_Analysis/2-Project/pics/plot4.png)
```R
# Names Variables in table sscT & neiT 
# ssCT -> SCC.Level.One, SCC.Level.Four, SCC
# neiT ->  SCC
names(sscT)
names(neiT)

# Subset coal combustion 
combuSsc <- grepl("comb", sscT[, SCC.Level.One], ignore.case=TRUE) # Filter 1 Comb SCC.Level.One
coalSsc <- grepl("coal", sscT[, SCC.Level.Four], ignore.case=TRUE) # Filter 2 coal SCC.Level.Four
combuTemp <- sscT[combuSsc & coalSsc, SCC]                         # Filter 3 filter 1 + filter 2 + SSC
combustion <- neiT[neiT[,SCC] %in% combuTemp]                      # Filter 4 search filter 3 in table neiT variable "SSC"

# Plot 4
ggplot(combustion,
  aes(factor(year),Emissions/10^5)) + # Adjunst scale emissions to 10^5 for correct visualizations
  theme_light() +
  facet_grid(.~type,scales = "free",space="free") + 
  geom_bar(stat="identity",width=0.5, fill="steelblue") +
  guides(fill="none") +
  labs(x="year", y=expression("Total PM-Emission")) + 
  labs(title=expression("Coal Combustion Source Emissions (1999-2008)-")
  )

# definition  driver graphics copy file png, with dimension size 504
dev.copy(png,file = "./pics/plot4.png", width=504, height=504)

# clean driver graphics
dev.off()
```

### Question 5
How have emissions from motor vehicle sources changed from 1999???2008 in Baltimore City?
![Plot 5](https://github.com/lalamas/datasciencecoursera-/blob/main/4_Exploratory_Data_Analysis/2-Project/pics/plot5.png)
```R
# Names Variables in table sscT & neiT 
# sscT -> SCC.Level.Two,  SCC
# neiT ->  SCC

names(sscT)
names(neiT)

# Subset vehicles
vehiSsc <- sscT[grepl("vehicle", sscT$SCC.Level.Two, ignore.case=TRUE), SCC] # Filter 1
vehiNei <- neiT[neiT[, SCC] %in% vehiSsc,]                                   # Filter 2

# Subset Baltimore's fip
vehiBal <- vehiNei[fips=="24510",]                                           # Filter 3

# Plot 5
ggplot(vehiBal,
       aes(factor(year),Emissions)) + 
  theme_light() +
  facet_grid(.~type,scales = "free",space="free") + 
  geom_bar(stat="identity",width=0.5, fill="steelblue") +
  guides(fill="none") +
  labs(x="year", y=expression("Total PM-Emission")) + 
  labs(title=expression("-Motor Vehicle Source Emissions in Baltimore (1999-2008)-")
  )

# definition  driver graphics copy file png, with dimension size 504
dev.copy(png,file = "./pics/plot5.png", width=504, height=504)

# clean driver graphics
dev.off()
```
### Question 6
Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"|}fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
![Plot 6](https://github.com/lalamas/datasciencecoursera-/blob/main/4_Exploratory_Data_Analysis/2-Project/pics/plot6.png)
```R
# Names Variables in table sscT & neiT 
# sscT -> SCC.Level.Two,  SCC
# neiT ->  SCC

names(sscT)
names(neiT)

# Gather the subset of the NEI data which corresponds to vehicles
vehiSsc <- sscT[grepl("vehicle", sscT$SCC.Level.Two, ignore.case=TRUE), SCC] # Filter 1
vehiNei <- neiT[neiT[, SCC] %in% vehiSsc,]                                   # Filter 2

# Subset by each city
# Baltimore
vehiBalti <- vehiNei[fips == "24510",]
vehiBalti[, city := c("Baltimore City")]
# Los Angeles
vehiLa <- vehiNei[fips == "06037",]
vehiLa[, city := c("Los Angeles")]

# Combine data.tables 
bothBaLa <- rbind(vehiBalti,vehiLa)

# Plot 6
ggplot(bothBaLa,
       aes(factor(year),Emissions, fill=city)) + 
  theme_light() +
  facet_grid(scales = "free",space="free",.~city) + 
  geom_bar(aes(fill=year),stat="identity",width=0.5, fill="steelblue") +
  labs(x="year", y=expression("Total Emission - Kilo-Tons")) + 
  labs(title=expression("-Motor Vehicle Source Emissions in Baltimore (1999-2008)-")
  )

# definition  driver graphics copy file png, with dimension size 504
dev.copy(png,file = "./pics/plot6.png", width=504, height=504)

# clean driver graphics
dev.off()
```
