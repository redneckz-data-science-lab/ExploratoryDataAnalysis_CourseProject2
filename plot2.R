library("data.table")

if (!exists("NEI")) {
    NEI <- data.table(readRDS("summarySCC_PM25.rds"))
}
if (!exists("SCC")) {
    SCC <- data.table(readRDS("Source_Classification_Code.rds"))
}

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources
# for each of the years 1999, 2002, 2005, and 2008.
total.emissions <- NEI[fips == "24510", sum(Emissions), by = year]
total.emissions[, Total := V1]

with(total.emissions, {
    print(as.character(year))
    plot(Total ~ year, main = "Total Emissions PM2.5 in the Baltimore City",
         xlab = "Year", ylab = "Total Emissions, in tons")
    axis(1, at = year, labels = as.character(year))
    abline(lm(Total ~ year), col = "red")
})

d <- dev.copy(png, filename = "plot2.png", width = 640, height = 480)
dev.off(d)
