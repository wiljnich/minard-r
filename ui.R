library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme=shinytheme("sandstone"),
                  fluidRow(column(4, img(src='minard.png', style='width:275px')),
                           column(8, titlePanel('The Marches of Hannibal and Napoleon: Replicating Charles Minard\'s Famous Charts in R'),
                                  p('Many know the French data visualization pioneer Charles Minard
                                    from his famous depiction of Napoleon\'s retreat from Moscow in 1812. Lesser known
                                    is the top half of that tableau, which depicts Hannibal of Carthage\'s elephant-driven march
                                    over the Alps into Italy in 218 BC during the Second Punic War.'))),
                  
                
  sidebarLayout(
    sidebarPanel(
       selectInput("select", h4("Select chart"), 
                   choices = list("Hannibal Crosses the Alps - 218 BC" = 1, "Napoleon in Russia - 1812 AD" = 2), selected = 1),
       checkboxInput("map", "Add a background terrain map", FALSE),
       helpText("Adding the map feature will require loading time due to limitations from the mapping service provider."),
       helpText("This project was adapted from code developed by Andrew Heiss at Georgia State University. Minard's written descriptions were sourced from \"The Minard System\" by Sandra Rendgen.")
       ),
    
    mainPanel(
       conditionalPanel(
          condition = "input.select == 1",
          tags$b("Figurative map of the successive losses of Hannibal's 
                 army during the march from Spain to Italy through Gallia"),
          plotOutput("hannibal"),
          wellPanel('"Drawn up by Mr Minard, inspector-general of bridges and roads (retired). Paris, 20 November 1869. The numbers of men remaining with Hannibal are represented by the width of the colored zones at a rate of one milimeter for ten thousand men; they are further written across the zones. There is no final opinion on where Hannibal crossed the Alps; I have adopted the opinion of Larosa without pretending to justify it."')),
       
       conditionalPanel(
         condition = "input.select == 2",
         tags$b("Figurative map of the successive losses of the French 
                army during the Russian campaign, 1812-1813"),
         plotOutput("napoleon"),
         wellPanel('"Drawn up by Mr Minard, inspector-general of bridges and roads (retired). Paris, 20 November 1869. The number of men present is symbolised by the broadness of the coloured zones at a rate of one millimeter for ten thousand men; furthermore, those numbers are written across the zones. The red [tan] signifies the men who entered Russia, the black those who got out of it. The data used to draw up this chart were found in the works of Messrs. Thiers, de Ségur, de Fezensac, de Chambray and the unpublished journal of Jacob, pharmacist of the French army since 28 October. To better represent the diminution of the army, I’ve pretended that the army corps of Prince Jerôme and of Marshall Davousz which were detached at Minsk and Mobilow and rejoined the main force at Orscha and Witebsk, had always marched together with the army."'))
  )
))
)
