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
total.emissions <- NEI[, sum(Emissions), by = list(type, year)]
total.emissions[, Total := V1]
total.emissions[, type := factor(type)]

g <- ggplot(total.emissions, aes(year, Total, color = type)) +
    geom_point(size = 2) +
    facet_grid(type ~ .) +
    geom_smooth(method = "lm") +
    labs(title = "Total emissions PM2.5 in the Baltimore City") +
    labs(x = "Year", y = "Total Emissions, in tons")
print(g)

d <- dev.copy(png, filename = "plot3.png", width = 640, height = 2 * 480)
dev.off(d)
