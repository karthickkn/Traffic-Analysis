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
length(newDf)

colnames(newDf)<-c("City","Total_Population","Residing_Population","At_Work_Total","Looking_For_First_Job_Total","Unemployed","Bicycle",	"Bus_minibus_or_coach",	"Motorcycle_or_scooter",
                   "Car_driver","Car_passenger","Van","Other","Before_06_30","T_06_30_07_00","T_07_01_07_30","T_07_31_08_00","T_08_01_08_30","T_08_31_09_00","T_09_01_09_30",
                   "After_09_30","Under_15_mins","T_1_4_hour_under_1_2_hour","T_1_2_hour_under_3_4_hour","T_3_4_hour_under_1_hour",	"T_1_hour_under_1_1_2_hours",	"T_1_1_2_hours_and_over",
                   "One_motor_car","Two_motor_cars","Three_motor_cars","Four_or_more_motor_cars","Total_Cars")


for (i in 1:length(file.names)) {
  dataSet <- read.csv(file.names[i],stringsAsFactors = F)
  
  
  df <- dplyr::select(filter(dataSet,dataSet$GEOGDESC %in% c("Galway City","Galway County")),"GEOGDESC","Total_Population","Residing_Population","At_Work_Total","Looking_For_First_Job_Total","Unemployed","Bicycle",	"Bus_minibus_or_coach",	"Motorcycle_or_scooter",
                      "Car_driver","Car_passenger","Van","Other","Before_06_30","T_06_30_07_00","T_07_01_07_30","T_07_31_08_00","T_08_01_08_30","T_08_31_09_00","T_09_01_09_30",
                      "After_09_30","Under_15_mins","T_1_4_hour_under_1_2_hour","T_1_2_hour_under_3_4_hour","T_3_4_hour_under_1_hour",	"T_1_hour_under_1_1_2_hours",	"T_1_1_2_hours_and_over",
                      "One_motor_car","Two_motor_cars","Three_motor_cars","Four_or_more_motor_cars","Total_Cars")
  View(df)
  colnames(df)<-c("City","Total_Population","Residing_Population","At_Work_Total","Looking_For_First_Job_Total","Unemployed","Bicycle",	"Bus_minibus_or_coach",	"Motorcycle_or_scooter",
                  "Car_driver","Car_passenger","Van","Other","Before_06_30","T_06_30_07_00","T_07_01_07_30","T_07_31_08_00","T_08_01_08_30","T_08_31_09_00","T_09_01_09_30",
                  "After_09_30","Under_15_mins","T_1_4_hour_under_1_2_hour","T_1_2_hour_under_3_4_hour","T_3_4_hour_under_1_hour",	"T_1_hour_under_1_1_2_hours",	"T_1_1_2_hours_and_over",
                  "One_motor_car","Two_motor_cars","Three_motor_cars","Four_or_more_motor_cars","Total_Cars")
  
  
  #df <- df[,-1]
  tempDf <- df[1,2:ncol(df)] + df[2,2:ncol(df)]
  tempDf$City <- "Galway"
  View(tempDf)
  newDf <- rbind(newDf,tempDf)
  
}
newDf <- newDf[-1,]
View(newDf)

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
needDf$Yeartaken <- c("2011","2012","2013","2014","2015","2016")
needDf$City <- "Galway"
write.csv(needDf, "D:\\NUIG Project Data Set\\Census Data Set\\CleansedData\\CleansedCensusData.csv", row.names = F)
