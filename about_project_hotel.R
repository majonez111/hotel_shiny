#UI
about_project_hotel <- function(id, label = "about_project_hotel1") {
 #
  ns <- NS(id)
  
  mainPanel(width = 12,
            fixedRow(
              h1("About the project!"),
              p("This project focused on presenting the potential of creating a hotel reservation system design by R package."),
              p("R language is mostly associated with data analysis and visualization of tables or charts. The packages allow to deploy a functional website as well as creating a dashboard for the administration panel (by shinydashboard). Considering the unavailability of the service creation in the free version of shinyapps.io, it was chosen to focus on the functionality of the reservation system, database queries and e-mailing to the user with reservation confirmation."),
              p("Hotel gallery was created by slickR"),
              downloadButton(outputId=ns("downloadData"), label="Download structure of database", 
                             icon = icon("file-download"))
  ))
}
