library(shiny)
library(tidyverse)
library(fullPage)
library(echarts4r)


##------------------------------------------------------------------------------
## SERVER
app_server <- function( input, output, session ) {
  callModule(mod_trend_server, "trend")
  callModule(mod_map_server, "map")
  callModule(mod_comp_server, "comp")
}


##------------------------------------------------------------------------------
## UI
app_ui <- function(request) {
  
  options <- list(easing = "linear", scrollingSpeed = 400, keyboardScrolling = TRUE)
  
  options(spinner.color = "#11a579", spinner.size = 1, spinner.type = 4)
  
  tagList(
    tags$head(includeCSS("www/css.css")),
    fullPage::pagePiling(
      sections.color = c('#dbdbdb', '#efefef', '#dbdbdb'),
      opts = options,
      menu = c(
        "Temporal Trends" = "Timeline",
        "Spatiotemporal Trends" = "Map",
        "Comparison Yields 2018" = "Comparison"
      ),
      fullPage::pageSection(
        center = TRUE,
        menu = "Timeline",
        mod_trend_ui("trend")
      ),
      fullPage::pageSection(
        center = TRUE,
        menu = "Map",
        mod_map_ui("map")
      ),
      fullPage::pageSection(
        center = TRUE,
        menu = "Comparison",
        mod_comp_ui("comp")
      )
    )
  )
}

##------------------------------------------------------------------------------
## RUN APP
shinyApp(app_ui, app_server)