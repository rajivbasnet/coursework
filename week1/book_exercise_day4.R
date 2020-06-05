# 3.3.1 Exercises
# 1. What's gone wrong with this code? Why are the points not blue?

# Color should be passed as a different argument than aes.

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy),  color = "blue")

# 2. Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset). How can you see this information when you run mpg

# Categorical: manufacturer, model, trans, drv, fl, class
# Continuous: displ, year, cty, hwy, cyl


# Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for categorical vs. continuous variables?

# Using size for categorical variables makes it confusing to read the graph.
# Color and shape make more sense for representing categorical variables and size for continuous variables.
# However, size should be avoided for variables that have large range and are large in length.




# 3.5.1 Exercises
# 1. What happens if you facet on a continuous variable?

# Using facet on a continuous variable converts it into categorical and plots for each distinct values.


# 4. Take the first faceted plot in this section:

# ggplot(data = mpg) + 
#   geom_point(mapping = aes(x = displ, y = hwy)) + 
#   facet_wrap(~ class, nrow = 2)
# What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?

# Faceting can help us add more categories to the variables we use. 
# Using color without faceting with a lot of variables or a larger dataset can be misleading and confusing.




# 3.6.1 
# 5. What does the se argument to geom_smooth() do?

ggplot(data = mpg, mapping = aes(x = displ, y = cty, colour = drv)) +
  geom_point() +
  geom_smooth(se = TRUE)

# the se argument helps us visualize the standard error

# 6. Will these two graphs look different? Why/why not?
#   
#   
#   ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
#   geom_point() + 
#   geom_smooth()
# 
# ggplot() + 
#   geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
#   geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# Yes, because the data anad mapping arguments are same.




# 3.8.1 Exercises

# 1. What is the problem with this plot? How could you improve it?

# ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
#   geom_point()


# Not all plots are seen.

# Can be improved by adding jitter instead of points.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter(position = position_jitter())


# 2. What parameters to geom_jitter() control the amount of jittering?

# width, height, position

