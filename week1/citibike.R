library(tidyverse)
library(lubridate)

########################################
# READ AND TRANSFORM THE DATA
########################################

# read one month of data
trips <- read_csv('201402-citibike-tripdata.csv')

# replace spaces in column names with underscores
names(trips) <- gsub(' ', '_', names(trips))


# convert dates strings to dates
##trips['starttime']
# recode gender as a factor 0->"Unknown", 1->"Male", 2->"Female"
trips <- mutate(trips, gender = factor(gender, levels=c(0,1,2), labels = c("Unknown","Male","Female")))


########################################
# YOUR SOLUTIONS BELOW
########################################

# count the number of trips (= rows in the data frame)
nrow(trips) # = 224736
# find the earliest and latest birth years (see help for max and min to deal with NAs)

trips['birth_year'] %>% 
filter(birth_year != "\\N") %>%
filter(birth_year == min(birth_year)) # = 1899

trips['birth_year'] %>%
filter(birth_year == max(birth_year)) # = 1997

# use filter and grepl to find all trips that either start or end on broadway
filter(trips, grepl('Broadway', 
                    start_station_name, 
                    ignore.case = TRUE) | grepl('Broadway',
                                                end_station_name,
                                                ignore.case = TRUE))
# do the same, but find all trips that both start and end on broadway
filter(trips, grepl('Broadway',
                    start_station_name,
                    ignore.case = TRUE) & grepl('Broadway',
                                                end_station_name, 
                                                ignore.case = TRUE))

# find all unique station names
nrow(summarize(group_by(trips,start_station_name), counts = n())) # =329
# count the number of trips by gender, the average trip time by gender, and the standard deviation in trip time by gender
summarize(group_by(trips,gender),
        average_trip_duration = mean(tripduration),
        std_trip = sd(tripduration))
# do this all at once, by using summarize() with multiple arguments

# find the 10 most frequent station-to-station trips
summarize(group_by(trips,start_station_name,end_station_name),count = n())%>%
        arrange(desc(count))%>%
        head(10)
# find the top 3 end stations for trips starting from each start station
summarize(group_by(trips,start_station_name,end_station_name),count = n())%>%
        arrange(desc(count))%>%
        mutate(rank = row_number()) %>%
        filter(rank <= 3)%>%
        arrange(start_station_name)
# find the top 3 most common station-to-station trips by gender
summarize(group_by(trips,start_station_name,end_station_name,gender),count = n())%>%
        arrange(desc(count))%>%
        group_by(gender)%>%
        mutate(rank = row_number())%>%
        filter(rank <= 3)%>%
        arrange(gender)
# find the day with the most trips
trips %>%
    select(starttime, stoptime) %>%
    mutate(date = floor_date(starttime, unit = "day"))%>%
    group_by(date)%>%
    summarize(counts = n())%>%
    filter(counts == max(counts)) # = 2014-02-02

# tip: first add a column for year/month/day without time of day (use as.Date or floor_date from the lubridate package)

# compute the average number of trips taken during each of the 24 hours of the day across the entire month
trips %>%
    select(starttime, stoptime) %>%
    mutate(hours = hour(starttime))%>%
    group_by(hours)%>%
    summarize(counts = n(),avg_perday_perhr = counts/28)%>%print(n=24,width = Inf)
# what time(s) of day tend to be peak hour(s)?
trips %>%
    select(starttime, stoptime) %>%
    mutate(hours = hour(starttime))%>%
    group_by(hours)%>%
    summarize(counts = n())%>%
    filter(counts == max(counts)) # 17


