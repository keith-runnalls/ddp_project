library(shiny)

shinyUI(fluidPage(
        titlePanel("Predict Home Value from Distance to Boston Employment Centres"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("sliderDis", "Select the distance to employment centres:", 1, 12, value = 3, step = 0.25),
                        checkboxInput("showModel1", "Show/Hide Linear Model", value = TRUE),
                        checkboxInput("showModel2", "Show/Hide Piecewise Model", value = TRUE),
                        checkboxInput("showModel3", "Show/Hide Polynomial Model", value = TRUE)
                ),
                
                mainPanel(
                        plotOutput("plot1"),
                        h4("Predicted Home Value from Linear Model:"),
                        textOutput("pred1"),
                        h4("Predicted Home Value from Piecewise Model:"),
                        textOutput("pred2"),
                        h4("Predicted Home Value from Polynomial Model:"),
                        textOutput("pred3")
                )
        )
))