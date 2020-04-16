# Cab-fare-prediction--Data-Science-Capstone-project
Requirement is to apply analytics for fare prediction using historical data from the pilot project

Please refer the Project Report_Cab_Rental for detailed explanation of the project.

Train Data-

With following variables

pickup_datetime

pickup_longitude

pickup_latitude

dropoff_longitude

dropoff_latitude

passenger_count

Test-Data => Test data requiring fare prediction

Original_with_fare&Dist_python.csv => Python predictions

Original_with_fare_amount&Dist_R.csv => R predictions

Project Report_Cab_Rental => Project report detailing the work done with visualisations.

Project_2.ipynb => Pyhton code in jupyter notebook

Project_2_R => R code


Missing Value Analysis

fare_amount            24

pickup_datetime        0

pickup_longitude       0

pickup_latitude        0

dropoff_longitude      0

dropoff_latitude       0

passenger_count        55


Total- 79 missing values. As it had a small percentage omitted the missing values.


Feature Engineering

Variables Month,Year,Time(Hrs), Day, Day/Night was derived from pickup_datetime variable.

Month- Month of the cab rental.

Year- Year of the cab rental.

Time- Time of the cab rental.

Day- To classify weekday or weekend cab rental.

Day/Night- To classify whether the cab rental was carried on Sunlight/Moonlight.

Using pickup_longitude, pickup_latitude, dropoff_longitude, dropoff_latitude varibales, Distance_Km was derived.

Distance_Km- Distance travelled in KM.


Outlier Analysis

passenger_count was kept under 6 and greater than 0.

fare_amount greater than 0 was taken.

Distance_Km greater than 0 was taken.

Boxplot outliers of the following variables 'pickup_longitude','dropoff_longitude','dropoff_latitude','fare_amount' was carried on.

Converted the Variables to appropriate datatypes

passenger_count, Month, Year, Day, Day/Night variables are converted into factor variables and other variables were kept in numeric. 

Dimensionality Reduction

From the heat map analysis, the following variables are omitted.

'pickup_datetime','pickup_longitude','pickup_latitude','dropoff_longitude','dropoff_latitude’ as they didn’t contribute much information 
and has some collinearity with other variables.
 
From the above graph the Time in Hrs doesn’t have any peak hours as the the fare amount is equally distributed. Also, we have another 

factor variable ‘Day/Night’ which gives us the info of sunlight and moonlight travel. Hence omitted the Time in Hrs variable.

Creating Dummy Variables (One Hot Encoding)

Created dummy variables for the following factor variables for better analysis.

'Month','Year','Day','Day/Night','passenger_count'.

From the error percentage of above analysis, LR model was applied on test.csv in python and Random Forest was applied on test.csv in R as they had the best accuracy respectively.

Please refer the Project Report_Cab_Rental for detailed explanation of the project.
