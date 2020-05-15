cancel_reservation <- function(id, label = "cancel_reservation1") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  mainPanel(width = 12,
              fixedRow(
                h1("Cancel now!"),
                numericInput(ns("ID_cancel"), "ID", "Enter ID of reservation"),
                passwordInput(ns("PIN_cancel"), "PIN"),
                actionButton(ns("clicksXD"), label = "Cancel reservation"),
                uiOutput(ns("reservation"))
                )
            )
}