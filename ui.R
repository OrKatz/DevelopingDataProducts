shinyUI(fluidPage(
        
        titlePanel("Traffic Analysis"),
        sidebarPanel(
                wellPanel(
                        sliderInput("n", "Number of Internet Resources:",
                                    min = 10, max = nrow(k_data), value = 50, step = 10)),
                selectInput('xcol', 'X Clustered Feature', names(k_data)),
                selectInput('ycol', 'Y Clustered Feature', names(k_data),
                            selected=names(data)[[2]]),
                numericInput('clusters', 'Cluster count', 3,
                             min = 1, max = 9)
        ),
        mainPanel(
                tabsetPanel(
                        tabPanel(p(icon("line-chart"),"K-Means Features Clustering"),
                                 plotOutput('plot'),
                                 p("K-Means clustering by the chosen features")
                                 
                                 ), 
                        tabPanel(p(icon("map-marker"),"Requests Distribution By Country"),
                                 htmlOutput("gvis"),
                                 p("Number of requests per country by thousand, based omn the number of Internet resources (slider)")
                                 ),
                        tabPanel(p(icon("table"), "Data Samples"),
                                 dataTableOutput(outputId="table"),
                                 downloadButton('downloadData', 'Download')
                                )
                )
                
                
        )
))