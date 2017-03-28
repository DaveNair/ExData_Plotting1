# Subsetting the Data
## Going to make smaller FILE to read in for data
## Although this is still reading through a large file
## to make the smaller one; it will NOT be storing the
## large file as a *table*, which would be memory-heavy.

DNSubsetFile <- 'TempSubsetFile.DN.txt'
if (!file.exists(DNSubsetFile)){
	RawFile <- 'household_power_consumption.txt'
	DateCondition <- '(^Date;Time)|(^1/2/2007)|(^2/2/2007)'
	write( readLines(RawFile)[grep(DateCondition,readLines(RawFile))], DNSubsetFile)
	remove(RawFile, DateCondition)
	}
## the above is the equivalent to the following unix (terminal) command (without the #):
#cat household_power_consumption.txt | grep "(^1/2/2007)|(^2/2/2007)" > TempSubsetFile.DN.txt
## this way, we will have a FILE that only has our subset of data in it
DNSubset <- read.table(DNSubsetFile, header=TRUE, sep=';', stringsAsFactors=FALSE)


# Function for Plots
## This function converts strings into a numeric # of minutes:
### Example:  '1/2/2007 00:01:00'  -->  86460

Minutes <- function(TimeString){
	Time <- strptime(TimeString, format="%d/%m/%Y %H:%M:%S")
	totMin <- Time$min + (60*(Time$hour + (24*(Time$mday)) ))
	return(totMin)}



## get/convert the time measurements for the x axis
TimeStrings <- mapply( paste, DNSubset$Date, DNSubset$Time, collapse=' ',
	USE.NAMES=FALSE)
Times <- sapply(TimeStrings, Minutes, USE.NAMES=FALSE)

## going to get these ready as well
Ticks <- c( Minutes("1/2/2007 00:00:00"),
		Minutes("2/2/2007 00:00:00"),
		Minutes("3/2/2007 00:00:00"))
Labels <- c("Thu", "Fri", "Sat")



## Figure w 4 plots
### process (sometimes w Copy&Paste (C&P)):
### * open png as graphics device
### * ready the figure for 4 plots with mfrow()
### * plot each plot, in order:
### ** C&P from plot2.R
### ** datetime vs Voltage
### ** C&P from plot3.R
### ** datetime vs Global_reactive_power

png(file = 'plot4.png') #DEFAULT for png is 480 x 480 pixels
par(mfrow = c(2,2))

plot( Times, DNSubset$Global_active_power, type='l',
	ylab='Global Active Power', xlab='',
	 xaxt='n')
axis(1,at=Ticks,labels=Labels)


plot( Times, DNSubset$Voltage, type='l', ylab='Voltage',
	xlab='datetime',xaxt='n')
axis(1,at=Ticks,labels=Labels)


plot( Times, DNSubset$Sub_metering_1, type='l',
	ylab='Energy sub metering', xlab='',
	 col='black', xaxt='n')
lines( Times, DNSubset$Sub_metering_2, col='red' )
lines( Times, DNSubset$Sub_metering_3, col='blue' )
legend("topright", lty=c(1,1,1), col=c('black','red','blue'), 
	legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3'))
axis(1,at=Ticks,labels=Labels)

plot(Times,DNSubset$Global_reactive_power,type='l',
	ylab='Global_reactive_power', xlab='datetime', xaxt='n')
axis(1,at=Ticks,labels=Labels)


dev.off()
