library("shiny")
library("DT")
source('my_server.R')
source('my_ui.R')

shinyApp(ui = my_ui, server = my_server)