
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


