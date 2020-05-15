# Module server function
about_project_hotel_server <- function(input, output, session) {
  
  #download files function 
  output$downloadData <- downloadHandler(
    filename <- function() {
      paste("database", "xps", sep=".")
    },
    
    content <- function(file) {
      file.copy("database.xps", file)
    },
  )
  
  
}