library("data.table")
library("ggplot2")

if (!exists("NEI")) {
    NEI <- data.table(readRDS("summarySCC_PM25.rds"))
}
if (!exists("SCC")) {
    SCC <- data.table(readRDS("Source_Classification_Code.rds"))
}

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
# Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.
total.emissions <- NEI[fips == "24510", sum(Emissions), by = list(type, year)]
total.emissions[, Total := V1]
total.emissions[, type := factor(type)]

g <- ggplot(total.emissions, aes(year, Total, color = type)) +
        facet_grid(type ~ .) +
        geom_smooth(method = "lm") +
        labs(title = "Total emissions PM2.5 in the Baltimore City") +
        labs(x = "Year", y = "Total Emissions, in tons")
g + geom_point(size = 4)

d <- dev.copy(png, filename = "plot3.png", width = 640, height = 2 * 480)
dev.off(d)
