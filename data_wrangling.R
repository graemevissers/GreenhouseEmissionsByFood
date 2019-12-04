# Analysis of GHG emissions by meal

library(dplyr)
library(plotly)
library(ggplot2)

simple_df <- read.csv("./data/simple_ghg_food.csv")
global_df <- read.csv("./data/GHG_Foods_Global.csv", stringsAsFactors = FALSE)
by_food <- read.csv("./data/recipe_calculations.csv")

#----Works with larger df to simplify to ghg emissions by product----------------

global_df$Food.type = trimws(global_df$Food.type)

global_df$Food.type[global_df$Food.type == 'Ling Common'] <- 'Ling'

global_df_ghg <- global_df %>%
  rename(Product = Food.type) %>% 
  rename(CO2 = kg.CO2.eq.kg.produce..BFM.or.L.after.conversion) %>%
  mutate(CO2 = as.character(CO2)) %>% 
  mutate(CO2 = as.double(CO2)) %>% 
  group_by(Product) %>% 
  summarise(
    GHG.Emissions = mean(CO2, na.rm = TRUE)
  ) %>% 
  arrange(-GHG.Emissions) %>% 
  filter(!is.na(GHG.Emissions))

View(global_df_ghg)

write.csv(global_df_ghg, "global_ghg_df.csv", row.names = FALSE)

global_df <- tail(global_df, -1)

simple_df_ghg <- simple_df %>%  # simplifies df to just ghg emissions
  select(Product, GHG.Emissions) %>% 
  arrange(-GHG.Emissions)

hamburger <- by_food %>% # creates a dataframe for hamburger
  select(Product, Product.Emissions, Hamburger.Meat,
         Hamburger.Veggies, Hamburger.Bun, Hamburger.Total, GHG.Emissions) %>% 
  filter(!is.na(GHG.Emissions))

#---------Creates Water Data and Land Data bar graphs----------------------

productChoices <- as.character(simple_df$Product)

water_data <- function(listProduct) {
  single <- simple_df[simple_df$Product %in% listProduct, ]
  p<-ggplot(data=single, aes(x=Product, y=Freshwater.Withdrawals, fill = Product)) +
    geom_bar(stat="identity") + theme_minimal()
  p + coord_flip()
}

land_data <- function(listProduct) {
  single <- simple_df[simple_df$Product %in% listProduct, ]
  p<-ggplot(data=single, aes(x=Product, y=Land.Usage, fill = Product)) +
    geom_bar(stat = "identity", width=0.7) + theme_minimal()
  p + coord_flip()
}

land_data(c("Wine", "Tofu", "Rapeseed Oil", "Nuts"))
