# Author: Alberto Lamas
# Project: Course Project 2

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


# Prevents histogram from printing in scientific notation
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