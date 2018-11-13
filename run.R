rm(list = ls())

options(shiny.reactlog=TRUE)

#install.packages('pacman')
library('pacman')

p_load(jsonlite, shiny, htmltools)

runApp('app/')