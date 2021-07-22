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