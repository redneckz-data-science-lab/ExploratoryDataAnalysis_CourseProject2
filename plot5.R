library("data.table")
library("ggplot2")

if (!exists("NEI")) {
    NEI <- data.table(readRDS("summarySCC_PM25.rds"))
}
if (!exists("SCC")) {
    SCC <- data.table(readRDS("Source_Classification_Code.rds"))
}

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
motor.vehicle.SCC <- SCC[grepl("vehicle", EI.Sector, ignore.case = T)][["SCC"]]
total.emissions <- NEI[(fips == "24510") & (SCC %in% motor.vehicle.SCC), sum(Emissions), by = year]
total.emissions[, Total := V1]

g <- ggplot(total.emissions, aes(year, Total)) +
    geom_point(size = 2) +
    geom_smooth(method = "lm") +
    labs(title = "Total emissions PM2.5 from motor vehicle sources in Baltimore City") +
    labs(x = "Year", y = "Total Emissions, in tons")
print(g)

d <- dev.copy(png, filename = "plot5.png", width = 640, height = 480)
dev.off(d)
