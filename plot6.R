library("data.table")
library("ggplot2")

if (!exists("NEI")) {
    NEI <- data.table(readRDS("summarySCC_PM25.rds"))
}
if (!exists("SCC")) {
    SCC <- data.table(readRDS("Source_Classification_Code.rds"))
}

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == 06037).
# Which city has seen greater changes over time in motor vehicle emissions?
motor.vehicle.SCC <- SCC[grepl("vehicle", EI.Sector, ignore.case = T)][["SCC"]]
total.emissions <- NEI[(fips %in% c("24510", "06037")) & (SCC %in% motor.vehicle.SCC),
                       sum(Emissions), by = list(fips, year)]
total.emissions[, Total := V1]
total.emissions[, fips := factor(fips, levels = c("24510", "06037"),
                                 labels = c("Baltimore City", "Los Angeles County"))]

g <- ggplot(total.emissions, aes(year, Total, color = fips)) +
    geom_point(size = 2) +
    geom_smooth(method = "lm") +
    labs(title = "Total emissions PM2.5 from motor vehicle sources in Baltimore City vs Los Angeles County") +
    labs(x = "Year", y = "Total Emissions, in tons")
print(g)

d <- dev.copy(png, filename = "plot6.png", width = 640, height = 480)
dev.off(d)
