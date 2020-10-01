# EXERCISES

# 1. Why does this code not work?

my_variable <- 10
my_varıable
#> Error in eval(expr, envir, enclos): object 'my_varıable' not found

# There is a typing error when calling my_variable

# 2. Tweak each of the following R commands so that they run correctly:

library(tidyverse)

ggplot(data = mpg) + # data replaces "dota"
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8) #filter replaces "fliter", == replaces =
filter(diamonds, carat > 3) # missing a s in diamondS

# 3. Press Alt + Shift + K. What happens? How can you get to the same place using the menus?

# It shows RStudio shortcuts. We can also access them in the tab "Tools".