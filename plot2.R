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


# Function for Plot2
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



## plot2
### x=Times, y=DNSubset$Global_active_power, type==line
### also used xaxt (to remove the numeric values on x-axis)
### also used axis(at=,labels=), using the following:

Ticks <- c( Minutes("1/2/2007 00:00:00"),
		Minutes("2/2/2007 00:00:00"),
		Minutes("3/2/2007 00:00:00"))
Labels <- c("Thu", "Fri", "Sat")

png(file = 'plot2.png') #DEFAULT for png is 480 x 480 pixels
plot( Times, DNSubset$Global_active_power, type='l',
	ylab='Global Active Power (kilowatts)', xlab='',
	 xaxt='n')
axis(1,at=Ticks,labels=Labels)
dev.off()
