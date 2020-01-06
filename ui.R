library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme=shinytheme("spacelab"),
  
  titlePanel("Replicating Charles Minard's Famous Charts in R"),
  
  sidebarLayout(
    sidebarPanel(
       selectInput("select", h4("Select chart"), 
                   choices = list("Napoleon in Russia - 1812 AD" = 1, "Hannibal Crosses the Alps - 218 BC" = 2), selected = 1)
    ),
    
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
