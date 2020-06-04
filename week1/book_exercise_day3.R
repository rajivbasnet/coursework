# 5.2.4 Exercises

#Find all flights that
#1. Had an arrival delay of two or more hours

flights %>% filter(arr_delay >=120)

#2. Flew to Houston (IAH or HOU)

flights %>% filter(dest == "IAH" | dest == "HOU")

#3. Were operated by United, American, or Delta

flights %>% filter(carrier == "UA" | carrier == "AA" | carrier == "DL")

#4. Departed in summer (July, August, and September)

flights %>% filter(month == 8 | month == 9 | month == 10)

#5. Arrived more than two hours late, but didn't leave late

flights %>% filter(arr_delay >=120 & dep_delay <= 0)

#6. Were delayed by at least an hour, but made up over 30 minutes in flight 

flights %>% filter((arr_delay >=60 | dep_delay >=60) & air_time >=30)

#7. Departed between midnight and 6am (inclusive)

flights %>% filter(dep_time > 0 & dep_time < 600)

#Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general rule? (NA * 0 is a tricky counterexample!)

# "Because anything to the power 0 is 1"
# "Because TRUE is truthy value and | operator returns true if any of the compared attributes are truthy."
# "Because FALSE and anything is falsy."




#5.5.2 Exercises

#2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?

# "The air_time and (arr_time - dep_time) are not same but are expected to be same."

flights %>% 
  mutate(dep = as.integer(dep_time/100)*60 + dep_time%%100, arr = as.integer(arr_time/100)*60 + arr_time%%100) %>% 
  mutate(time_in_air = arr - dep) %>% 
  select(time_in_air, air_time)

# "However, there are still differences possibly because of time delays between different zones."




#5.7.1 Exercises

#3. What time of day should you fly if you want to avoid delays as much as possible?

flights %>% 
  mutate(fly_time = as.integer(dep_time/100)) %>%
  group_by(fly_time) %>% 
  summarize(average_dep_delay = mean(dep_delay)) %>%
  arrange(average_dep_delay)

# 'It appears that the delays can be avoided from 4-8