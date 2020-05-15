hotel_gallery <- function(id, label = "hotel_gallery1") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  mainPanel(width=12,
            fixedRow(
              h1("Hotel gallery!"),
              p("After several hours searching for a solution related to the white frame at the pictures, I capitulated. Today's sprint (as they say in an Agile) was not successful, and I was defeated by CSS, which despite modifications still doesn't look right. Maybe it's time to accept the default background as white..."),
              tags$a(href="https://stackoverflow.com/questions/17290701/maintain-image-aspect-ratio-in-carousel", "Stack"),
              tags$a(href="https://stackoverflow.com/questions/58359294/make-bootstrap-carousel-background-transparent", "Another Stack"),
              slickROutput(ns("slickr")))
            )

}