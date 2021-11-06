####################################################################################
# 1) Load the price index .csv file attached via this assignment.                  #
####################################################################################

# set working directory
setwd("D:/대학원/2021-2/1. 수업/R 물류 데이터 분석/3. 과제/Assignment_3_KimKyungA")

# read data set
data <- read.csv("food-price-index-September-2021-index-numbers-csv-tables.csv")

# check data briefly
head(data,3)
tail(data,3)

str(data)
summary(data)

# check NA values
sum(is.na(data))
colSums(is.na(data))

# remove NA values
good <- complete.cases(data)
data1 <- data[good,]

head(data1,3)

# check NA values again
sum(is.na(data1))
colSums(is.na(data1))

##########################################################################################################
# 2) Use 4 methods that you learned in the last two sessions to manipulate the dataset,                  #
#    write the code,                                                                                     #
#    put a note (#comment) in front of code lines to explain what you have done in your coding manners.  #
#    (you need to use 4 different libraries related to pre-processing the dataset)                       #
##########################################################################################################

### ordering data with plyr library
library(plyr)
arrange(data1, Period)
head(arrange(data1, Period), 30)
tail(arrange(data1, Period), 30)

### cutting data with Hmisc library
library(Hmisc)
# use "Data_value" column, cut the data into 4 groups and look at how many rows are included in each group by using table function
data1$price_groups <- cut2(data1$Data_value, g=4)
table(data1$price_groups)
# use "Period" column,cut the data into 4 groups and look at how many rows are included in each group by using table function
data1$PeriodGroups <- cut2(data1$Period, g=6)
table(data1$PeriodGroups)
# use mutate fuction 
data2 <- mutate(data, PeriodGroups=cut2(Period, g=4))
table(data2$PeriodGroups)

# subsetting data which period is only "2010.11"
table(data1$Period %in% c("2010.11"))
data[data1$Period %in% c("2010.11"),]

### melting data with reshape2 library
library(reshape2)
dataMelt <- melt(data, id=c("Period", "Series_title_1"), measure.vars=c("Data_value"))
head(dataMelt)
tail(dataMelt)

### add new column with dplyr library (change dollar into koran won)
library(dplyr)
mutate(data1, KOR_won=Data_value*1186.50)
data2 <- mutate(data1, KOR_won=Data_value*1186.50)
head(data2,5)

# change data into data table form
library(data.table)
data3 <- data.table(data2)
data3
tables()
data3[c(1,2), c(2)]
head(data3[, c(2,3,8,11)])

data4 <- data.frame(data3[, c(2,3,8,11)])
head(data4)

############################################################################################
# 3) Use the factor function for column "Series_title_1"                                   #
#    and get the average for each product using the price values in column "Data_value"    #
#    by sapply function                                                                    #
############################################################################################

# creating factor variable
data2$Series_title_2 <- factor(data2$Series_title_1)
data2$Series_title_3 <- c(as.factor(data2$Series_title_1))

# check data set (factor function and as.factor have same result)
str(data2)

# (1) using split, sapply funciton
data5 <- split(data2$Data_value, data2$Series_title_2)
data5
sapply(data5, mean)

# (2) using melt, cast function
library(reshape2)

dataMelt <- melt(data2, id=c("Series_title_2"), measure.vars=c("Data_value"))
head(dataMelt,3)

average_dataMelt <- dcast(dataMelt, Series_title_2~variable, mean)
average_dataMelt






