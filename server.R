#server
function(input, output, session) {
  
  cancel_reservation1<-callModule(cancel_reservation_server, "cancel_reservation1")
  
  find_rooms1<-callModule(find_rooms_server, "find_rooms1")
  
  about_project_hotel1<-callModule(about_project_hotel_server, "about_project_hotel1")
  
  hotel_gallery1<-callModule(hotel_gallery_server, "hotel_gallery1")
}

