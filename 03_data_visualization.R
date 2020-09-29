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






