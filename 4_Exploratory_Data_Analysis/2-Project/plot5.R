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
