source("data_wrangling.R")
source("analysis.R")
library("dplyr")

my_server <- function(input, output, session) {
  
  # ghge image
  output$ghge_image <- renderImage({
    filename <- "images/GHGE.jpeg" # sets filename to send
    # Note filename is dependent on what user selects
    list(src = filename,
         contentType = "image/jpeg",
         width = 760, # picture width
         height = 380) # picture height
  }, deleteFile = FALSE)
  
  # fwwlu image
  output$fwwlu_image <- renderImage({
    filename <- "images/fwwlu.jpg" # sets filename to send
    # Note filename is dependent on what user selects
    list(src = filename,
         contentType = "image/jpg",
         width = 760, # picture width
         height = 380) #picture height
  }, deleteFile = FALSE)
  
  #----------Server for first page, meal output-----------------------------
  
  # Send a pre-rendered image, and don't delete the image after sending it
  output$meal_image <- renderImage({
    filename <- paste0("images/", tolower(input$meal_select), ".png") # sets filename to send
    # Note filename is dependent on what user selects
    list(src = filename,
         contentType = "image/png",
         width = 220,
         height = 170)
  }, deleteFile = FALSE)
  
  output$meal_table = renderDataTable({
    tot_weight <- paste0(input$meal_select, ".Total")
    tot_emissions <- paste0(input$meal_select, ".Emissions")
    df <- by_food[, c("Product", "Product.Emissions", tot_weight, "GHG.Emissions")]
    df <- df %>% filter(!is.na(GHG.Emissions))
    DT::datatable(df, options = list(paging = FALSE))
  })
  
  output$meal_ghg_text = renderText({
    tot_weight <- paste0(input$meal_select, ".Total")
    tot_emissions <- paste0("GHG", ".Emissions")
    df <- by_food[tot_emissions]
    df <- na.omit(df)
    ghg_tot = round(sum(df[tot_emissions]), 1)
    message_str <- paste(ghg_tot, "kg CO2 Equivalents")
    message_str
  })
    
  #----Server for plot outputs------------------------------------------
  
  ##### Third page plots
  
  water_table <- reactive({
    water_data(input$product)
  })
  
  output$water <- renderPlot({
    water_table()
  })
  
  land_table <- reactive({
    land_data(input$product)
  })
  
  output$land <- renderPlot({
    land_table()
  })
  
  #---------------Server for user-input meal------------------------------------------
  
  ingredients <- reactiveValues(count = c(1))
  
  # Button to calculate emissions
  emission_calc <- eventReactive(input$calculate, {
    ghg_list <- lapply(ingredients$count, function(i){
      ing_id <- paste0("ingredient", i)
      weight_id <- paste0("weight", i)
      emission_df <- global_df_ghg[global_df_ghg$Product == input[[ing_id]], "GHG.Emissions"]
      emission <- emission_df$GHG.Emissions[[1]]
      weight <- input[[weight_id]]
      round(emission*weight)
    })
    do.call(sum, ghg_list)
  })
  
  output$user_ghg <- renderText({
    user_tot_emissions <- emission_calc()
    str <- paste(user_tot_emissions, "kg CO2 Equivalents")
  })
  
  observeEvent(input$add,{
    ingredients$count <- c(ingredients$count, max(ingredients$count)+1)
  })
  
  observe({
    output$newIngred <- renderUI({
      rows <- lapply(ingredients$count, function(i){
        fluidRow(
          column(6,
                 selectInput(
                   inputId = paste0("ingredient", i),
                   label = "Ingredient",
                   choices = sort(global_df_ghg$Product)
                 ),
          ),
          column(6,
                 numericInput(
                   inputId = paste0("weight", i),
                   label = "Weight (kg or L)",
                   min = 0,
                   value = 0
                 )
          )
        )
      })
      do.call(shiny::tagList,rows)
    })
  })
  
}