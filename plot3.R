# Set working directory
# Subdirectories within: data (for original data) and ExData_Plotting1 (for storing PNG results and Git connection)
setwd("/home/victor/Datos/RStudio/ExpDataAnal")
# Read a small sample of data
initial <- read.table("data/household_power_consumption.txt", nrows = 100, sep = ";", header = TRUE, na.strings = "?")
# Infeer data classes from sample
classes <- sapply(initial, class)
# Provided there's enoguh RAM on the system, read whole data improving speed by specifying data classes and other parameters
datos <- read.table("data/household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?", colClasses = classes, stringsAsFactors = FALSE)
# Better use data.table than data.frame
library(data.table)
# Convert data frame to data table
datos2 = data.table(datos)
# Subset just the neede records
datos3 <- subset(datos2, Date=='1/2/2007' | Date=='2/2/2007')
# Remove from memory unneeded data
rm(datos, datos2)
# Conversion of Date / Time factors to 
# lubridate package required; install it if not installed and load it
if (!library(lubridate, logical.return = TRUE)) {
	install.packages("lubridate")
} else {
	library(lubridate)
}
# Create new POSIXct variable from Date / Time for easier handling of data
datos3[, Timestamp := lubridate::dmy(datos3$Date) + lubridate::hms(datos3$Time)]

# Plot 3
# (required 480x480 pixels is the default size)
# For avoiding legend cutoff when exporting to PNG, we'll plot directly to PNG graphics device and not dev.copy
png(file = "./ExData_Plotting1/plot3.png")
# Fix size of texts
par(ps=12)
# Plot creation
with(datos3, plot(Sub_metering_1 ~ Timestamp, type = "l", xlab = "", ylab = "Energy sub mettering"))
with(datos3, lines(Timestamp, Sub_metering_2 ,col="red"))
with(datos3, lines(Timestamp, Sub_metering_3 ,col="blue"))
# Annotate legend
legend("topright",  # Legend position
	c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),  # Texts for the legend
	lty=c("solid", "solid", "solid"),  # Lines symbols in the legend
	# lwd=c(2.5, 2.5, 2.5),
	col=c("black", "red", "blue"))  # Colors for the lines
# Close file graphics device
dev.off()
