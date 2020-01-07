library(shiny)
library(tidyverse)
library(lubridate)
library(ggmap)
library(ggrepel)
library(gridExtra)
library(pander)
library(ggplot2)

shinyServer(function(input, output) {
   
  output$hannibal <- renderPlot({
    if(input$select == 1){
      
      cities <- read.table("data/hannibal/cities.txt",
                           header = TRUE, stringsAsFactors = FALSE)
      troops <- read.table("data/hannibal/troops.txt",
                           header = TRUE, stringsAsFactors = FALSE)
      
      if(input$map ==TRUE){
        hannibal.box <- c(left = -8, bottom = 39, right = 14, top = 46.4)
        hannibal.map <- get_stamenmap(bbox = hannibal.box, zoom = 8, maptype = "terrain-background", where = "cache")
      
        hannibal.plot <- ggmap(hannibal.map) +
          geom_path(data = troops, aes(x = long, y = lat, group = group, color = direction, size = troops), lineend = "round") +
          geom_point(data = cities, aes(x = long, y = lat),color = "#000000") +
          geom_text_repel(data = cities, aes(x = long, y = lat, label = city), color = "#000000") +
          scale_size(range = c(0.1, 7.5)) + 
          scale_colour_manual(values = c("#DFC17E", "#252523")) +
          guides(color = FALSE, size = FALSE) +
          theme_nothing()
      }
      
      else {
        hannibal.plot <- ggplot() +
          geom_path(data = troops, aes(x = long, y = lat, group = group, color = direction, size = troops), lineend = "round") +
          geom_point(data = cities, aes(x = long, y = lat),color = "#000000") +
          geom_text_repel(data = cities, aes(x = long, y = lat, label = city), color = "#000000") +
          scale_size(range = c(0.1, 7.5)) + 
          scale_colour_manual(values = c("#DFC17E", "#252523")) +
          guides(color = FALSE, size = FALSE) +
          theme_nothing()
      }
      
      hannibal.plot
      
    }
  })
  
  output$napoleon <- renderPlot({
    if(input$select == 2){
      
      cities <- read.table("data/napoleon/cities.txt",
                           header = TRUE, stringsAsFactors = FALSE)
      troops <- read.table("data/napoleon/troops.txt",
                           header = TRUE, stringsAsFactors = FALSE)
      temps <- read.table("data/napoleon/temps.txt",
                          header = TRUE, stringsAsFactors = FALSE) %>% mutate(date = dmy(date))
      
      if(input$map==TRUE){
        march.1812.ne.europe <- c(left = 23.5, bottom = 53.4, right = 38.1, top = 56.3)
        
        march.1812.ne.europe.map <- get_stamenmap(bbox = march.1812.ne.europe, zoom = 8,
                                                  maptype = "terrain-background", where = "cache")
        
        march.1812.plot.simple <- ggmap(march.1812.ne.europe.map) +
          geom_path(data = troops, aes(x = long, y = lat, group = group, 
                                       color = direction, size = survivors),
                    lineend = "round") +
          geom_point(data = cities, aes(x = long, y = lat),
                     color = "#000000") +
          geom_text_repel(data = cities, aes(x = long, y = lat, label = city),
                          color = "#000000") +
          scale_size(range = c(0.5, 10)) + 
          scale_colour_manual(values = c("#DFC17E", "#D3D3D3")) +
          guides(color = FALSE, size = FALSE) +
          theme_nothing()
      }
      
      else {
        march.1812.plot.simple <- ggplot() +
          geom_path(data = troops, aes(x = long, y = lat, group = group, 
                                       color = direction, size = survivors),
                    lineend = "round") +
          geom_point(data = cities, aes(x = long, y = lat),
                     color = "#000000") +
          geom_text_repel(data = cities, aes(x = long, y = lat, label = city),
                          color = "#000000") +
          scale_size(range = c(0.5, 10)) + 
          scale_colour_manual(values = c("#DFC17E", "#D3D3D3")) +
          guides(color = FALSE, size = FALSE) +
          theme_nothing()
      }
      temps.nice <- temps %>%
        mutate(nice.label = paste0(temp, "°, ", month, ". ", day))
      
      temps.1812.plot <- ggplot(data = temps.nice, aes(x = long, y = temp)) +
        geom_line() +
        geom_label(aes(label = nice.label), size = 2.5) + 
        labs(x = NULL, y = "° Celsius") +
        scale_x_continuous(limits = ggplot_build(march.1812.plot.simple)$layout$panel_ranges[[1]]$x.range) +
        scale_y_continuous(position = "right") +
        coord_cartesian(ylim = c(-35, 5)) +
        theme_minimal() +
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank(),
              panel.grid.minor.y = element_blank(),
              axis.text.x = element_blank(), axis.ticks = element_blank(),
              panel.border = element_blank())
      
      both.1812.plot.simple <- rbind(ggplotGrob(march.1812.plot.simple),
                                     ggplotGrob(temps.1812.plot))
      
      panels <- both.1812.plot.simple$layout$t[grep("panel", both.1812.plot.simple$layout$name)]
      
      map.panel.height <- both.1812.plot.simple$heights[panels][1]
      both.1812.plot.simple$heights[panels] <- unit(c(map.panel.height, 0.1), "null")# unit(c(3, 1), "null")
      
      grid::grid.newpage()
      grid::grid.draw(both.1812.plot.simple)
      
    }
  })
})
