#
#   This is the server logic for a Shiny web application.
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
library(rjson)
library(geonames)
library(dplyr)
#
#   Enable GeoNames web services and import the country information
#
url <- "http://api.geonames.org/countryInfoCSV?username=paulkooy&style=full"
countryInfo <- read.delim(url, na.strings = c("","NA"), fill=FALSE)
#   Filter out countries without name
countryInfo <- filter(countryInfo, !is.na(name))
countryInfo <- countryInfo[order(countryInfo$population, decreasing = TRUE),]
easy <- c(1:10, 15, 21, 22, 25, 26, 28, 31, 36, 46, 54, 60, 75, 86, 97, 115)
hard <- c(1:100)

shinyServer(  
    function(input, output, session) {
            output$text1 <- renderText({paste("Here are ",as.numeric(input$questions)," ",input$difficulty," questions for you to answer.")})
            countries <- reactive({switch (input$difficulty,
                easy = countryInfo[easy,],
                hard = countryInfo[hard,],
                extreme = countryInfo
            )
            selection <- sample(countries$iso.alpha2, 4)
            answer <- sample(selection, 1)
            })
            output$image <- renderUI({
                tags$img(src = paste0("http://www.geonames.org/flags/x/",tolower(as.character(answer)),".gif"))
            })
            observe({
                x <- input$reply
                option1 <- countryInfo$name[countryInfo$iso.alpha2 == selection[1]]
                option2 <- countryInfo$name[countryInfo$iso.alpha2 == selection[2]]
                option3 <- countryInfo$name[countryInfo$iso.alpha2 == selection[3]]
                option4 <- countryInfo$name[countryInfo$iso.alpha2 == selection[4]]
                options <- c(as.character(option1[1]), as.character(option2[1]), as.character(option3[1]), as.character(option4[1]))
                updateRadioButtons(session, 'reply', 'What country do you select ?', choices = options, selected = character(0))
            })
            observe({
                input$submit
                isolate( text <- paste("Radiobutton response is:", input$reply ))
                output$text2 <- renderText({text})
            })
#            if (countryInfo$name[countryInfo$iso.alpha2 == answer[1]][1] == output$flagTest) {
#                output$text2 <- "goed"
#            } else {
#                output$text2 <- "fout"
#            }
#
#        reactive({
#        })
#        
#        output$myHist <- renderPlot({      
#            hist(galton$child, xlab='child height', col='lightblue',main='Histogram')      
#            mu <- input$mu      
#            lines(c(mu, mu), c(0, 200),col="red",lwd=5)      
#            mse <- mean((galton$child - mu)^2)      
#            text(63, 150, paste("mu = ", mu))      
#            text(63, 140, paste("MSE = ", round(mse, 2)))      
#        })
                            }
)