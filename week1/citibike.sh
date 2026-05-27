#!/bin/bash
#
# add your solution after each of the 10 comments below
#

# count the number of unique stations
cat 201402-citibike-tripdata.csv | cut -d, -f 5,9 | grep -v '.*station name' | tr , "\n"| sort | uniq | wc -l # = 329
# count the number of unique bikes
cat 201402-citibike-tripdata.csv | cut -d, -f 12 | grep -v 'bikeid' | sort | uniq | wc -l # = 5699
# count the number of trips per day
cat 201402-citibike-tripdata.csv | cut -d, -f2 | tr , "\n" | grep -v 'starttime' | uniq -w10 -c 
# find the day with the most rides
cat 201402-citibike-tripdata.csv | cut -d, -f2 | tr , "\n" | grep -v 'starttime' | uniq -w10 -c | sort | tail -n1 # = 13816 2014-02-02 00:00:39
# find the day with the fewest rides
cat 201402-citibike-tripdata.csv | cut -d, -f2 | tr , "\n" | grep -v 'starttime' | uniq -w10 -c | sort | head -n1 # = 876 2014-02-13 00:00:39
# find the id of the bike with the most rides
cat 201402-citibike-tripdata.csv | cut -d, -f 12 | grep -v 'bikeid' | sort | uniq -c | sort | tail -n1 # = 130 20837
# count the number of rides by gender and birth year
cat 201402-citibike-tripdata.csv | cut -d, -f14,15 | grep -v 'birth.*' | sort | uniq -c
# count the number of trips that start on cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)
cat 201402-citibike-tripdata.csv | cut -d, -f5 | grep -v 'start.*' | grep '[0-9].*&.*[0-9]' | wc -l # = 90549

# compute the average trip duration
awk -F, 'BEGIN {a;b} {a=$1+a}{b=b+1} END {print a/b}' 201402-citibike-tripdata.csv # = 874.516