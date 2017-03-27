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

DNSubset <- read.table(DNSubsetFile, header=TRUE, sep=';')


## plot 1
png(file = 'plot1.png')
hist(DNSubset$Global_active_power, main='Global Active Power', 
	xlab='Global Active Power (kilowatts)', col='red')
dev.off()
