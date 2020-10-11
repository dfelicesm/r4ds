library(tidyverse)
library(nycflights13)

# 7.3 VARIATION

# 1. Explore the distribution of each of the x, y, and z variables in diamonds. What do you learn? 
# Think about a diamond and how you might decide which dimension is the length, width, and depth.
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = x))

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = y))

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = z))

# Explore the distribution of price. Do you discover anything unusual or surprising? (Hint: 
# Carefully think about the binwidth and make sure you try a wide range of values.)
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price))

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price),
                 binwidth = 5)
view(diamonds %>% 
  count(cut_width(price, 100)) )

summary(diamonds$price)

# There are many many diamonds sold for 500-1000$
# It's strange that there are not many just below $1500


# 3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the 
# difference?
diamonds %>% filter(between(carat, 0.99, 1)) %>%
  count(carat)

# There are 23 of .99 vs 1558 of 1. If carat is the weight of the diamond, my guess is that it is 
# easier to sell a diamond with a "round" weight

# 4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram. What 
# happens if you leave binwidth unset? What happens if you try and zoom so only half a bar shows?


ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price),
                 binwidth = 50) +
  coord_cartesian(xlim = c(100, 5000))

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price),
                 binwidth = 50) +
  xlim(c(100, 5000))

#xlim cuts everything outside that range. coord_cartesian just does a zoom

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price))
# if you don't specify binwidth, ggplot generates 30 bins



###################################################################################################
# 7.4 MISSING VALUES
###################################################################################################

# 1. What happens to missing values in a histogram? What happens to missing values in a bar chart? 
# Why is there a difference?
flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    hour = dep_time %/% 100,
    min = dep_time %% 100,
    dep_time = hour + min / 60
  ) %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = dep_time),
                 binwidth = 1)

select_if(flights, is_character) %>% 
  mutate(no_plane = ifelse(is.na(tailnum), NA, "Known plane")) %>%
  ggplot() +
  geom_bar(mapping = aes(x = no_plane))
# the histogram is calculatd without the missing values and the bar char believes NA is a category

# What does na.rm = TRUE do in mean() and sum()?

# that missing values will not be taken into account to calculate mean and sum

###################################################################################################
# 7.4 MISSING VALUES
###################################################################################################

# 1. Use what you’ve learned to improve the visualisation of the departure times of cancelled vs. 
# non-cancelled flights.
flights %>% 
  mutate(cancelled = is.na(dep_time) & is.na(arr_time)) %>%
  ggplot() + 
  geom_boxplot(mapping = aes(x = cancelled, y = hour))

flights %>% 
  mutate(cancelled = is.na(dep_time) & is.na(arr_time)) %>%
  ggplot() + 
  geom_freqpoly(mapping = aes(x = hour, y = ..density.., color = cancelled),
                binwidth = 1) # it can be seen clearly that among those flights that are cancelled
                       # a big proportion happens during the second part of the day


flights %>% 
  mutate(cancelled = is.na(dep_time) & is.na(arr_time)) %>%
  ggplot() + 
  geom_freqpoly(mapping = aes(x = hour, color = cancelled),
                binwidth = 1)







