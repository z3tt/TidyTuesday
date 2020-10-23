#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList 
mod_map_ui <- function(id){
  ns <- NS(id)
  fullPage::pageContainer(
    pageContainer(
      h3("Global Patterns of Crop Yields 1961–2018"),
      h4("(in tonnes per hectare)"),
      br(),
      fluidRow(
        column(4),
        column(4, uiOutput(ns("crop_select2_generated")))
      ),
      shinycssloaders::withSpinner(echarts4r::echarts4rOutput(ns("map"), height = "50vh")),
      br(), br(),
      p("Note: Values for the former USSR (1961–2018) have been assigned to Russia.", style = "font-size:.9vw;font-style:italic;"), 
      br(),
      p("Shiny App: ", tags$a(href="cedricscherer.netlify.com/", "Cédric Scherer"), "  •  Data Source: ", tags$a(href="https://ourworldindata.org/crop-yields", "Our World in Data"))
    )
  )
}


#' map Server Function
#'
#' @noRd 
mod_map_server <- function(input, output, session) {
  ns <- session$ns 
  
  ## DATA
  crops <- 
    readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-01/key_crop_yields.csv') %>% 
    tidyr::pivot_longer(
      cols = c(-Entity, -Year, -Code),
      names_to = "Crop",
      values_to = "Yield"
    ) %>% 
    dplyr::mutate(
      Crop = stringr::str_remove(Crop, "\\s\\(tonnes per hectare\\)"),
      Yield = round(Yield, 3),
      Entity = if_else(Entity == "USSR", "Russia", Entity)
    )
  
  output$crop_select2_generated <- renderUI({
    cnsC <- crops %>%
      dplyr::distinct(Crop) %>%
      dplyr::pull(Crop)
    
    selectizeInput(
      ns("crop_select2"),
      "Choose a crop",
      choices = cnsC,
      selected = c("Rice")
    )
  })
  
  output$map <- echarts4r::renderEcharts4r({
    req(input$crop_select2)
    
    echarts4r::e_common(
      font_family = "Overpass",
      theme = NULL
    )
    
    # requires a crop selected
    validate(
      need(length(input$crop_select2) > 0, message = "Select at a crop")
    )
    
    # filter selected and match with color
    dat2 <- crops %>% 
      dplyr::filter(
        !is.na(Code),
        Crop %in% input$crop_select2
      ) %>% 
      tidyr::pivot_wider(
        id_cols = c(Entity, Code, Year),
        names_from = Crop,
        values_from = Yield
      )
    
    ## plot
    echarts4r::e_country_names(dat2, Code, type = "iso3c")  %>% 
      dplyr::group_by(Year) %>% 
      echarts4r::e_charts(Entity, timeline = TRUE) %>% 
      echarts4r::e_map_(
        input$crop_select2, 
        name = "Yield (tonnes/hectare)",
        roam = TRUE,
        scaleLimit = list(min = .75, max = 10),
        itemStyle = list(
          borderWidth = .7,
          areaColor = "#dcdcdc",
          borderColor = "#dcdcdc"
        ),
        emphasis = list(
          label = list(
            color = "#000"
          ),
          itemStyle = list(
            borderWidth = 1,
            areaColor = "#FAC484",
            borderColor = "#fff"
          )
        ) 
      ) %>% 
      echarts4r::e_visual_map_(
        input$crop_select2, 
        top = "middle",
        textStyle = list(color = "#000"),
        outOfRange = list(
          color = "#b4b4b4"
        ),
        inRange = list(
          color = rcartocolor::carto_pal(n = 5, name = "Emrld")
        )
      )%>% 
      echarts4r::e_color(background = "rgba(0,0,0,0)") %>%  
      echarts4r::e_tooltip() %>% 
      echarts4r::e_timeline_opts(
        playInterval = 600, 
        autoPlay = TRUE,
        currentIndex = 16,
        symbol = 'emptyDiamond',
        symbolSize = 5, 
        label = list(
          color = "#000"
        ),
        checkpointStyle = list(
          color = "#b4b4b4",
          borderColor = "#11a5794D",
          symbol = "diamond",
          symbolSize = 16,
          borderWidth = 12
        ),
        lineStyle = list(
          color = "#b49a4f"
        ),
        controlStyle = list(
          color = "#b4b4b4",
          borderColor = "#b4b4b4"
        ),
        emphasis = list(
          label = list(color = "#11a579"),
          controlStyle = list(
            color = "#FAC484",
            borderColor = "#11a579"
          )
        ),
        itemStyle = list(
          emphasis = list(color = "#82d091")
        )
      ) %>% 
      echarts4r::e_toolbox(bottom = 0) %>% 
      echarts4r::e_toolbox_feature(feature = "dataView") 
  })
}	

