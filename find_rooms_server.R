# Module server function
find_rooms_server <- function(input, output, session) {
  
  useSweetAlert()
  
  #Finding room
  
  observeEvent(input$find,{
      #Check-in date must be lower than check-out date
      req(input$daterange1[[1]]<input$daterange1[[2]])
    
      con <- dbConnect(RSQLite::SQLite(), "new_hotel_database_copy.db")
      sql_script<-paste("PRAGMA foreign_keys = ON")
      res<-dbExecute(con, sql_script)
      
      #Find available rooms
      sql_script<-paste(c("SELECT r.roomID AS 'Room no.', r.description AS Description, r.price AS 'Price per night' FROM Room AS r WHERE (r.roomID NOT IN (SELECT r.roomID AS beds_available FROM Room AS r LEFT JOIN ReservationRooms as rr ON rr.roomID = r.roomID LEFT JOIN Reservation as res ON res.reservationID = rr.reservationID WHERE ('",as.character(input$daterange1[1]),"' BETWEEN res.checkIN AND DATE(res.checkOUT,'-1 day')) OR ('",as.character(input$daterange1[2]),"' BETWEEN res.checkIN AND res.checkOUT)) AND r.bathroom =",input$bathroom,")"),collapse="")
      res<-dbGetQuery(con, sql_script)
      
      dbDisconnect(con)
      
      if(nrow(res)==0){
        sendSweetAlert(
          session = session,
          title = "We don't have any available rooms between typed date",
          type = "warning"
        )
      }
        
        updateSelectizeInput(session = session, inputId = "choice", choices = res$'Room no.', server = TRUE)
        output$resTable<-renderTable(res)

  })
  
  #Calculate total price
  data<-eventReactive(input$choice,{
    
    con <- dbConnect(RSQLite::SQLite(), "new_hotel_database_copy.db")
    sql_script<-paste("PRAGMA foreign_keys = ON")
    res<-dbExecute(con, sql_script)

    sql_script<-paste("SELECT r.price FROM Room AS r WHERE r.roomID IN (",paste(input$choice,collapse=","),")")
    res<-dbGetQuery(con, sql_script)

    paste((input$daterange1[[2]]-input$daterange1[[1]])*sum(res$price))
  })
  
  #Show total price
  output$total_price<-renderUI({
    paste("Total price ", data(), " PLN")
  })
  
  #Reservation
  observeEvent(input$clicks,{
    #requirement objects
    req(input$choice)
    req(input$Name)
    req(input$Mail)
    req(input$Phone)
    
    con <- dbConnect(RSQLite::SQLite(), "new_hotel_database_copy.db")
    sql_script<-paste("PRAGMA foreign_keys = ON")
    res<-dbExecute(con, sql_script)
    
    #Insert client information
    sql_script<-paste(c("INSERT INTO Client (Name, Email, Phone) VALUES ('",input$Name, "','",input$Mail,"',",input$Phone,")"),collapse="")
    res<-dbExecute(con, sql_script)
    
    #Take inserted client ID
    res1<-dbGetQuery(con, "SELECT clientID FROM Client ORDER BY clientID DESC LIMIT 1")
    
    #Generate PIN based on sys.time
    set.seed(as.integer(Sys.time()))
    values<-sample.int(1000000,1)
    
    #Insert reservation information
    sql_script<-paste(c("INSERT INTO Reservation (clientID, dateOfReservation, reservationCancelled, noOfPeople, PIN, checkIN, checkOUT, priceTotal) VALUES (",res, ",'",as.character(Sys.Date()),"',",0,",", input$NoofPerson,",",values,",'",as.character(input$daterange1[[1]]),"','",as.character(input$daterange1[[2]]),"',",data(),")"),collapse="")
    res<-dbSendQuery(con, sql_script)
    
    #Get inserted reservation (reservationID)
    res1<-dbGetQuery(con, "SELECT reservationID FROM Reservation ORDER BY reservationID DESC LIMIT 1")
    
    #Insert into reservationrooms information
    for (i in input$choice){
      sql_script<-paste(c("INSERT INTO ReservationRooms (reservationID, roomID) VALUES (", res1, ",",i,")"),collapse="")
      res<-dbSendQuery(con, sql_script)
    }
    
    dbDisconnect(con)
    
    #Generate QR code for payment
    new<-gsub('\\D',"",format(round(as.numeric(data()), digits=2), nsmall = 2))
    refactor<-formatC(as.integer(new), width=6, flag="0")
    cash<-paste0('|PL|07105013861000009151239754|',refactor,'|Kamil Kandzia|Reservation ID ', res1,'|||')
    
    output$qr1<- renderPlot({
      old_mar <- par()$mar
      par(mar=c(0,0,0,0))
      image(qrencode_raster(cash), asp=1, col=c("white", "black"),
            axes=FALSE, xlab="", ylab="")
      par(mar=old_mar)

    })
    
    #Show notification with ID, PIN and QRcode
    sendSweetAlert(
      session = session,
      title = "Reservation",
      text = tags$div(
        paste(c("Your reservation has been made! ID: ", res1,". PIN: ", values),collapse=""),
        plotOutput(outputId = session$ns("qr1")),
      ),
      html = TRUE,
      type = "success"
    )
    
    #Send mail with PIN and ID
    smtp <- server(host = "in-v3.mailjet.com",
                   port = 587,
                   username = "XXXXXX",
                   password = "XXXXXX")

    msg <- envelope() %>%
      from("kandzia.kamil@gmail.com") %>%
      to(input$Mail) %>%
      subject(paste("Our reservation ID:", res1, " PIN:", values))

    smtp(msg, verbose = TRUE)
    
  })
}