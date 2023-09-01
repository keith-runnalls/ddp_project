library(shiny)

data("Boston", package = "MASS")

shinyServer(function(input, output) {
        Boston$dissp <- ifelse(Boston$dis - 2.5 > 0, Boston$dis - 2.5, 0)
        model1 <- lm(medv ~ dis, data = Boston)
        model2 <- lm(medv ~ dissp + dis, data = Boston)
        model3 <- lm(medv ~ dis + I(dis^2) + I(dis^3), data = Boston)
        
        model1pred <- reactive({
                disInput <- input$sliderDis
                predict(model1, newdata = data.frame(dis = disInput))
        })
        
        model2pred <- reactive({
                disInput <- input$sliderDis
                predict(model2, newdata = 
                                data.frame(dis = disInput,
                                           dissp = ifelse(disInput - 2.5 > 0,
                                                          disInput - 2.5, 0)))
        })
        
        model3pred <- reactive({
                disInput <- input$sliderDis
                predict(model3, newdata = data.frame(dis = disInput))
        })
        
        output$plot1 <- renderPlot({
                disInput <- input$sliderDis
                
                plot(Boston$dis, Boston$medv, xlab = "Mean distance to employment centres", 
                     ylab = "Median home value in $1000s", bty = "n", pch = 16,
                     xlim = c(0, 13), ylim = c(0, 55))
                
                if(input$showModel1) {
                        model1lines <- predict(model1, newdata = data.frame(
                                dis = 1:12))
                        lines(1:12, model1lines, col = "blue", lwd = 3)
                }
                
                if(input$showModel2) {
                        model2lines <- predict(model2, newdata = data.frame(
                                dis = 1:12, dissp = ifelse(1:12 - 2.5 > 0, 1:12 - 2.5, 0)
                        ))
                        lines(1:12, model2lines, col = "orange", lwd = 3)
                }
                
                if(input$showModel3) {
                        model3lines <- predict(model3, newdata = data.frame(
                                dis = 1:12))
                        lines(1:12, model3lines, col = "red", lwd = 3)
                }
                
                legend(8, 15, c("Linear Model", "Piecewise Model", "Polynomial Model"), pch = 16, 
                       col = c("blue", "orange", "red"), bty = "n", cex = 1.2)
                points(disInput, model1pred(), col = "blue", pch = 16, cex = 2)
                points(disInput, model2pred(), col = "orange", pch = 16, cex = 2)
                points(disInput, model3pred(), col = "red", pch = 16, cex = 2)
        })
        
        output$pred1 <- renderText({
                c("$", round(1000 * model1pred()))
        })
        
        output$pred2 <- renderText({
                c("$", round(1000 * model2pred()))
        })
        
        output$pred3 <- renderText({
                c("$", round(1000 * model3pred()))
        })
})