
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

# install.packages("spData")
library(spData)

# install.packages("sf")
library(sf)

urban_agglomerations <- urban_agglomerations

# install.packages("tmap")
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

bubbles <- p + transition_time(year) +
  labs(title = "Year: {frame_time}", range=c(2001L,2017L))

# anim_save("bubbles.gif", bubbles)
# while suppressing results from the code chunk results = FALSE.
# ![](goo.gif)



# Animated map ------------------------------------------------------------


library(gganimate)

library(ggmap)
library(maps)
library(mapdata)

states <- map_data("state")

ucr$region <- ucr$jurisdiction %>% tolower()

states.ucr <- left_join(states, ucr, by = "region")

# map_anim = ggplot() +
#   geom_polygon(data = final_data,
#                aes(x = long, y = lat, group = group, fill = unemp_rate, frame = year)) +
#   labs(title = "Unemployment rate in Luxembourg", y = "", x = "", fill = "Unemployment rate") +
#   theme_tufte() +
#   theme(axis.text.x = element_blank(),
#         axis.ticks.x = element_blank(),
#         axis.text.y = element_blank(),
#         axis.ticks.y = element_blank()) +
#   scale_fill_viridis()

theme_map <- function(...) {
  theme_minimal() +
    theme(
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_blank(),
      plot.background = element_rect(fill = "#f5f5f2", color = NA), 
      panel.background = element_rect(fill = "#f5f5f2", color = NA), 
      legend.background = element_rect(fill = "#f5f5f2", color = NA),
      panel.border = element_blank(),
      legend.position = "bottom",
      ...
    )
}

map_anim <- ggplot(data = states.ucr, aes(frame=year)) +
  geom_polygon(aes(x=long, y=lat, group = region, fill = violent_crime_total))+
  theme_map() +
  scale_fill_viridis()

# usamap <- ggplot(data = states.with_crime) + 
#   geom_polygon(aes(x = long, 
#                    y = lat, 
#                    fill = `Crimes Per Pop`,
#                    group = group), color = "white") +
#   scale_fill_viridis()
# 
# usamap_all <- usamap + 
#   coord_fixed(ratio=1.3) +
#   ggtitle("Violent crimes per population in US states in 1995")+
#   theme(legend.position = "right")

map_anim_all <- map_anim + transition_time(year)

map_anim_all

ucr2012 <- ucr %>% filter(year==2012)

ggplot(data=ucr2012, aes(x=violent_crime_total, y=state_population)) + geom_point()

ucr2012$crimes_per_pop <- ucr2012$violent_crime_total/ucr2012$state_population
ggplot(data=ucr2012, aes(x=crimes_per_pop)) + geom_histogram()
