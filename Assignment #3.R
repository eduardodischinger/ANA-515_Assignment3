getwd()
library(tidyverse)

data1 <- read.csv("/Users/eduardodischinger/documents/Mcdaniel/StormEvents_details-ftp_v1.0_d1992_c20220425.csv")

data1
ncol(data1)

data1
str(data1)
head(data1)
colnames(data1)
newdata <-data1[c(1,2,3,4,5,6,7,8,9,10,13,14,15,
                  16,18,20,27,45,46,47,48)]

head(newdata)
#It's already starting 1st column with BEGIN_YEARMONT

library(dplyr)
arrangeddata <- arrange(newdata, BEGIN_YEARMONTH)
head(arrangeddata)

#Changing state and county names

library(stringr)
str_to_title(string = arrangeddata$STATE)
str_to_title(string = arrangeddata$CZ_NAME)

#Limiting Events and Removing Column
limit_data <- filter(arrangeddata, CZ_TYPE=='C')
limit_data <- select(arrangeddata, - c(CZ_TYPE))
head(limit_data)

#One FIPS Column with 5 or 6 digit code
data2 <- str_pad(newdata$STATE_FIPS, width=3, side= "left", pad= "0")
view(data2)
str_pad(newdata$CZ_FIPS, width=3, side= "left", pad= "0")
view(data2)

library(tidyr)
unite(limit_data, flips, STATE_FIPS, CZ_FIPS, sep ="00")

#Change all Column Names to lower_case
rename_all(limit_data, tolower)

#Dataframe US states
data("state")
state_data <- data.frame(state=state.name, region=state.region, area=state.area)
new_data <- data.frame(table(newdata$STATE))
head(new_data)

#Merged Data
new_set<-rename(new_data, c("state"="Var1"))
mergeddata <- merge(x=new_set, y=state_data, by.x = "state", by.y = "state")
head(mergeddata)

newstate_info  <- mutate_all(state_data, toupper)
mergeddata <- merge(x=new_set, y=newstate_info, by.x = "state", by.y = "state")
head(mergeddata)

#Scatterplot
library(ggplot2)
eventplot <- ggplot(mergeddata, aes(x = area, y = Freq)) +
  geom_point(aes(color = region)) +
  labs(x = "Land area(square miles)" , y = "# of storm events in 2017") +
  theme(axis.text.x = element_text(angle = 90, size = 8))
eventplot




