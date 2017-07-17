
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinysense)
library(shinythemes)
library(tidyverse)

source("helpers.R")

###### Constants
param_res     <- 30
number_xs     <- 50
alpha_range   <- c(0,8)
beta_range    <- c(0,8)
initial_betas <- generate_beta_values(num_x = number_xs, param_res, alpha_range, beta_range)


shinyServer( function(input, output) {
    
    random_data <- data_frame(
      prob    = seq(0, 1, length.out = number_xs),
      y_value = 0
    )
    
    #server side call of the drawr module
    drawChart <- callModule(shinydrawr,
                            "user_distribution",
                            random_data,
                            raw_draw = T,
                            x_key = "prob",
                            y_key = "y_value",
                            y_max = 4)
    
    #logic for what happens after a user has drawn their values. Note this will fire on editing again too.
    observeEvent(drawChart(), {
      drawnValues = drawChart()
      
      drawn_data <- random_data %>%
        mutate(drawn = drawnValues) %>%
        select(x = prob, y_drawn = drawn)
      
      best_beta_fit <- find_fit_plot(drawn_data, initial_betas, param_res)
      
      output$best_beta_fit <- renderPlot({ best_beta_fit$plot })
      output$beta_value <- renderText({
        as.character(best_beta_fit$shape2)
      })
      
      output$alpha_value <- renderText({
        as.character(best_beta_fit$shape1)
      })
      
      output$displayDrawn <- renderTable(drawn_data)
      
      output$downloadData <- downloadHandler(
        filename = "my_drawing.csv",
        content = function(file)  write.csv(drawn_data, file)
      )
    }) #close observe event. 
})

