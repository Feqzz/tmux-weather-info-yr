#!/bin/bash
CACHE_OUTPUT=/tmp/weather-result-cache.txt
AGE_TO_CACHE="600" #10 minutes

if [ -f "$CACHE_OUTPUT" ] && [ $(($(date +%s) - $(stat --format=%Y "$CACHE_OUTPUT"))) -le "$AGE_TO_CACHE" ] 
then
	cat "$CACHE_OUTPUT"
	exit 0
fi
(
LATITUDE=$(curl -s 'http://ip-api.com/json/' | jq -r '.lat')
LONGITUDE=$(curl -s 'http://ip-api.com/json/' | jq -r '.lon')
CITY=$(curl -s 'http://ip-api.com/json/' | jq -r '.city')

YR="curl -s 'https://api.met.no/weatherapi/locationforecast/2.0/compact?lat="$LATITUDE"&lon="$LONGITUDE"' | jq -r '.properties.timeseries[0].data.instant.details.air_temperature'"
SYMBOL_QUERY="curl -s 'https://api.met.no/weatherapi/locationforecast/2.0/compact?lat="$LATITUDE"&lon="$LONGITUDE"' | jq -r '.properties.timeseries[0].data.next_1_hours.summary.symbol_code'"
TEMPERATURE=$(eval $YR)
TEMP_INTEGER=${TEMPERATURE%.*}
SYMBOL=$(eval $SYMBOL_QUERY)

case $SYMBOL in
	clearsky*)
		SYMBOL="☀️"
		;;
	cloudy|fog)
		SYMBOL="☁️"
		;;
	fair*)
		SYMBOL="🌤️"
		;;
	heavyrain|lightrain|rain|sleet)
		SYMBOL="🌧️"
		;;
	heavysleetshowers*|heavyrainshowers*|lightrainshowers*|rainshowers*|sleetshowers*)
		SYMBOL="🌦️"
		;;
	partlycloudy*)
		SYMBOL="🌥️"
		;;
	heavysleetandthunder|heavyrainandthunder|heavyrainshowersandthunder*|heavysleetshowersandthunder*|lightrainshowersandthunder*|rainshowersandthunder*)
		SYMBOL="⛈️"
		;;
	heavysnow|lightsleet|lightsnow|snow)
		SYMBOL="🌨️"
		;;
esac

printf "%s\n" "$SYMBOL $TEMP_INTEGER°C"
) > $CACHE_OUTPUT
