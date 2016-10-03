#
#   This application tests you knowledge on national flag around the world.
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
options <- c("item 1", "item 2", "item 3")

shinyUI(pageWithSidebar(  
    headerPanel("National Flag test"),  
    sidebarPanel(    
        sliderInput('questions', 'How many questions do you want ?', value = 3, min = 1, max = 10, step = 1),
        radioButtons('difficulty', 'How difficult can you handle ?', choices, selected = "hard", inline = TRUE),
        actionButton('ok', label = "OK")
    ),
    mainPanel(    
        textOutput('text1'),
        br(),
        uiOutput('image'),
        radioButtons('reply', 'What country do you select ?', options, selected = character(0)),
        actionButton('submit', label = "Submit"),
        br(),
        textOutput('text2')
    )
))