#
#   This is the server logic for a Shiny web application.
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
        #
        #   Set variables to control the flow
        #
        val <- reactiveValues(j = 1, score = 0, src = " ", options = " ")
        #
        #   Initialise the dataset for the quiz questions
        #
        output$text1 <- renderText({paste("Here are ",input$questions," ",input$difficulty," questions for you to answer.")})
        observeEvent(input$ok , {
            countries <- reactive({
                    switch (input$difficulty,
                    easy = countryInfo[easy,],
                    hard = countryInfo[hard,],
                    extreme = countryInfo
                )
                set.seed(as.numeric(Sys.time()))
                sampleList <- as.character(sample(countries$iso.alpha2, 4*input$questions))
                selection <- matrix(sampleList, nrow = as.numeric(input$questions), ncol = 4)
                for(i in 1:as.numeric(input$questions)) {
                    answer[i] <- sample(selection[i,], 1)
                }
            })  #   end of reactive
            isolate({cat("Number of questions:", input$questions, "Length:", length(selection), "\n")})
            cat(as.matrix(selection),"\n")
            cat("Dimension:", dim(selection),"\n")
            cat(as.character(answer),"\n")
            #
            #   Reset question counter and score for a possible next round
            #
            val$j <- 1
            val$score <- 0
        })  #   end of OK observer
        observeEvent(val$j, {
            val$src <- paste0("http://www.geonames.org/flags/x/",tolower(as.character(answer[val$j])),".gif")
            option1 <- countryInfo$name[countryInfo$iso.alpha2 == selection[val$j,1]]
            option2 <- countryInfo$name[countryInfo$iso.alpha2 == selection[val$j,2]]
            option3 <- countryInfo$name[countryInfo$iso.alpha2 == selection[val$j,3]]
            option4 <- countryInfo$name[countryInfo$iso.alpha2 == selection[val$j,4]]
            val$options <- c(as.character(option1[1]), as.character(option2[1]), as.character(option3[1]), as.character(option4[1]))
        })
        #
        #   plot the flag
        #
        output$image <- renderUI({
            tags$img(src = val$src)
        })
        #
        #   Update the RadioButtons with a new answers to question
        #
        observe({
            x <- input$reply
            updateRadioButtons(session, 'reply', 'From which country is this flag ?', choices = val$options, selected = x)
        })
        #
        #   Wait until the user submits his answer
        #
        observeEvent(input$submit, {
            output$catTest <- renderText({catText})
            isolate({
                if (length(input$reply)) { 
                   if (as.character(countryInfo$name[countryInfo$iso.alpha2 == answer[val$j]][1]) == input$reply) {
                        text <- paste("The answer", input$reply, "was correct.\n")
                        val$score <- val$score + 1
                    } else {
                        text <- paste("The answer", input$reply, "was wrong.\n")
                    }
                } else { text <- "Please select a country"}
            if (val$j < input$questions) {val$j <- val$j +1}
            })  #   end of isolate
            output$text2 <- renderText({text})
        })   #   end of Submit observer
        output$text3 <- renderText({paste("Your score is", min(val$score, input$questions), " out of", input$questions, "(", round(100*(min(val$score, input$questions))/input$questions), "%)\n")})
    }   #   end of in/output function
)   #   end of server