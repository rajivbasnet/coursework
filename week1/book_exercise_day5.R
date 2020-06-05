library(tidyverse)

# 12.2.1 Exercises
# 2. Compute the rate for table2, and table4a + table4b. You will need to perform four operations:

# Extract the number of TB cases per country per year.
# Extract the matching population per country per year.
# Divide cases by population, and multiply by 10000.
# Store back in the appropriate place.

table2_with_rate <- table2 %>% pivot_wider(names_from = type, values_from = count) %>% mutate(rate = cases/population * 10000)

table4_cases <- table4a %>% pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

table4_population <- table4b %>% pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

table4 <- left_join(table4_population, table4_cases) %>% pivot_longer(c(population, cases), names_to = "type", values_to = "count")

table4_with_rate <- table4 %>% pivot_wider(names_from = type, values_from = count) %>% mutate(rate = cases/population * 10000)

table2_with_rate %>%
  ggplot(aes(x= year, y = cases)) +
  geom_line(aes(group = country)) +
  geom_point(aes(color = country)) +
  scale_x_continuous(breaks = unique(table2_with_rate$year))


table4_with_rate %>%
  ggplot(aes(x= year, y = cases)) +
  geom_line(aes(group = country)) +
  geom_point(aes(color = country))

# Which representation is easiest to work with? Which is hardest? Why?

#The representation for table2 is easier to work with because table4a and table4b required a lot of operations to be handled.





# 12.3.3 Exercises
# 1. Why are pivot_longer() and pivot_wider() not perfectly symmetrical?
#   Carefully consider the following example:
  stocks <- tibble(
    year   = c(2015, 2015, 2016, 2016),
    half  = c(   1,    2,     1,    2),
    return = c(1.88, 0.59, 0.92, 0.17)
  )

stocks %>%
  pivot_wider(names_from = year, values_from = return) %>%
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")

# (Hint: look at the variable types and think about column names.)

# The variable type for year changes because pivot_wider makes the original column type lost and on doing pivot_longer won't know the original data types. 

# pivot_longer() has a names_ptype argument, e.g. names_ptype = list(year = double()). What does it do?

# ..............................................


# 3. What would happen if you widen this table? Why? How could you add a new column to uniquely identify each value?
people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

#Because for different names unique columns cannot be generated. Adding a new key to identify unique name can fix it.

people %>% group_by(name, names) %>% mutate(id = row_number()) %>% pivot_wider(names_from = names, values_from = values)



