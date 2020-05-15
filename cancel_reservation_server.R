# Module server function
cancel_reservation_server <- function(input, output, session) {
  
  useSweetAlert()
  
  observeEvent(input$clicksXD,{

    con <- dbConnect(RSQLite::SQLite(), "new_hotel_database_copy.db")
    dbExecute(con, "PRAGMA foreign_keys=ON")
    
    sql_script<-paste(c("DELETE FROM Reservation WHERE reservationID = ",input$ID_cancel," AND PIN = ", input$PIN_cancel),collapse="")
    res<-dbExecute(con, sql_script)
    
    dbDisconnect(con) 
  
    output$reservation <- renderUI  ({
        
        if(res>0){
          sendSweetAlert(
            session = session,
            title = "Reservation",
            text = "The reservation has been deleted",
            type = "warning"
          )
        }
        else
          sendSweetAlert(
            session = session,
            title = "Error",
            text = "Incorrect reservationID or PIN",
            type = "error"
          )
          
      })

  })
}