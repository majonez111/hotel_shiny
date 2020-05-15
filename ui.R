library(rsconnect)
library(shiny)
library(shinydashboard)
library(DBI)
library(RSQLite)
library(shinythemes)
library(httr)
library(shinycssloaders)
library(grDevices)
library(lattice)
library(rsvg)
library(raster)
library(qrencoder)
library(svglite)
library(emayili)
library(magrittr)
library(plyr)
library(dplyr)
library(shinyWidgets)
library(slickR)

Sys.setlocale("LC_ALL", "Polish")
options(encoding = 'CP1250')

source("cancel_reservation_server.R")
source("cancel_reservation.R")

source("find_rooms_server.R")
source("find_rooms.R")

source("about_project_hotel.R")
source("about_project_hotel_server.R")

source("hotel_gallery.R")
source("hotel_gallery_server.R")


fluidPage(theme = shinytheme("darkly"), 
          navbarPage("Kamil Kandzia", 
             id = "navbarID",
             navbarMenu(title = "Hotel reservation project", icon=icon("concierge-bell"),
                        tabPanel("Hotel gallery", hotel_gallery("hotel_gallery1"),icon=icon("images")),
                        tabPanel("Find a room and book it", find_rooms("find_rooms1"),icon=icon("bed")),
                        tabPanel("Cancel your reservation", cancel_reservation("cancel_reservation1"), icon=icon("calendar-times")),
                        tabPanel("About the project", about_project_hotel("about_project_hotel1"), icon=icon("r-project"))
                        )
          )
)