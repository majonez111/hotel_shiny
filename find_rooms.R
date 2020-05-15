find_rooms <- function(id, label = "find_rooms1") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  mainPanel(width = 12,
            fixedRow(
              h1("Find room!"),
              
              dateRangeInput(ns("daterange1"), "Check-in to Check-out date",
                             start = Sys.Date(),
                             end   = Sys.Date()+1,
                             min = Sys.Date(), 
                             max = Sys.Date()+365),
              
              materialSwitch(inputId = ns("bathroom"),
                label = "Bathroom in room", 
                value = TRUE,
                status = "primary"),
              
              actionButton(ns("find"), label = "Find!"),
              
              tableOutput(ns("resTable")),
              
              selectizeInput(inputId = ns("choice"), choices = NULL, label="Choose rooms", multiple = TRUE,
                             options = NULL),
          
              uiOutput(ns("total_price")),
              
              dropdownButton(
                tags$h3("Your data for reservation"),
                textInputAddon(inputId = ns("Name"), label = "Name", placeholder = "Enter name", addon = icon("user")),
                textInputAddon(inputId = ns("Mail"), label = "E-mail", placeholder = "Enter email", addon = icon("at")),
                textInputAddon(inputId = ns("NoofPerson"), label = "No of people", placeholder = "Enter no of people", addon = icon("users")),
                textInputAddon(inputId = ns("Phone"), label = "Phone number", placeholder = "Enter phone number", addon = icon("phone")),
                
                icon = icon("address-book"),label = " Click to enter your data ",
                status = "primary", circle = FALSE
                
              ),
              
              tags$div(style = "height: 20px;"), # spacing
              
              actionButton(ns("clicks"), label = "Make reservation"),
              #Generate QR code when reservation is succesfull
              uiOutput(ns("qr"))
              
              ))
}