# FlightTracker_R_Telegram
A simple flight tracker that communicates with a Telegram bot, providing live data directly to users' phones.

This script is made to track one plane using its icao number. it'll give you cordinates, altitude and a personal message sent directly to your telegram app at the interval you want it using crontab - you can find a lot of information about icao numbers online or pick one you like from https://www.flightaware.com/ or https://www.flightradar24.com/

Using openskies api (https://opensky-network.org)
If you dont have an account yet, create a new user on opensky-network, (https://opensky-network.org/index.php?option=com_users&view=registration)

For the part of communication to the phone using telegram, youll need an account too.
In my experience its easiest setting it up on the phone by searching "telegram" in the appstore (on iphone) or google play (on android).
Youll need an active phonenumber to registrer.

Then youll need to follow this guide to set up a bot with botfather via telegram: https://core.telegram.org/bots/tutorial#introduction
