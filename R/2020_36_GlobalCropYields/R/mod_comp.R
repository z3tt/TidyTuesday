#' comp UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList 
mod_comp_ui <- function(id){
  ns <- NS(id)
  fullPage::pageContainer(
    pageContainer(
      h3("Comparison of Crop Yields in 2018"),
      h4("(in tonnes per hectare)"),
      br(),
      fluidRow(
        column(7, uiOutput(ns("crop_select3_generated"))),
        column(
          5,
          shinyWidgets::radioGroupButtons(
            inputId = ns("chart"),
            label = "Choose chart type",
            choices = c("Dodged bars", "Stacked bars"),
            selected = "Dodged bars",
            checkIcon = list(
              yes = icon("ok",
                         lib = "glyphicon")
            )
          )
        )
      ),
      shinycssloaders::withSpinner(echarts4r::echarts4rOutput(ns("comp"), height = "50vh")),
      br(), br(), br(),
      p("Shiny App: ", tags$a(href="cedricscherer.netlify.com/", "Cédric Scherer"), "  •  Data Source: ", tags$a(href="https://ourworldindata.org/crop-yields", "Our World in Data"))
    )
  )
}


#' comp Server Function
#'
#' @noRd 
mod_comp_server <- function(input, output, session) {
  ns <- session$ns 
  
  ## DATA
  continents <- c("Africa", "Asia", "Central America", "Europe", 
                  "Northern America", "Oceania", "South America")
  
  crops <- 
    readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-01/key_crop_yields.csv') %>% 
    dplyr::filter(
      Year == 2018,
      Entity %in% continents
    ) %>% 
    tidyr::pivot_longer(
      cols = c(-Entity, -Year, -Code),
      names_to = "Crop",
      values_to = "Yield"
    ) %>% 
    dplyr::mutate(
      Year = as.character(Year),
      Crop = stringr::str_remove(Crop, "\\s\\(tonnes per hectare\\)"),
      Yield = format(round(Yield, 2), nsmall = 2)
    )
  
  output$crop_select3_generated <- renderUI({
    cnsA <- crops %>%
      dplyr::distinct(Crop) %>%
      dplyr::pull(Crop)
    
    selectizeInput(
      ns("crop_select3"),
      "Select crops of interest",
      choices = cnsA,
      selected = c("Wheat", "Rice", "Potatoes", "Cassava"),
      multiple = TRUE,
      width = "100%"
    )
  })
    
  output$comp <- echarts4r::renderEcharts4r({
    req(input$crop_select3)
    
    echarts4r::e_common(
      font_family = "Overpass",
      theme = NULL
    )
    
    # requires a crop selected
    validate(
      need(length(input$crop_select3) > 0, message = "Select at least one crop")
    )
    
    # var to color mapping
    my_colors <- tibble::tibble(
      Entity = continents,
      color = rcartocolor::carto_pal(n = 7, name = "Antique")
    )
    
    ## filter selected and add oclor information
    dat <-
      crops %>% 
      dplyr::filter(Crop %in% input$crop_select3) %>%
      dplyr::left_join(my_colors, by = "Entity") #%>% 
      # pivot_wider(
      #   id_cols = c(Entity, Code, Year),
      #   names_from = Crop,
      #   values_from = Yield
      # )
    
    ## plot
    e <- dat %>%
      dplyr::group_by(Entity) %>% 
      echarts4r::e_charts(Crop) %>% 
      echarts4r::e_tooltip(trigger = "item") %>% 
      echarts4r::e_x_axis(axisTick = list(interval = 0)) %>% 
      echarts4r::e_color(unique(dat$color)) %>% 
      echarts4r::e_toolbox(bottom = 0) %>% 
      echarts4r::e_toolbox_feature(feature = "dataZoom") %>% 
      echarts4r::e_toolbox_feature(feature = "dataView")
    
    if (input$chart == "Dodged bars") {
      e %>% echarts4r::e_bar(Yield)
    } else {
      e %>% echarts4r::e_bar(Yield, stack = "grp")
    }
  })
}	
