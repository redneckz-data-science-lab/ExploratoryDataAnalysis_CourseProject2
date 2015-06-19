library("data.table")
library("ggplot2")

if (!exists("NEI")) {
    NEI <- data.table(readRDS("summarySCC_PM25.rds"))
}
if (!exists("SCC")) {
    SCC <- data.table(readRDS("Source_Classification_Code.rds"))
}

# Across the United States, how have emissions from coal combustion-related sources
# changed from 1999–2008?
coal.combustion.SCC <- SCC[grepl("fuel comb.+ coal", EI.Sector, ignore.case = T)][["SCC"]]
total.emissions <- NEI[SCC %in% coal.combustion.SCC, sum(Emissions), by = year]
total.emissions[, Total := V1]

g <- ggplot(total.emissions, aes(year, Total)) +
    geom_point(size = 2) +
    geom_smooth(method = "lm") +
    labs(title = "Total emissions PM2.5 from coal combustion-related sources") +
    labs(x = "Year", y = "Total Emissions, in tons")
print(g)

d <- dev.copy(png, filename = "plot4.png", width = 640, height = 480)
dev.off(d)
