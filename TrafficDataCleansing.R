library(ggplot2)
library(tibble)
library(dplyr)
library(reshape2)
library(scales)
library(leaflet)
library(lubridate)


path = "D:\\NUIG Project Data Set\\Census Data Set\\Traffic data after 2012"
setwd(path)
file.names <- dir(path,pattern = ".csv")
newDf <- data.frame(Route = "X",Yeartaken = 2011,PeakAm = "1111",PeakAmVolume = 1111,PeakPm = "peakPm",PeakPmVolume = 1111,AADT = 1111)
#routes <- c("M6","N17","N18","N59","N84")

for (i in 1:length(file.names)) {

  dataSet <- read.csv(file.names[i],stringsAsFactors = F)
  df <- dataSet[c(14:39),c(1:ncol(dataSet))]
  extractYear <- as.Date(df[1,2])
  numYear <- as.numeric(format(extractYear,"%Y"))
  colCount <- ncol(df) - 3
  #countData <- df[c(2:25),c(2:ncol(df))]
  clockData <- df[c(2:25),c(2:colCount)]
  fnSum <- function(x,a,b){
    rowSm <-0
    for (i in c(a:b))
    {
      rowSm = rowSm+ sum(as.numeric(x[i,]),na.rm = T)
    }
    return(rowSm)
  }
  
  ##mean(as.numeric(clockData[2,]))
  
  ##amMean <- fnMean(clockData,7,11)
  ##pmMean <- fnMean(clockData,17,21)
  ##interMean <- (fnMean(clockData,12,16) + fnMean(clockData,22,24) + fnMean(clockData,1,6))/3 
  
  AADT <- fnSum(clockData,1,24)/(ncol(clockData))
  peakAm <- dataSet[45,ncol(clockData)]
  peakAmVolume <- as.numeric(dataSet[46,ncol(clockData)])
  peakPm <- dataSet[47,ncol(clockData)]
  peakPmVolume <- as.numeric(dataSet[48,ncol(clockData)])
  route <- substring(file.names[i],1,3)
  
  tempDf <- data.frame(Route = route,Yeartaken = numYear,PeakAm = peakAm,PeakAmVolume = peakAmVolume,PeakPm = peakPm,PeakPmVolume = peakPmVolume,AADT = AADT)
  newDf <<- rbind(newDf,tempDf) 
  
}

newDf <- newDf[-1,]

######################################################## Cleansing data prior to 2012

path = "D:\\NUIG Project Data Set\\Census Data Set\\Traffic Data Prior 2013\\Traffic Data"
setwd(path)
file.names <- dir(path,pattern = ".csv")

for (i in 1:length(file.names)) {
  
  dataSet <- read.csv(file.names[i],stringsAsFactors = F)
  yearVal <- substring(trimws(dataSet[2,2], which = "both"), 7,11)
  
  metadata <- dataSet %>% select("Hour.ending","Total.volume") %>% group_by(Hour.ending) %>% summarise(total = sum(Total.volume))
  hours <- seq(from=as.POSIXct("2012-01-01 00:00:00"), 
      to=as.POSIXct("2012-01-01 23:00:00"), by="hour", format = "%Y-%M-%D %H:%M:%S")
  timeinHrs <- substring(hours,12,19)
  metadata$time <- timeinHrs
  
  route <- substring(file.names[i],1,3)
  peakAmtime <- metadata %>% filter(Hour.ending %in% c(600:1200)) %>% top_n(n=1) %>% select(time)
  peakPmtime <- metadata %>% filter(Hour.ending %in% c(1600:2000)) %>% top_n(n=1) %>% select(time)
  peakAmVolume <- metadata %>% filter(Hour.ending %in% c(600:1200))  %>% top_n(n=1) %>% select(total)
  peakPmVolume <- metadata %>% filter(Hour.ending %in% c(1600:2000)) %>% top_n(n=1) %>% select(total)
  peakAmVolume <- (peakAmVolume/nrow(dataSet)) * 24
  peakPmVolume <- (peakPmVolume/nrow(dataSet)) * 24
  AADT <- (sum(metadata[,2])/nrow(dataSet)) * 24
  tempDf <- data.frame(Route = route,Year = yearVal,PeakAm = peakAmtime,PeakAmVolume = peakAmVolume,PeakPm = peakPmtime,PeakPmVolume = peakPmVolume,AADT = AADT)
  colnames(tempDf) <- c("Route","Yeartaken","PeakAm","PeakAmVolume","PeakPm","PeakPmVolume","AADT")
  newDf <<- rbind(newDf,tempDf) 
  
  
}
newDf$Yeartaken <- as.numeric(newDf$Yeartaken)
newDf <- newDf %>% arrange(Yeartaken)
str(newDf)
grouped_Data <- newDf %>% select("Yeartaken","PeakAmVolume","PeakPmVolume","AADT") %>% group_by(Yeartaken) %>% summarise(MeanPeakAmVolume = sum(PeakAmVolume),MeanPeakPmVolume = sum(PeakPmVolume),MeanAADT = sum(AADT))
#mean_peakAm <- newDf %>% select("Yeartaken","PeakAm") %>% group_by(Yeartaken) %>% top_n(n=1) %>% select(PeakAm)
grouped_Data$City <- "Galway"
#View(grouped_Data)
write.csv(grouped_Data, "D:\\NUIG Project Data Set\\Census Data Set\\CleansedData\\CleansedTrafficData.csv", row.names = F)

# newDf$Year <- as.numeric(newDf$Year)
# str(newDf)
#newDf <- newDf %>% group_by(Yeartaken) %>% mutate(AADT_Total = sum(AADT))


