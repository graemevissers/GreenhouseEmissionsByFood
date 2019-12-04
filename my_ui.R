# Define content for the First page
# First page allows the user to select different meals, and we
# present a datatable on the emissions of each meal and where the emissions
# come from


source("data_wrangling.R")
source("analysis.R")
library("shinythemes")

#--------------Title Page------------------------------------------------------
intro <- tabPanel(
  wellPanel(

  h3("home"),
  h2("How much of an impact does our diet have on the enviornment?")
)
  )

about <- tabPanel(
  wellPanel(
  h3("About"),
  p("As greenhouse gas emissions are on the rise and global temperatures with it,
     consumers are more and more likely to make decisions based on their carbon footprint. 
     Food production and agriculture contributes to a large share of these emissions,
     so it . We have borrowed this data from Stephen Clune et al to present an app
     in which consumers can make informed decisions about their diet."),
  br(), #break (space)
  h3("Food Consumption and related Greenhouse Gas Emissions"),
  br(), #break (space)
  h3("Problem Situation:"),
  p("The food and agriculture sector contributes
  a significant portion of global greenhouse gas emissions. As greenhouse
  gas emissions has continued to proliferate, there has been an acceleration
  towards catastrophic global warming. The advocacy of convenience, coupled 
  with the continual advancements in technology have allowed for a culture
  of complacency. It is an ethical issue to consume without recognition of
  one's impact. Despite this, a lack of financial motivation for both
  producers and consumers in the market will prevent change."),
  br(), #break (space)
  h3("What is The Problem?"),
  p("As the population of the world increases and food consumption habits
     remain stagnant, the amount of preventable greenhouse gases produced
     by the food and agriculture sector becomes staggering. Superfluous
     amounts of greenhouse gases are generated due to massive food waste,
     excessive consumption of livestock, and the conversion of
     non-agricultural lands to agricultural land The extremely high
     consumption of red-meat in particular is a keystone issue. There are
     excessive inefficiencies throughout the chain of production due to
     red-meat consumption."),
  br(), #break (space)
  h3("Why Does It Matter?"),
  p("The proliferation of gases will accelerate the progress towards the
     brink of disaster due to climate change. Global warming could radically
     change weather patterns, coastlines, and ultimately degrade the standard
     of living across the globe. The obvious impact of global warming would
     be a general increase in the mean temperature across the globe. This
     impact itself is very dangerous due to changes in precipitation,
     causing mass droughts and heatwaves in many areas. This would also
     lead to the rise in sea level, increase in hurricane intensity,
     and displacement along coastlines."),
  br(), #break (space)
  h3("How Will It Be Addressed"),
  p("A reduction in food waste and focusing on eating low on the food chain
     would be a necessary step towards sustainable living. A long term
     solution begins with a recognition and adaptation of the human diet,
     requiring a transition towards a largely plant-based diet with small
     allowances. A data-based analysis and clear visual approach would be
     a powerful method of promoting adoption by the general population.
     Simplicity and instructional guidance are key methods of changing
     population behavior."),
  br(), #break (space)
  h3("Freshwater Withdrawals Dataset"),
  p("Climate Change = A change in global or regional climate patterns, in 
  particular a change apparent from the mid to late 20th century onwards 
  and attributed largely to the increased levels of atmospheric carbon
     dioxide produced by the use of fossil fuels."),
  p("Greenhouse Gas = A gas that contributes to the greenhouse effect by
     absorbing infrared radiation, e.g., carbon dioxide and chlorofluorocarbons."),
  p("C02 Equivalent = A metric measure used to compare the emissions from
  various greenhouse gases on the basis of their global-warming potential
  (GWP), by converting amounts of other gases to the equivalent amount
     of carbon dioxide with the same global warming."),
  br(), #break (space)
  p("Greenhouse Gas Emissions Dataset(Large) provided us with tabs, receipts
     and receipt inputs. The author of this Dataset was Stephen Clune.
     He receieved by collating and analysing 369 LCA studies
     including 168 food types and 1718 GWP values."),
  # picture of Greenhouse Gas Emissions
  imageOutput("ghge_image")
  ),
  
  h3("Greenhouse Gas Emissions Dataset"),
  p("Freshwater Withdrawals = Refer to total water
  withdrawals, not counting evaporation losses from
     storage basins."),
  p("Land Usagae = The management and modification of natural environment
  or wilderness into built environment such as settlements and semi-natural 
     habitats such as arable fields, pastures, and managed woods."),
  br(), #break (space)
  p("Freshwater Withdrawals/Land Usage Dataset(Small) provided us with
     graphs on the Freshwater withdrawals and Land Usage. 
     The authors of this Dataset were J.Poore and T.Nemecek."),
  # picture of Freshwater withdrawals and Land Usage
  imageOutput("fwwlu_image"),
)

#--------First Page--------------------------------------
emissions_by_meal <- tabPanel(
  h3("Emissions by Meal"),
  titlePanel("Emissions by Meal"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "meal_select",
        label = h3("Meal Choice"),
        choices = list("Hamburger")
      ),
      imageOutput("meal_image"), # picture of meal
    ),
    mainPanel(
      h3(textOutput("meal_ghg_text")), #outputs the sum of ghg emissions
      dataTableOutput("meal_table") # datatable of meal
    )
  )
)

#Define content for the third page
page_four <- tabPanel(
  h3("Land and Water Usage"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("product", h3("Choose food items:"),
                         choiceNames = productChoices,
                         choiceValues = productChoices,
                         selected = c("Poultry Meat", "Apple")
      )
    ),
    mainPanel(
      plotOutput("water"),
      hr(),
      plotOutput("land")
    )
  )
)

# Define the fourth page
recipe_input <- tabPanel(
  h3("Input your recipe"), 
  mainPanel(
    h1(id = "recipeheader", "Your Recipe"),
    uiOutput("newIngred")
  ),
  sidebarPanel(
    h3(textOutput("user_ghg")),
    actionButton("calculate", h3("Calculate GHG Emissions")),
    actionButton("add", h3("Add Ingredient"))
  )
)

one_ingredient <- fluidRow(
  id = "ingred",
  column(6,
         selectInput(
           inputId = paste0("ingredient", 1),
           label = h3("Ingredient Choice"),
           choices = sort(global_df_ghg$Product)
         )
  ),
  column(6,
         numericInput(
           inputId = "weight",
           label = h3("Amount (kg or L)"),
           value = NA
         )
  )
)

my_ui <- navbarPage(
  theme = "bootstrap.css",
  h1("Greenhouse Emissions by Food"),
  intro,
  about,
  emissions_by_meal,
  page_four,
  recipe_input
)
