library(shiny)
library(leaflet)
library(RColorBrewer)
library(superml)
library(dplyr)


df_fill = read.csv('./data/sampled_le.csv')
cols = c('assessmentyear',
         'roomcnt',
         'regionidzip',
         'rawcensustractandblock',
         'bedroomcnt',
         'calculatedfinishedsquarefeet',
         'propertylandusetypeid',
         'regionidcounty',
         'taxvaluedollarcnt',
         'bathroomcnt',
         'taxamount',
         'fips',
         'structuretaxvaluedollarcnt')

# most from https://rstudio.github.io/leaflet/shiny.html

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                selectInput("colors", "Color Scheme",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))),
                selectInput("col_names", "Observe columns",
                            cols, selected = cols[[2]]),
                checkboxInput("legend", "Show legend", TRUE)
                ))



server <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    df_fill[,c("longitude", "latitude", input$col_names, paste0(input$col_names, "_nan"))] %>% 
      rename(col_names = input$col_names, miss = paste0(input$col_names, "_nan"))
  })
  
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  colorpal <- reactive({
    colorNumeric(input$colors, quakes$coal_names)
  })
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(df) %>% addTiles() %>%
      fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude))
  })
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    pal <- colorpal()
    
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(radius = 3*10^2, weight = ~paste(miss), color = "#000000",
                 fillColor = ~pal(col_names), fillOpacity = 0.6, popup = ~paste(col_names)
      )
  })
  
  # Use a separate observer to recreate the legend as needed.
  observe({
    proxy <- leafletProxy("map", data = filteredData())

    # Remove any existing legend, and only if the legend is
    # enabled, create a new one.
    proxy %>% clearControls()
    if (input$legend) {
      pal <- colorpal()
      proxy %>% addLegend(position = "bottomright",
                          pal = pal, values = ~col_names
      )
    }
  })
}


shinyApp(ui, server)
