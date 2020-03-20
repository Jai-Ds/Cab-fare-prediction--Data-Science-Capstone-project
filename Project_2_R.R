#Load Libraries
x = c("ggplot2", "corrgram", "DMwR", "caret", "randomForest", "unbalanced", "C50", "dummies", "e1071", "Information",
      "MASS", "rpart", "gbm", "ROSE", 'sampling', 'DataCombine', 'inTrees')

#install.packages(x)
#install.packages("lubridate")
#install.packages("geosphere")

rm()
lapply(x, require, character.only = TRUE)
rm(x)
library("corrplot")

rm(list=ls())
setwd("C:/Users/Jayandran/Documents/Edwisor Questions/Project2")
getwd()
#Extracting the excel 
df_cab=read.csv("train_cab.csv",header=TRUE)

#Dealing Missing values
sum(is.na(df_cab))
#[1] 55
df_cab=na.omit(df_cab)

str(df_cab)

df_cab$fare_amount=as.numeric(as.character(df_cab$fare_amount))

#Resetting rows
rownames(df_cab) <- seq(length=nrow(df_cab))

#Feature Engineering
df_cab$pickup_datetime=sub("UTC","",df_cab$pickup_datetime)
library(lubridate)

df_cab$Month=month(ymd_hms(df_cab$pickup_datetime))
df_cab=df_cab[-c(which(is.na(df_cab$Month))),]
df_cab$Year=year(ymd_hms(df_cab$pickup_datetime))
df_cab$Time_in_Hrs=hour(ymd_hms(df_cab$pickup_datetime))   
df_cab$Day=wday(ymd_hms(df_cab$pickup_datetime), label = TRUE, abbr = TRUE)
df_cab$Day_Night='D'
df_cab$Day_Night[df_cab$Time_in_Hrs >=5 & df_cab$Time_in_Hrs <18]="Day"
df_cab$Day_Night[which(df_cab$Day_Night=='D')]="Night"



#Outlier Analysis

df_cab=df_cab[which(df_cab$passenger_count > 0),]
df_cab=df_cab[which(df_cab$passenger_count <=6),]
df_cab=df_cab[which(df_cab$pickup_latitude <45),]

numeric_index=sapply(df_cab,is.numeric)
numeric_data=df_cab[,numeric_index]
cnames=colnames(numeric_data)
cnames

#Boxplot
for(i in 1:length(cnames))
{
  assign(paste0("gn",i), ggplot(aes_string(y = (cnames[i]),), data = subset(df_cab))+ 
           stat_boxplot(geom = "errorbar", width = 0.5) +
           geom_boxplot(outlier.colour="red", fill = "grey" ,outlier.shape=18,
                        outlier.size=1, notch=FALSE) +
           theme(legend.position="bottom")+
           labs(y=cnames[i])+
           ggtitle(paste("Box plot of Card use type for",cnames[i])))
}


#Plotting plots together
gridExtra::grid.arrange(gn1)
gridExtra::grid.arrange(gn2)
gridExtra::grid.arrange(gn3)
gridExtra::grid.arrange(gn4)
gridExtra::grid.arrange(gn5)
gridExtra::grid.arrange(gn6)
gridExtra::grid.arrange(gn7)
gridExtra::grid.arrange(gn8)
gridExtra::grid.arrange(gn9)

outlier_col=list('pickup_longitude','dropoff_longitude','dropoff_latitude','fare_amount')

 for(i in outlier_col){
   print(i)
   val = df_cab[,i][df_cab[,i] %in% boxplot.stats(df_cab[,i])$out]
   print(length(val))
   df_cab = df_cab[which(!df_cab[,i] %in% val),]
 }

df_cab=df_cab[which(df_cab$pickup_latitude>40),]
#Resetting rows
rownames(df_cab) <- seq(length=nrow(df_cab))
df_cab$passenger_count=round(df_cab$passenger_count)
str(df_cab)
df_cab=df_cab[which(df_cab$passenger_count > 0),]


#Deriving Distance Column
library(geosphere)
df_cab$Distance_Km=0

for (i in 1: nrow(df_cab)){
  d=distm(c(df_cab$pickup_longitude[i], df_cab$pickup_latitude[i]), c(df_cab$dropoff_longitude[i], df_cab$dropoff_latitude[i]), fun = distHaversine)/1000
  df_cab$Distance_Km[i]=d
}

df_cab=df_cab[which(df_cab$fare_amount > 0),]

sum(is.na(df_cab$fare_amount))

#Converting Variables to appropriate data types
str(df_cab)
df_cab$passenger_count=as.factor(df_cab$passenger_count)
df_cab$Month=as.factor(df_cab$Month)
df_cab$Year=as.factor(df_cab$Year)
df_cab$Day=as.character.factor(df_cab$Day)
df_cab$Day_Night=as.factor(df_cab$Day_Night)
df_cab$Day=as.factor(df_cab$Day)


#Correlation Analysis
numeric_index=sapply(df_cab,is.numeric)
numeric_index
corrgram(df_cab[,numeric_index],order=F,upper.panel=panel.pie,text.panel=panel.txt,main="Correlation Plot")

df_cab_original=df_cab

#Dimensionality Reduction
df_cab=subset(df_cab,select=-c(pickup_datetime,pickup_longitude,pickup_latitude,dropoff_longitude,dropoff_latitude))
df_cab=subset(df_cab,select=-c(Time_in_Hrs))

#Creating Dummies for Factor Var
library(dummies)
#install.packages("dummies")
df_cab <- dummy.data.frame(df_cab, sep = ".")

#Decision Tree regressor

#Divide the data into train and test
#set.seed(123)
train_index = sample(1:nrow(df_cab), 0.9 * nrow(df_cab))
train = df_cab[train_index,]
test = df_cab[-train_index,]

# ##rpart for regression
fit = rpart(fare_amount ~ ., data = train, method = "anova")

#Predict for new test cases
predictions_DT = predict(fit, test[,-1])


#MAPE
#calculate MAPE
MAPE = function(y, yhat){
   mean(abs((y - yhat)/y))
}

MAPE(test[,1], predictions_DT)
##Error Rate:  0.2030523

#Linear Regression

#run regression model
lm_model = lm(fare_amount ~., data = train)

#Summary of the model
summary(lm_model)

#Predict
predictions_LR = predict(lm_model, test[,-1])

#Calculate MAPE
MAPE(test[,1], predictions_LR)

#Error Rate: 18.2

##KNN Implementation
library(class
pr = knn(train,test,cl=train$fare_amount,k=8)
pr=as.numeric(as.character(pr))

#Calculate MAPE
MAPE(test[,1], pr)
#Error rate=[1] 0.03004575 when k=8

library('randomForest')
#install.packages("randomForest")  
#Random Forest Regressor
rand_reg = randomForest(fare_amount ~ ., data=df_cab,ntree=5)

#Predict
predictions_rand_reg = predict(rand_reg, test[,-1])

#Calculate MAPE
MAPE(test[,1], predictions_rand_reg)
#Error rate= 0.1117714

#Choosing Lr and Random forest for predicting Test data set

#Extracting data set
df_test=read.csv("test.csv",header=TRUE)
df_tes=read.csv("test.csv",header=TRUE)

#Feature Engineerig for test data
df_test$pickup_datetime=sub("UTC","",df_test$pickup_datetime)

df_test$Month=month(ymd_hms(df_test$pickup_datetime))
#df_test=df_test[-c(which(is.na(df_test$Month))),]
df_test$Year=year(ymd_hms(df_test$pickup_datetime))
df_test$Time_in_Hrs=hour(ymd_hms(df_test$pickup_datetime))   
df_test$Day=wday(ymd_hms(df_test$pickup_datetime), label = TRUE, abbr = TRUE)
df_test$Day_Night='D'
df_test$Day_Night[df_test$Time_in_Hrs >=5 & df_test$Time_in_Hrs <18]="Day"
df_test$Day_Night[which(df_test$Day_Night=='D')]="Night"

df_test$Distance_Km=0

for (i in 1: nrow(df_test)){
   d=distm(c(df_test$pickup_longitude[i], df_test$pickup_latitude[i]), c(df_test$dropoff_longitude[i], df_test$dropoff_latitude[i]), fun = distHaversine)/1000
   df_test$Distance_Km[i]=d
}

df_test$passenger_count=as.factor(df_test$passenger_count)
df_test$Month=as.factor(df_test$Month)
df_test$Year=as.factor(df_test$Year)
df_test$Day=as.character.factor(df_test$Day)
df_test$Day_Night=as.factor(df_test$Day_Night)
df_test$Day=as.factor(df_test$Day)


#Dimensionality Reduction
df_test=subset(df_test,select=-c(pickup_datetime,pickup_longitude,pickup_latitude,dropoff_longitude,dropoff_latitude))
df_test=subset(df_test,select=-c(Time_in_Hrs))

#Creating Dummies for Factor Var

df_test <- dummy.data.frame(df_test, sep = ".")

#Predicing using random faorest and Linear regr.
#Lr prediction
predictions_LR_test = predict(lm_model, df_test)

str(df_test)

predictions_rand_reg_test = predict(rand_reg, df_test)

df_test$fare_amount=predictions_rand_reg_test

df_tes$Distance_Km=df_test$Distance_Km
df_tes$fare_amount=predictions_rand_reg_test
df_tes$fare_amount_lr=predictions_LR_test


write.csv(df_test,"Detailed_with_fare_amount_R.csv",row.names = F)
write.csv(df_tes,"Original_with_fare_amount&Dist_R.csv",row.names = F)
