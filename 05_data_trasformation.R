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


### --------------------------------------------------------------
# 5.4 SELECT COLUMNS WITH SELECT()
# --------------------------------------------

# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay 
# from flights.
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, "dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, 4, 6, 7, 9) # not recommended since variables can change position
select(flights, starts_with("dep"), starts_with("arr"))
select(flights, one_of(c("dep_time", "dep_delay", "arr_time", "arr_delay")))

# 2. What happens if you include the name of a variable multiple times in a select() call?
select(flights, dep_time, dep_delay, dep_time) # it only takes into account the first time 

# 3. What does the one_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars)) # It selects a column if it is "one_of" the variables in the vector

# Does the result of running the following code surprise you? How do the select helpers deal 
# with case by default? How can you change that default?
select(flights, contains("TIME")) #it selects everything that contains "time" it isn't case 
                        # sensitive by default

select(flights, contains("TIME", ignore.case = FALSE)) # now it's case sensitive

### --------------------------------------------------------------
# 5.5 ADD NEW COLUMNS WITH MUTATE()
# --------------------------------------------

flights_sml <- select(flights, 
                      year:day, 
                      contains("time"),
                      ends_with("delay"), 
                      distance)
                      
                      

# 1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with 
# because they’re not really continuous numbers. Convert them to a more convenient representation 
# of number of minutes since midnight.
mutate(flights_sml,
       dep_time_minutes = (dep_time %/% 100) * 60 + dep_time %% 100,
       sched_dep_time_minutes = (sched_dep_time %/% 100) * 60 + sched_dep_time %% 100) 

# 2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What 
# do you need to do to fix it?

flights %>% mutate(time_diff = arr_time - dep_time) %>%
  select(air_time, 
         time_diff, 
         sched_dep_time, 
         dep_time, dep_delay, 
         sched_arr_time, 
         arr_time, 
         arr_delay)

# I'd expect air_time and time_diff to be the same but they're not. Maybe some time zone issue??


# 3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers 
# to be related?
select(flights, dep_time, sched_dep_time, dep_delay)

# this columns should they be correct, dep_time should be equal to sched_dep_time + dep_delay
flights %>% 
  select(dep_time, sched_dep_time, dep_delay) %>%
  mutate(dep_time_minutes = (dep_time %/% 100) * 60 + dep_time %% 100,
         sched_dep_time_minutes = (sched_dep_time %/% 100) * 60 + sched_dep_time %% 100,
         verification_column = dep_time_minutes == sched_dep_time_minutes + dep_delay) %>% # all should be TRUE 
  filter(verification_column != TRUE)
  
# However this relation is not true because when a flight is delayed from one day to the next one
# the calculation is not right anymore due to how the columns are stored

# 4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? 
# Carefully read the documentation for min_rank()
?min_rank

flights %>% mutate(most_delayed = min_rank(desc(dep_delay))) %>%
  select(dep_delay, most_delayed) %>%
  arrange(most_delayed)

# 5. What does 1:3 + 1:10 return? Why?
1:3 + 1:10

# it returns [1]  2  4  6  5  7  9  8 10 12 11
# it "recycles" the shorter vector [1, 2, 3] to sum it to [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# it is the same as 
c(1+1, 2+2, 3+3, 1+4, 2+5, 3+6, 1+7, 2+8, 3+9, 1+10)

# 6. What trigonometric functions does R provide?
cos(x)
sin(x)
tan(x)

acos(x)
asin(x)
atan(x)
atan2(y, x)

cospi(x)
sinpi(x)
tanpi(x)
  
### --------------------------------------------------------------
# 5.5 MUTATE COLUMNS WITH MUTATE()
# --------------------------------------------

# 1. Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of 
# flights. Consider the following scenarios:

# A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
flights %>% group_by(flight) %>%
  mutate(early = arr_delay <= - 15,
         late = arr_delay >= 15) %>% 
  summarise(early_prop = mean(early, na.rm = TRUE), 
            late_prop = mean(late, na.rm = TRUE)) %>%
  filter(early_prop >= 0.5, late_prop >= 0.5) 

# A flight is always 10 minutes late.
flights %>% group_by(flight) %>%
  summarise(late_prop = mean(arr_delay >= 10, na.rm = TRUE)) %>%
  filter(late_prop == 1)

# A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
flights %>% group_by(flight) %>%
  summarise(early_prop = mean(arr_delay <= -30, na.rm = TRUE),
            late_prop = mean(arr_delay >= 30, na.rm = TRUE)) %>%
  filter(early_prop >= 0.5, late_prop >= 0.5)

# 99% of the time a flight is on time. 1% of the time it’s 2 hours late.
flights %>% group_by(flight) %>%
  summarise(on_time = mean(arr_delay == 0, na.rm = TRUE),
            very_late = mean(arr_delay >= 2, na.rm = TRUE),
            count = n()) %>%
  filter(on_time >= 0.99,
         very_late >= 0.01) 

# Which is more important: arrival delay or departure delay?
  
  

#2. Come up with another approach that will give you the same output as 
# not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) 
# (without using count()).
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% group_by(dest) %>%
  summarise(n())

not_cancelled %>% group_by(tailnum) %>%
  summarise(distance = sum(distance))

# 3. Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is slightly 
# suboptimal. Why? Which is the most important column?

# I would've done this myself
cancelled_2 <- filter(flights, is.na(dep_time) , is.na(arr_time))

# 4. Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of 
# cancelled flights related to the average delay?
flights %>% group_by(year, month, day) %>%
  mutate(cancelled = is.na(dep_time) & is.na(arr_time)) %>%
  summarise(mean_delay = mean(arr_delay, na.rm = TRUE),
            cancelation_prop = mean(cancelled, na.rm = TRUE),
            cancelation_count = sum(cancelled)) %>%
  filter(cancelation_prop < 0.5) %>%
  ggplot(mapping = aes(x = cancelation_prop, y = mean_delay)) +
  geom_point() + 
  geom_smooth(se = FALSE)
# If we remove the outliers in the far right, we can see that the cancellation rate is very 
# correlated with average delay of a plane. Planes with high cancelation rate are very often 
# significantly late

# 5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports 
# vs. bad carriers? Why/why not? 
#(Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

flights %>% group_by(carrier) %>%
  summarise(average_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(average_delay))

# F9 and FL were late by an average of 21.9 and 20.1 respectively

flights %>% group_by(dest) %>%
  summarise(average_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(average_delay))

save <- flights %>% group_by(carrier, dest) %>% 
  summarise(average_delay = mean(arr_delay, na.rm = TRUE),
            count = n()) %>%
  group_by(carrier) %>%
  mutate(airport_prop = count / sum(count)) %>%
  filter(dest == "CAE" | dest == "TUL" | dest == "OKC" )


# 6. What does the sort argument to count() do. When might you use it?
flights %>% 
  count(dest, sort = TRUE) # sorts the counts in descending order
# can be useful when you want to know the most frequent groups


