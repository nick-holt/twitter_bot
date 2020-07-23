#------------------------------------------------------
# NFL_Reaper bot for Twitter
#
# Created by: Nick Holt; @na_holt
# July 30th, 2019
#------------------------------------------------------

# Install and load the appropriate packages
library(rtweet)
library(dplyr)
library(magrittr)
library(stringr)
library(lubridate)
# source("reaper_bot_keys.R")

players <- readr::read_csv("https://raw.githubusercontent.com/nick-holt/perfect_draft/master/2019%20ADP%20Data%20(FantasyPros).csv") %>% 
        filter(!is.na(ADP)) %>% 
        bind_rows(data.frame(Player = c("Steven Sims"),
                             ADP = c(188)))

print(paste0("############################### TIME STAMP #############################################"))
print(paste0("################## Process executed at: ", now("Etc/GMT+5"), " ############################"))
print(paste0("########################################################################################"))

#Extract Tweets !
tweets <- search_tweets(
        "carted off", n = 500, include_rts = FALSE
) 



tweets <- tweets  %>% 
        filter(grepl(paste(players$Player, collapse="|"), text)) %>%
        filter(retweet_count > 10) %>%
        filter(lang == "en") %>%
        mutate(created_at_eastern_tz = with_tz(created_at, "Etc/GMT+5"),
               age = (now("Etc/GMT+5")-created_at_eastern_tz)) %>%
        filter(age < 60)

#skull_emoji <- rtweet::emojis %>%
#filter(str_detect(description, "skull"))

#amb_emoji <- rtweet::emojis %>%
#filter(str_detect(description, "ambulance"))

#message <- paste("Reaper alert", skull_emoji[[1,1]], skull_emoji[[1,1]], skull_emoji[[1,1]], amb_emoji[[1,1]], amb_emoji[[1,1]], amb_emoji[[1,1]], skull_emoji[[1,1]], skull_emoji[[1,1]], skull_emoji[[1,1]], amb_emoji[[1,1]], amb_emoji[[1,1]], amb_emoji[[1,1]], "#FantasyFootball", "#NFL")
#message

#post_tweet(message, media = tweets$url[1])

# loop through tweets and retweet
if(!is.na(tweets[1,1])){ 
        for(i in seq_along(tweets$status_id)){
                
                id <- tweets$status_id[i]
                post_tweet(retweet_id = id)
                
        }
} else {
        print("no tweets matching criterion found")
}

print(paste0("############################### TIME STAMP #############################################"))
print(paste0("################## Process finished at: ", now("Etc/GMT+5"), " ############################"))
print(paste0("########################################################################################"))
