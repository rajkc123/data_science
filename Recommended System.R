library(tidyverse)
library(dplyr)
library(scales)
library(ggrepel)


#------House Price Ranking-------#

#Importing cleaned population data
cleaned_population_data = read_csv("Cleaned Data/Cleaned Population.csv")
cleaned_population_data<- cleaned_population_data %>% 
  select(`Short Postcode`, Town, District, Country)

#Importing cleaned house price data
cleaned_houseprices = read_csv("Cleaned Data/Cleaned House Prices.csv")

ranking_houseprices= cleaned_houseprices %>% 
  filter(`Date of Transfer`=="2020") %>% 
  group_by(`Town/City`) %>% 
  summarise(Price=mean(Price),County=first(County)) %>% #reducing the table by merging multiple same towns that belong to the same county
  arrange(Price) %>% 
  mutate(HouseScore=10-(Price/100000)) %>%  #calculating score. We are subtracting from 10 because lower house prices need to have higher rank
  select(`Town/City`,County, HouseScore)

#defining path to save the house ranking csv
file_path <- "Recommended System/House Pricing Ranks.csv"

#saving the cleaned dataset
write.csv(ranking_houseprices, file_path, row.names = FALSE)
