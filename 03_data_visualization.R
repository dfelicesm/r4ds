library(tidyverse)

# 3.2 First steps
df <- mpg

# Plot engine size vs efficiency
ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy))
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


# ----------------------------------------------------
# 3.3 AESTHETIC MAPPINGS
# Include class in the engine size vs efficiency plot
ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))


# 3.3.1 Exercises
# 1. What’s gone wrong with this code? Why are the points not blue?
# ggplot(data = mpg) + 
  # geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

# Color is mapped to an aesthetic "blue" inside aes(). Should be outside as in:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), 
             color = "blue")

# 2. Which variables in mpg are categorical? Which variables are continuous? 
# (Hint: type ?mpg to read the documentation for the dataset). How can you see this information 
# when you run mpg?
categorical <- select(df, where(is_character))
ncol(categorical) # 6 categorical variables

# 3. Map a continuous variable to color, size, and shape. How do these aesthetics behave differently 
# for categorical vs. continuous variables?
ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy, color = cyl))

ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl))

ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = cyl)) # a continuous variable 
                                                    # cannot mapped to shape

# 4. What happens if you map the same variable to multiple aesthetics?
# Half of the points are mapped to one aesthetic and half to the other (?)

ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy, color = year, size = year))

# 5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy), 
             stroke = 2,
             shape = 21) # Stroke changes the size of the border for shapes (21-25).


# 6. What happens if you map an aesthetic to something other than a variable name, like 
# aes(colour = displ < 5)? Note, you’ll also need to specify x and y.
# ggplot creates a temporary variable and maps it to the chosen aesthetic
# In this case, it colors the plot in two groups: those > 5 and those <= 5
ggplot(data = df) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5)) 



# ----------------------------------------------------------
# 3.5 FACETS

ggplot(data = df) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = df) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# 3.5.1 Exercises
# 1. What happens if you facet on a continuous variable?

# It's converted to categorical and it creates a plot for every level of the categorical variable
ggplot(data = df) + 
  geom_point(mapping = aes(x = cty, y = hwy)) + 
  facet_wrap(~ displ, nrow = 2)

# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this 
# plot?
# a) There are no observations that belong in that intersection. Ex: 4 cylinders rear drive cars
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl)) # In this plot, it can also be seen that some cyl, 
                                # drv combinations don't have any observation

# 3. What plots does the following code make? What does . do?
# . tells ggplot to not choose any specific variable to do a facet along that axis
ggplot(data = df) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .) # split the scatterplot by drv along the Y-axis

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl) # split the scatterplot by cyl along the x-axis

# 4. Take the first faceted plot in this section:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
# For small number of observations, might be useful to use color since you can compare the position
# among classes. However, if there are many observations, probably facet offers a less crowed view

# 5. Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout 
# of the individual panels? Why doesn’t facet_grid() have nrow and ncol arguments?

# nrow and ncol determine the number of rows and columns of the facet plot

# facet_grid() does not have since the number of rows and cols depends on the nº of levels of the
# chosen variables

# 6. When using facet_grid() you should usually put the variable with more unique levels in the 
# columns. Why?

# There will be more space for columns if the plot is laid out horizontally (landscape).

#######-------------------------------------------------------------
# 3.6 GEOMETRIC OBJECTS

# 1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
geom_line()
geom_boxplot()
geom_histogram()
geom_area()

# 2. Run this code in your head and predict what the output will look like. Then, run the code in 
# R and check your predictions.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

# 3. What does show.legend = FALSE do? What happens if you remove it?
# Why do you think I used it earlier in the chapter?

# It removes the legend that is created automatically for every level of a variable

# 4. What does the se argument to geom_smooth() do?

# It removes the standard deviation plotted around the line that is incorporated by default

# 5. Will these two graphs look different? Why/why not?

# They're both the same, it only changes where the mappings are being made

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# 6. Recreate the R code necessary to generate the following graphs.
ggplot(data = mpg,
       mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 10) +
  geom_smooth(se = FALSE)

ggplot(data = mpg,
       mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 10) +
  geom_smooth(mapping = aes(group = drv),
              se = FALSE)

ggplot(data = mpg,
       mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv),
             size = 10) +
  geom_smooth(se = FALSE)

ggplot(data = mpg,
       mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv),
             size = 10) +
  geom_smooth(mapping = aes(linetype = drv),
              se = FALSE)

ggplot(data = mpg,
       mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(fill = drv),
             size = 10, 
             stroke = 5,
             shape = 21,
             color = "white")


## --------------------------------------------------
# 3.7   STATISTICAL TRANSFORMATIONS

# 1. What is the default geom associated with stat_summary()? How could you rewrite the previous 
# plot to use that geom function instead of the stat function?

ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = cut, y = depth))

# 2. What does geom_col() do? How is it different to geom_bar()?

# geom_bar() provides a count of the number of cases of each group
# geom_col() plots the value of each observation

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = depth))

# 3. Most geoms and stats come in pairs that are almost always used in concert. Read through the 
# documentation and make a list of all the pairs. What do they have in common?

# 4. What variables does stat_smooth() compute? What parameters control its behaviour?

# 5. In our proportion bar chart, we need to set group = 1. Why? In other words what is the 
# problem with these two graphs?

#  If group = 1 is not included, then all the bars in the plot will have the same height, a height 
# of 1. The function geom_bar() assumes that the groups are equal to the x values since the stat computes the counts within the group.
# Add group = 1 --> the proportion every group with respect of total
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))


## ---------------------------------------------------------------
## 3.8 POSITION ADJUSTMENTS

# 1. What is the problem with this plot? How could you improve it?

# We can't see exactly where the density is greater, therefore we can use jitter
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point(position = "jitter")

# 2. What parameters to geom_jitter() control the amount of jittering?

# width and height

# 3. Compare and contrast geom_jitter() with geom_count().
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_count()
# geom_jitter reflects density by adding more points, geom_count does so by drawing bigger points

# 4. What’s the default position adjustment for geom_boxplot()? Create a visualisation of the mpg 
# dataset that demonstrates it
ggplot(data = mpg, mapping = aes(x = drv, y = displ)) + 
  geom_boxplot() # default position = "dodge2"

# -----------------------------------------------------------------------------------
# 3.9 COORDINATE SYSTEMS

# 1. Turn a stacked bar chart into a pie chart using coord_polar()
ggplot(data = mpg) +
  geom_bar(mapping = aes(x = factor(1), fill = drv)) + 
  coord_polar(theta = "y")

# 2. What does labs() do? Read the documentation.

# Modify axis, legend, and plot labels

# 3. What’s the difference between coord_quickmap() and coord_map()?

# Different ways of using maps in ggplot. coord_quickmap works better for smaller areas and 
# preserve straight lines. coord_map() projects an espherical area to 2d plot

# 4. What does the plot below tell you about the relationship between city and highway mpg? Why is 
# coord_fixed() important? What does geom_abline() do?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() + # plots a line with intercept 0 and slope 1, helping to understand the slope of 
  # relation between cty and hwy
  coord_fixed() # fixes the ratio between axis 


