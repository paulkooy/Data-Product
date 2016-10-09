#
#   This application tests your knowledge of national flag around the world.
#   Results of participants are captured and presented with your own score. 
#
#   Assignment for the Building Data Products module of the Data Sciences Specialization
#   Author: Paul van der Kooy
#   Date:   September'16
#
#   Load required libraries
#
library(shiny)
choices <- c("Easy" = "easy", "Hard" = "hard", "Extreme" = "extreme")
options <- c(" ", "item 2", "item 3", "item 4")

shinyUI(pageWithSidebar(  
    headerPanel("National Flag test"),  
    sidebarPanel(    
        sliderInput('questions', 'How many questions do you want ?', value = 4, min = 2, max = 8, step = 1),
        radioButtons('difficulty', 'How difficult can you handle ?', choices, selected = "hard", inline = TRUE),
        actionButton('ok', label = "OK")
    ),
    mainPanel(
        conditionalPanel(condition = "input.ok",
                         
            textOutput('text1'),
            br(),
            uiOutput('image'),
            radioButtons('reply', 'What country do you select ?', options, selected = NULL),
            actionButton('submit', label = "Submit"),
            br(),
            textOutput('catText'),
            textOutput('text2'),
            textOutput('text3')
        )
    )
))