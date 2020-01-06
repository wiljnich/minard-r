library(shiny)
library(tidyverse)
library(lubridate)
library(ggmap)
library(ggrepel)
library(gridExtra)
library(pander)
library(ggplot2)

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    if(input$select == 1){
      
      cities <- read.table("data/napoleon/cities.txt",
                           header = TRUE, stringsAsFactors = FALSE)
      troops <- read.table("data/napoleon/troops.txt",
                           header = TRUE, stringsAsFactors = FALSE)
      temps <- read.table("data/napoleon/temps.txt",
                          header = TRUE, stringsAsFactors = FALSE) %>% mutate(date = dmy(date))
      
      march.1812.plot.simple <- ggplot() +
        geom_path(data = troops, aes(x = long, y = lat, group = group, 
                                     color = direction, size = survivors),
                  lineend = "round") +
        geom_point(data = cities, aes(x = long, y = lat),
                   color = "#DC5B44") +
        geom_text_repel(data = cities, aes(x = long, y = lat, label = city),
                        color = "#DC5B44") +
        scale_size(range = c(0.5, 10)) + 
        scale_colour_manual(values = c("#DFC17E", "#252523")) +
        guides(color = FALSE, size = FALSE) +
        theme_nothing()
      
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
      
      both.1812.plot.simple$heights[panels] <- unit(c(3, 1), "null")
      
      grid::grid.newpage()
      grid::grid.draw(both.1812.plot.simple)
    }
    
    else {
      
      cities <- read.table("data/hannibal/cities.txt",
                           header = TRUE, stringsAsFactors = FALSE)
      troops <- read.table("data/hannibal/troops.txt",
                           header = TRUE, stringsAsFactors = FALSE)
      
      hannibal.plot <- ggplot() +
        geom_path(data = troops, aes(x = long, y = lat, group = group, color = direction, size = troops), lineend = "round") +
        geom_point(data = cities, aes(x = long, y = lat),color = "#000000") +
        geom_text_repel(data = cities, aes(x = long, y = lat, label = city), color = "#000000") +
        scale_size(range = c(0.1, 7.5)) + 
        scale_colour_manual(values = c("#DFC17E", "#252523")) +
        guides(color = FALSE, size = FALSE) +
        theme_nothing()
      
      tempsII <- ggplot(data = NULL, aes(x = NULL, y = NULL)) +
        theme_nothing()
      
      bothII <- rbind(ggplotGrob(hannibal.plot),ggplotGrob(tempsII))
      panels <- bothII$layout$t[grep("panel", bothII$layout$name)]
      bothII$heights[panels] <- unit(c(3, 1), "null")
      grid::grid.newpage()
      grid::grid.draw(bothII)
      
    }
  })
  
})
