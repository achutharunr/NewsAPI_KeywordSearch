library(jsonlite)

url = paste0('https://newsapi.org/v2/everything?',
       'q=Wells+Fargo&',
       'from=2018-11-12&',
       'sortBy=popularity&',
       'apiKey=7e01de3bf9cb480e9ba924c07ef0a9c1')

cnn<-fromJSON(url, proxy = "proxy.wellsfargo.com")

df <- cnn[[3]]
