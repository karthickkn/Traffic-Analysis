library(ggplot2)
library(tibble)
library(dplyr)
library(reshape2)
library(scales)
library(leaflet)
library(lubridate)


path = "D:\\NUIG Project Data Set\\Census Data Set\\Traffic data 2016"
setwd(path)
file.names <- dir(path,pattern = ".csv")
newDf <- data.frame(Route = "X",Yeartaken = 2016,Month = "Jan",Day = "Mon",Hour = 0, Volume = 34)

for (i in 1:length(file.names)) {
  
  dataSet <- read.csv(file.names[i],stringsAsFactors = F)
  route <- substring(file.names[i],1,3)
  df <- dataSet[c(13:39),c(1:ncol(dataSet))]
  colCount <- ncol(df) - 3
  clockData <- df[1:26,c(2:colCount)]
  clockVector <- as.vector(clockData[1,])
  for (x in 1:length(clockVector)) {
    dayVal <- clockData[1,x]
    conDate <- as.Date(clockData[2,x])
    monthVal <- months(conDate)
    for(y in 3:26){
      timeHr <- y-3
      vehVol <- clockData[y,x] 
      tempDf <- data.frame(Route = route,Yeartaken = 2016,Month = monthVal,Day = dayVal,Hour = timeHr,Volume = vehVol)
      newDf <<- rbind(newDf,tempDf)
      
    }
   
  }
  
  
}

newDf <- newDf[-1,]
write.csv(newDf, "D:\\NUIG Project Data Set\\Census Data Set\\CleansedData\\PeriodicTrafficData.csv", row.names = F)
