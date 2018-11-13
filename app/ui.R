
ui <- fluidPage(textInput(inputId = "keyword", label = "", placeholder = "Search"),
                actionButton(inputId = "go_search", label = "Go"),
                tags$hr(),
                br(),
                br(),
                tags$div(id = "news_reel")
)