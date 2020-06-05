########################################
# load libraries
########################################

# load some packages that we'll need
library(tidyverse)
library(scales)
library(lubridate)

# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')


########################################
# plot trip data
########################################

# plot the distribution of trip times across all rides (compare a histogram vs. a density plot)

trips%>% 
  filter (tripduration <= 3600) %>%
  ggplot(aes(x = tripduration)) +
    geom_histogram(bins = 30) + 
    scale_y_continuous(label = comma)

trips%>% 
  filter (tripduration <= 3600) %>%
  ggplot(aes(x = tripduration)) +
    geom_density()

# plot the distribution of trip times by rider type indicated using color and fill (compare a histogram vs. a density plot)

trips%>% 
  filter (tripduration <= 3600) %>%
  ggplot(aes(x = tripduration, fill = usertype, color = usertype)) +
    geom_histogram(bins = 30, position = "identity", alpha = 0.25) +
    scale_y_continuous(label = comma) +
    facet_wrap(~usertype) 


trips%>% 
  filter (tripduration <= 3600) %>%
  ggplot(aes(x = tripduration, fill = usertype, color = usertype)) +
    geom_density(position = "identity", alpha = 0.25) + 
    scale_y_continuous(label = comma) +
    facet_wrap(~usertype, scales = "free_y" )


# plot the total number of trips on each day in the dataset

trips %>% 
  group_by(ymd) %>%
  summarize(count = n()) %>%
  ggplot(aes(x = ymd, y =count)) +
    geom_line()

# plot the total number of trips (on the y axis) by age (on the x axis) and gender (indicated with color)

trips %>% 
  mutate(age = year(ymd) - birth_year) %>%
  group_by(age, gender) %>%
  summarize(count = n()) %>%
  ggplot(aes(x = age, y = count, color = gender)) +
    geom_point() + 
    scale_y_continuous(labels = comma, limits = c(0,250000))
    

# plot the ratio of male to female trips (on the y axis) by age (on the x axis)
# hint: use the spread()(pivot_wider()) function to reshape things to make it easier to compute this ratio
# (you can skip this and come back to it tomorrow if we haven't covered spread() yet)

trips %>% 
  mutate(age = year(ymd) - birth_year) %>%
  group_by(age, gender) %>%
  summarize(count = n()) %>%
  pivot_wider(names_from = gender, values_from = count) %>%
  ggplot(aes(x = age, y = Male/Female)) +
    geom_point() +
    scale_y_continuous(labels = comma)


########################################
# plot weather data
########################################
# plot the minimum temperature (on the y axis) over each day (on the x axis)

weather %>% 
  ggplot(aes(x = ymd, y = tmin)) +
    geom_line(color = 'red')

# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis)
# hint: try using the gather() (pivot_longer())function for this to reshape things before plotting
# (you can skip this and come back to it tomorrow if we haven't covered gather() yet)

weather %>% 
  pivot_longer(c(tmax, tmin), names_to = "temp_ind", values_to = "temp_value") %>%
  ggplot(aes(x = ymd, y = temp_value, color = temp_ind)) +
  geom_line()


########################################
# plot trip and weather data
########################################

# join trips and weather
trips_with_weather <- inner_join(trips, weather, by="ymd")

# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this

trips_with_weather %>% 
  group_by(tmin, ymd) %>%
  summarize(count = n()) %>%
  ggplot(aes(x=tmin, y = count)) +
  geom_point(color = "red")


# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this

trips_with_weather %>% 
  mutate(substantial_precip = ifelse(prcp > 0.5, TRUE, FALSE)) %>%
  group_by(tmin, ymd, substantial_precip) %>%
  summarize(count = n()) %>%
  ggplot(aes(x=tmin, y = count, color = substantial_precip )) +
    geom_line()
  
  
# add a smoothed fit on top of the previous plot, using geom_smooth


trips_with_weather %>% 
  mutate(substantial_precip = ifelse(prcp > 0.5, TRUE, FALSE)) %>%
  group_by(tmin, ymd, substantial_precip) %>%
  summarize(count = n()) %>%
  ggplot(aes(x=tmin, y = count, color = substantial_precip )) +
  geom_line() +
  geom_smooth()


# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
# plot the above

trips_with_weather %>% 
  mutate(hour_of_day = hour(starttime)) %>%
  group_by(hour_of_day, ymd) %>% 
  summarize(count = n()) %>%
  group_by(hour_of_day) %>%
  summarize(mean = mean(count), sd = sd(count)) %>%
  ggplot() +
    geom_line(aes(x= hour_of_day, y = mean), color = "red") +
    geom_ribbon(aes(x = hour_of_day, ymin = mean - sd, ymax = mean + sd), alpha = 0.25)

# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package

# by days of week: 
trips_with_weather %>% 
  mutate(hour_of_day = hour(starttime), day = wday(ymd, label = TRUE)) %>%
  group_by(hour_of_day, day, ymd) %>% 
  summarize(count = n()) %>%
  group_by(hour_of_day, day) %>%
  summarize(mean = mean(count), sd = sd(count)) %>%
  ggplot() +
  geom_line(aes(x= hour_of_day, y = mean), color = "red") +
  geom_ribbon(aes(x = hour_of_day, ymin = mean - sd, ymax = mean + sd), alpha = 0.25) +
  facet_wrap(~day) +
  labs(y = "average number of riders")

# by weekday vs weekend: 
trips_with_weather %>% 
  mutate(hour_of_day = hour(starttime), day = wday(ymd, label = TRUE))%>%
  mutate(day = ifelse(day == "Sun" | day == "Sat", "weekend", "weekday")) %>%
  group_by(hour_of_day, day, ymd) %>% 
  summarize(count = n()) %>%
  group_by(hour_of_day, day) %>%
  summarize(mean = mean(count), sd = sd(count)) %>%
  ggplot() +
  geom_line(aes(x= hour_of_day, y = mean), color = "red") +
  geom_ribbon(aes(x = hour_of_day, ymin = mean - sd, ymax = mean + sd), alpha = 0.25) +
  facet_wrap(~day) +
  labs(y = "average number of riders")
