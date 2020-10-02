library(nycflights13)
library(tidyverse)

view(head(flights, 10))


## 5.2. EXERCISES 

# 1. Find all flights that

# A) Had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)

# B) Flew to Houston (IAH or HOU)
filter(flights, dest == "IAH" | dest == "HOU")

# or also correct
filter(flights, dest %in% c("IAH", "HOU"))

# C) Were operated by United, American, or Delta
filter(flights, carrier == "UA" | carrier == "DL" | carrier == "AA")

# or also correct
filter(flights, carrier %in% c("UA", "DL", "AA"))

# D) Departed in summer (July, August, and September)
filter(flights, month >= 7, month <= 9)

# E) Arrived more than two hours late, but didn’t leave late
filter(flights, dep_delay <= 0, arr_delay > 120)

# F) Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60, arr_delay < dep_delay - 30)

# G) Departed between midnight and 6am (inclusive)
filter(flights, hour >= 0, hour <= 6)



# 2. Another useful dplyr filtering helper is between(). What does it do? Can you use it to 
# simplify the code needed to answer the previous challenges?

# between() is a shortcut for x >= left & x <= right,

# D) Departed in summer (July, August, and September)
filter(flights, between(month, 7, 9))

# G) Departed between midnight and 6am (inclusive)
filter(flights, between(hour, 0, 6))

# 3. How many flights have a missing dep_time? What other variables are missing? What might these 
# rows represent?
filter(flights, is.na(dep_time)) # 8245 flight don't have a dep_time
# Since tey don't have dep_delay, arr_time, arr_delay we could think that they're cancelled flights

# 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? 
# Can you figure out the general rule? (NA * 0 is a tricky counterexample!)

# Any number ^0 is equal to 1. Same is NA
# NA | TRUE could be either NA or TRUE so in this case the condition is evaluated as TRUE
# FALSE & NA evaluates as FALSE so it's not NA

### --------------------------------------------------------------
# 5.3 ARRANGE ROWS WITH ARRANGE()
# --------------------------------------------

# 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
arrange(flights, desc(is.na(dep_time)), dep_time)


# 2. Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(arr_delay))

view(arrange(flights, hour, minute))

# 3. Sort flights to find the fastest (highest speed) flights.
arrange(flights, desc(distance/air_time))

# 4. Which flights travelled the farthest? Which travelled the shortest?
arrange(flights, desc (distance))
arrange(flights, distance)




