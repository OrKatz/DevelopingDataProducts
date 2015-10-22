require(googleVis)

#read data
data <- read.csv("data/data.csv")

k_data <- data[,c("Unique_URLS","Total_Number_Requests","Total_Server_OK_Requests","Total_Server_Error_Requests","Total_Client_Eror_Requests")]

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

shinyServer(function(input, output, session) {
        
        # Combine the selected variables into a new data frame
        selectedData <- reactive({
                k_data[1:input$n, c(input$xcol, input$ycol)]
        })
        
        clusters <- reactive({
                kmeans(selectedData(), input$clusters)
        })
        
        output$plot <- renderPlot({
                par(mar = c(5.1, 4.1, 0, 1))
                plot(selectedData(),
                     col = clusters()$cluster,
                     pch = 20, cex = 3)
                points(clusters()$centers, pch = 4, cex = 4, lwd = 4)

        })
        
        output$gvis <- renderGvis({
                reqByCountry <- data[1:input$n,]
                var <- aggregate(reqByCountry["Total_Number_Requests"],by = list(reqByCountry$Country), FUN=sum)
                var$Group.1 <- as.factor(var$Group.1)
                colnames(var) <- c("Country","Number of Requests")
                var["Number of Requests"] <- floor(var["Number of Requests"]/1000)
                gvisGeoMap(var, locationvar="Country", numvar="Number of Requests", options=list( dataMode='regions'))
                         
        })
        
        dataTable <- reactive({
                data[1:100,]
        })
        
        output$table <- renderDataTable(
                {dataTable()}, options = list(bFilter = FALSE, iDisplayLength = 50))
        
        output$downloadData <- downloadHandler(
                filename = 'data.csv',
                content = function(file) {
                        write.csv(dataTable(), file, row.names=FALSE)
                }
        )
        
        
        
})