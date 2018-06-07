library(ggplot2)
library(tibble)
library(dplyr)
library(reshape2)
library(scales)
library(leaflet)
library(lubridate)


path = "D:\\NUIG Project Data Set\\Census Data Set\\Census data"
file.names <- dir(path,pattern = ".csv")
newDf <- data.frame("Galway",54612,54187,19502,409,5499,311,13250,6975,1773,1587,1776,2148,3854,5305,8050,	
                    4475,2099,12812,8305,3650,1263,1620,908,7909,6748,1300,908,7909,6748,1300,508)

colnames(newDf)<-c("County","Overall Population","Population residing","Employed","Looking for first regular job","Unemployed","Travelling by Bicycle",
                "Travelling by Bus, Minibus or Coach","Travelling by Motorcycle or scooter","Travelling by Car as driver","Travelling by Car as passenger","Travelling by Van","Travelling by other vehicle like lorry",
                "Leaving time - Before 6.30","Leaving time - 6.30 - 7.00", "Leaving time - 7.01 - 7.30","Leaving time - 7.30 - 8.00","Leaving time - 8.00 - 8.30","Leaving time - 8.30 - 9.00","Leaving time - 9.00 - 9.30","Leaving time - After 9.30",
                "Journey time - Under 15 mins", "Journey time - 1/4 hr to Under 1/2 hr","Journey time - 1/2 hr to Under 3/4 hr","Journey time - 3/4 hr to Under 1 hr","Journey time - 1 hr to Under 1 1/2 hr", "Journey time - 1 1/2 hrs and over","Households with 1 Car","Households with 2 Car","Households with 3 Car","Households with 4 Car", "Total no. of cars owned")


for (i in 1:length(file.names)) {
  dataSet <- read.csv(file.names[i],stringsAsFactors = F)
  df <- dplyr::select(filter(dataSet,dataSet$GEOGDESC %in% c("Galway City","Galway County")),"GEOGDESC",c(starts_with("T")))
  View(df)
  colnames(df)<-c("County","Overall Population","Population residing","Employed","Looking for first regular job","Unemployed","Travelling by Bicycle",
                "Travelling by Bus, Minibus or Coach","Travelling by Motorcycle or scooter","Travelling by Car as driver","Travelling by Car as passenger","Travelling by Van","Travelling by other vehicle like lorry",
                "Leaving time - Before 6.30","Leaving time - 6.30 - 7.00", "Leaving time - 7.01 - 7.30","Leaving time - 7.30 - 8.00","Leaving time - 8.00 - 8.30","Leaving time - 8.30 - 9.00","Leaving time - 9.00 - 9.30","Leaving time - After 9.30",
                "Journey time - Under 15 mins", "Journey time - 1/4 hr to Under 1/2 hr","Journey time - 1/2 hr to Under 3/4 hr","Journey time - 3/4 hr to Under 1 hr","Journey time - 1 hr to Under 1 1/2 hr", "Journey time - 1 1/2 hrs and over","Households with 1 Car","Households with 2 Car","Households with 3 Car","Households with 4 Car", "Total no. of cars owned")
  
  
  #df <- df[,-1]
  tempDf <- df[1,2:ncol(df)] + df[2,2:ncol(df)]
  tempDf$County <- "Galway"
  #View(tempDf)
  newDf <- rbind(newDf,tempDf)
  
}
newDf <- newDf[-1,]

diffDf <- newDf[,-1]
diffDf <- newDf[2,2:ncol(newDf)] - newDf[1,2:ncol(newDf)]
Incfactor <- (diffDf/newDf[1,2:ncol(newDf)]) 
IncPerYear <- Incfactor/5 
needDf <- newDf[,-1]
needDf <- needDf[-2,]
growth <-  needDf * IncPerYear

for(j in c(1:5))
{
  tmpDf <- needDf[1,] + (growth * j)
  needDf <- rbind(needDf,tmpDf)
}

View(needDf)
needDf$Year <- c("2011","2012","2013","2014","2015","2016")
write.csv(needDf, "D:\\NUIG Project Data Set\\Census Data Set\\CleansedData\\CleansedCensusData.csv", row.names = F)
