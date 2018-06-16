library(ggplot2)
library(tibble)
library(dplyr)
library(reshape2)
library(scales)
library(leaflet)
library(lubridate)

CensusdataSet <- read.csv("D:\\NUIG Project Data Set\\Census Data Set\\CleansedData\\CleansedCensusData.csv",stringsAsFactors = FALSE)
TrafficdataSet <- read.csv("D:\\NUIG Project Data Set\\Census Data Set\\CleansedData\\CleansedTrafficData.csv",stringsAsFactors = FALSE)

df <- inner_join(CensusdataSet,TrafficdataSet)
View(df)
df <- df %>% select("Yeartaken","City","Total_Population","Residing_Population","At_Work_Total","Looking_For_First_Job_Total","Unemployed","Bicycle",	"Bus_minibus_or_coach",	"Motorcycle_or_scooter",
                    "Car_driver","Car_passenger","Van","Other","Before_06_30","T_06_30_07_00","T_07_01_07_30","T_07_31_08_00","T_08_01_08_30","T_08_31_09_00","T_09_01_09_30",
                    "After_09_30","Under_15_mins","T_1_4_hour_under_1_2_hour","T_1_2_hour_under_3_4_hour","T_3_4_hour_under_1_hour",	"T_1_hour_under_1_1_2_hours",	"T_1_1_2_hours_and_over",
                    "One_motor_car","Two_motor_cars","Three_motor_cars","Four_or_more_motor_cars","Total_Cars",
                    "MeanPeakAmVolume","MeanPeakPmVolume","MeanAADT")
write.csv(df, "D:\\NUIG Project Data Set\\Census Data Set\\CleansedData\\ConsolidatedData.csv", row.names = F)



                    
