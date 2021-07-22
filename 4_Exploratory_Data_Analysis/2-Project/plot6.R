# Author: Alberto Lamas
# Project: Course Project 2

# Loadlibrary 
library("data.table")
library("ggplot2")

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