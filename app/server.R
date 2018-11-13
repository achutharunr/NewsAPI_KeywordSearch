
server <- function(input, output){
  
  #Waiting for click of go_search button
  news <- observeEvent(eventExpr = input$go_search,
                       handlerExpr = {
                         
                         #Checking if an input has been entered
                         if(!is.na(input$keyword) & input$keyword != "")
                         {
                           #Replacing spaces to "+" to suit API querying format
                           keyword <- gsub(pattern = " ", x = input$keyword, replacement = "+")
                           
                           #API URL with keyword, date and sorting information to pull out news articles
                           url = paste0('https://newsapi.org/v2/everything?',
                                        "q='",keyword,"'&",
                                        'sources=reuters&bloomberg&',
                                        'sortBy=relevance&',
                                        'apiKey=7e01de3bf9cb480e9ba924c07ef0a9c1')
                           
                           #Collecting results of query from API connection
                           news_list <- readLines(url, warn = F)
                           
                           #Converting JSON string to R list
                           news_list <- fromJSON(news_list)
                           
                           #Checking if the query returned any relevant articles
                           if(!class(news_list$articles) == "list")
                           {
                             #Extracting dataframe containing article information
                             df_news <- news_list[[3]]
                             
                             #Select only top 10 articles
                             if(nrow(df_news) > 10)
                             {
                               df_news <- df_news[1:10, ]
                             }
                             
                             #Clearing news_reel of existing articles that may be present
                             removeUI(selector = "#inserted_news_reel")
                             
                             #Assigning output of df_news to dataframe df
                             df <- df_news
                             
                             #Creating empty vector to store 
                             news_reel_html <- ""
                             
                             #Looping to create HTML code
                             for(i in seq(1, nrow(df), 1))
                             {
                               #Removing patterns like <8a><e6><87>
                               title <- gsub(pattern = "<.{2}>", replacement = "", x = df$title[i])
                               
                               #Title tags with link to article
                               title_html <- tags$a(href = df$url[i], target="_target", tags$h4(title))
                               
                               #Image from link
                               image_html <- tags$img(src = df$urlToImage[i], height = "80", width = "80")
                               
                               #Article description
                               
                               desc_html <- tags$p(df$description[i])
                               
                               #Setting image and link side by side
                               fluidRow_html <- doRenderTags(fluidRow(
                                 column(1, image_html),
                                 column(6, title_html,desc_html)
                               ))
                               
                               #Final HTML code
                               news_reel_html <- paste0(news_reel_html, fluidRow_html, tags$hr())
                             }
                             
                             #Inserting to UI
                             insertUI(selector = "#news_reel",
                                      #UI code to be inserted
                                      ui = tags$div(id = "inserted_news_reel",
                                                    HTML(news_reel_html))
                             )
                           }else{
                             
                             #Clearing news_reel of existing articles that may be present
                             removeUI(selector = "#inserted_news_reel")
                             
                             #Passing the message to the user that no articles were found
                             insertUI(selector = "#news_reel",
                                      #UI code to be inserted
                                      ui = tags$div(id = "inserted_news_reel",
                                                    tags$h5("No relevant news articles found")))
                           }
                         }
                       })
}
