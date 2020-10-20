library(dplyr)
library(lubridate)
dlUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
## Get the data, but only if we haven't already!
if (!file.exists("dataset.zip")) {
  download.file(dlUrl, "dataset.zip")}
## Unzip our data, but again we only want to do this if we haven't done it before:
if (!file.exists("household_power_consumption.txt")) {unzip("dataset.zip")}
hpc <- read.table("household_power_consumption.txt",sep=";",header = TRUE)
dayone <- filter(hpc,Date=="1/2/2007")
daytwo <- filter(hpc,Date=="2/2/2007")
ourdata <- rbind(dayone,daytwo)
timestamps <- vector()
for (i in 1:nrow(ourdata)) {
timestamps[i] <- as.POSIXct(dmy_hms(as.character(paste(ourdata[,1][i],ourdata[,2][i]))))
}
cleanedData <- cbind(timestamps,ourdata[,3:9])
remove(ourdata,hpc,dayone,daytwo)
ts <- as.POSIXct(cleanedData$timestamps, origin = "1970-01-01",tz="utc")
ya <- as.numeric(cleanedData$Global_active_power)
yb <- as.numeric(cleanedData$Voltage)
yc1 <- as.numeric(cleanedData$Sub_metering_1)
yc2 <- as.numeric(cleanedData$Sub_metering_2)
yc3 <- as.numeric(cleanedData$Sub_metering_3)
yd <- as.numeric(cleanedData$Global_reactive_power)
#######
png("plot4.png")
par(mfrow=c(2,2))
##A
plot(ts,ya, type = "n",ylab="Global Active Power (kilowatts)",xlab="")
lines(ts,ya, type="l")
##B
plot(ts,yb, type = "n",ylab="Voltage",xlab="datetime")
lines(ts,yb, type="l")
##C
plot(ts,yc1, ylim=c(0,35), type = "l", col="black", yaxt="n",ylab="Energy sub metering",xlab="")
axis(2,at=c(0,10,20,30))
lines(ts,yc2, type="l", col="red", ylim=c(0,35))
lines(ts,yc3, type="l", col="purple", ylim=c(0,35))
legend("topright",legend=c("Sub_metering1","Sub_metering2","Sub_metering3"),col=c("black","red","purple"),lty=c(1,1,1))
##D
plot(ts,yd, type = "n",ylab="Global reactive power",xlab="datetime")
lines(ts,yd, type="l")
dev.off()

