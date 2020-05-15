# Module server function
hotel_gallery_server <- function(input, output, session) {
  
  output$slickr <- renderSlickR({
    
    imgs <- list.files("www/gallery/", pattern=".jpg", full.names = TRUE)
    
    slickR(imgs) + 
      settings(autoplay = TRUE, arrows = TRUE, swipeToSlide = TRUE,
               slidesToScroll = 1, mobileFirst = TRUE)
  })
  
  
}