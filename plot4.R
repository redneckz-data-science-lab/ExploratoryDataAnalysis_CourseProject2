library("data.table")

if (!exists("NEI")) {
    NEI <- readRDS("summarySCC_PM25.rds")
}
if (!exists("SCC")) {
    SCC <- readRDS("Source_Classification_Code.rds")
}



d <- dev.copy(png, filename = "plot4.png", width = 480, height = 480)
dev.off(d)
