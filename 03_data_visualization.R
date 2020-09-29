library(tidyverse)

# 3.2 First steps
df <- mpg

# Plot engine size vs efficiency
ggplot(data = df) +
  geom_point(mapping = aes(displ, hwy))
# 3.2 Exercises
# 1. Run ggplot(data = mpg). What do you see?
ggplot(data = df) # an empty plot

# 2. How many rows are in mpg? How many columns?
dim(df) #234 rows, 11 columns

# 3. What does the drv variable describe? 
# the type of drive train, where f = front-wheel drive, r = rear wheel drive, 4 = 4wd

# 4. Make a scatterplot of hwy vs cyl.
ggplot(df) + 
  geom_point(mapping = (aes(x = hwy, y = cyl)))

# 5. What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
ggplot(data = df) +
  geom_point(mapping = aes(x = class, y = drv)) # Two categorical variables, scatter plot doesn't 
                                # do a great job of showing the relationship




