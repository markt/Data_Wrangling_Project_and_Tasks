library(tidyverse)
library(lubridate)

colnames(table2)
colnames(table4a)
colnames(table4b)


# Question 1

# 1a with table2
table2_cases <- table2 %>%
  filter(type == "cases") %>%
  select(count) %>%
  rename(cases = count)

# 1b with table2
table2_population <- table2 %>%
  filter(type == "population") %>%
  select(count) %>%
  rename(population = count)

# 1c with table2
rates <- table2_cases$cases / table2_population$population * 10000

# 1d with table2
table2_rates <- tibble(country = filter(table2,type == "cases")$country,
                       year = filter(table2,type == "cases")$year,
                       rate = rates)
  

# 1a with table4a + table4b
table4_1999_cases <- table4a %>%
  select(`1999`) %>%
  rename(cases = `1999`)

table4_2000_cases <- table4a %>%
  select(`2000`) %>%
  rename(cases = `2000`)

# 1b with table4a + table4b
table4_1999_pops <- table4b %>%
  select(`1999`) %>%
  rename(pops = `1999`)

table4_2000_pops <- table4b %>%
  select(`2000`) %>%
  rename(pops = `2000`)

# 1c with table4a + table4b
rates_1999 <- table4_1999_cases$cases / table4_1999_pops$pops * 10000
rates_2000 <- table4_2000_cases$cases / table4_2000_pops$pops * 10000

# 1d with table4a + table4b
countries = append(table4a$country, table4a$country)
years = c(1999, 1999, 1999, 2000, 2000, 2000)

table4_rates <- tibble(country = countries,
                       year = years,
                       rate = append(rates_1999,rates_2000))

library(ggplot2)

# 2
table4a%>%gather(1999,2000,key="year",value="cases")

# the above code fails because 1999 and 2000 are interpreted as numbers
# we must put ticks around them for it to work

table4a%>%gather(`1999`,`2000`,key="year",value="cases")


library(openair)
library(ggpubr)

library(nycflights13)

# 3a
dates <- make_date(flights$year, flights$month, flights$day)
times <- flights$dep_time
df <- tibble(date = dates, time = times)

plot_month <- function(month){
  ggplot(selectByDate(df, month = month), aes(time)) + 
    geom_density() + 
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank())
}

ggarrange(plot_month(1),plot_month(2),plot_month(3),
          plot_month(4),plot_month(5),plot_month(6),
          plot_month(7),plot_month(8),plot_month(9),
          plot_month(10),plot_month(11),plot_month(12),
          ncol = 3, nrow = 4)

# the distributions of flight times does not change much over the year
# some months have more peaks and valley fluctuations than others but
# are mostly consistent


# 3b

# we calculate the flight delay and compare to the delay in the table
# we filter such that only rows where there is a discrepency are output
flights %>%
  select(dep_time, sched_dep_time, dep_delay) %>%
  mutate(calc_dep_delay = as.numeric(difftime(parse_date_time(dep_time,"HM"),
  parse_date_time(sched_dep_time,"HM"),units = "mins"))) %>%
  filter(dep_delay != calc_dep_delay)

# while most rows are equal, there are clearly some cases where
# there are inconsistencies

  

# 3c

# if a flight has a negative delay it is early, we look for such flights
# and use a binary variable to denote if a flight is early
flights %>%
  select(dep_time, sched_dep_time, dep_delay) %>%
  mutate(early = (dep_delay < 0))

# we find the number of rows that are early
flights %>%
  select(dep_time, sched_dep_time, dep_delay) %>%
  mutate(early = (dep_delay < 0)) %>%
  filter(early)

# then the number of rows that are early and within minutes 20-30/50-60
flights %>%
  select(dep_time, sched_dep_time, dep_delay) %>%
  mutate(early = (dep_delay < 0)) %>%
  mutate(minute = minute(parse_date_time(dep_time,"HM"))) %>%
  mutate(within = (19 < minute & minute < 31) | (49 < minute & minute < 61)) %>%
  filter((early & within))


# more than half of flights that leave early leave within these minutes
(98001/183565)
  
  