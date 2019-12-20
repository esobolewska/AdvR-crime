
# Intro -------------------------------------------------------------------

setwd("~/crimes new")

library(readr)
crime <- read_csv("data/crime_and_incarceration_by_state.csv")
prison <- read_csv("data/prison_custody_by_state.csv")
ucr <- read_csv("data/ucr_by_state.csv")

head(crime)
head(prison)
head(ucr)

str(crime)
str(prison)
str(ucr)

# first analysis ----------------------------------------------------------

library(mapdata)
library(maps)
library(ggmap)

install.packages("spData")
library(spData)

install.packages("sf")
library(sf)

urban_agglomerations <- urban_agglomerations

install.packages("tmap")
library(tmap)
library(magick)

library(spData)
library(sf)

us_states2163 = st_transform(us_states, 2163)
us_states_range = st_bbox(us_states2163)[4] - st_bbox(us_states2163)[2]

us_states_map = tm_shape(us_states2163) +
  tm_polygons() + 
  tm_layout(frame = FALSE)

us_states_map

tm_shape(us_states2163) +
  tm_polygons("total_pop_10")

library(ggplot2)

ucr <- ucr[!is.na(ucr$jurisdiction),]
ucr$year <- as.integer(ucr$year)

p <- ggplot(ucr, aes(x = violent_crime_total, 
                     y = state_population, 
                     colour = as.factor(jurisdiction))) +
  geom_point(show.legend = FALSE, alpha = 0.7) +
  scale_color_viridis_d() +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  labs(x = "Violent crimes total", y = "State population")
p

# install.packages("gganimate")
library("gganimate")

p + transition_time(year) +
  labs(title = "Year: {frame_time}", range=c(2001L,2017L))
