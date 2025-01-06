library(httr)
library(jsonlite)
#### FIND CHAT ID #### 
telegram_token <- "YOUR_TELEGRAM_BOT_TOKEN" #### REMEMBER TO CHANGE IT TO YOUR TELEGRAM BOT TOKEN ####
url <- paste0("https://api.telegram.org/bot", telegram_token, "/getUpdates")
response <- GET(url)

# Parse JSON response
response_content <- fromJSON(content(response, as = "text", encoding = "UTF-8"))



#### TALK TO THE BOT ####
# Define your Telegram bot 
chat_id <- "YOUR_TELEGRAM_BOT_CHAT_ID" #### REMEMBER TO CHANGE THIS TO YOUR TELEGRAM BOT CHAT ID ####
 
# Function to send a message via Telegram bot
send_telegram_message <- function(message) {
  url <- paste0("https://api.telegram.org/bot", telegram_token, "/sendMessage")
  POST(url, body = list(chat_id = chat_id, text = message), encode = "form")
}

# Define the specific ICAO24 number for tracking
icao24 <- "YOUR_ICAO_NUMBER"  #### CHANGE THIS TO THE AIRPLANE YOU WANT TO TRACK ####


# Path to store last known location
last_location_file <- "YOUR_PATH_TO_WHERE_YOU_WANT_TO_SAVE_THE_LAST_LOCATION/last_known_location.txt" #### CHANGE THIS TO YOUR PERSONAL PATH ####


rawres <- GET("https://opensky-network.org/api/states/all", 
              authenticate(user = "YOUR_USERNAME", password = "YOUR_PASSWORD")) #### REMEMBER TO CHANGE THESE TO YOUR USERNAME AND PASSWORD ####

if (status_code(rawres) == 200) {
  # Parse response content
  rescont <- content(rawres, as = "text")
  rescontlist <- fromJSON(rescont)
  df <- as.data.frame(rescontlist$states)
  
  # Set column names
  colnames(df) <- c(
    "icao24", "callsign", "origin_country", "time_position", "last_contact", 
    "longitude", "latitude", "baro_altitude", "on_ground", "velocity", 
    "true_track", "vertical_rate", "sensors", "geo_altitude", 
    "squawk", "spi", "position_source"
  )
  
  # Filter for the specific aircraft by `icao24`
  FlightOp <- df[df$icao24 == icao24, ]
  
  if (nrow(FlightOp) > 0 && FlightOp$on_ground[1] == FALSE) {
    # Only send a message if the aircraft is airborne
    longitude <- FlightOp$longitude[1]
    latitude <- FlightOp$latitude[1]
    altitude <- FlightOp$geo_altitude
    
    message <- paste0(
      format(Sys.time(), "%d-%m-%Y %H:%M:%S"), 
      ", Din valgte flyver: (ICAO24: ", icao24, "), er i luften og på længdegrad: ", 
      longitude, ", breddegrad: ", latitude, ", i ", altitude, " meters højde"
    )
    
    # Send the message via Telegram
    send_telegram_message(message)
  }
}



