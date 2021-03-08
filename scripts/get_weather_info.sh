#!/usr/bin/env bash
CACHE_OUTPUT=/tmp/weather-result-cache.txt
CACHE_OUTPUT_CITY=/tmp/tmux-weather-info-yr-city.txt
CACHE_OUTPUT_SYMBOL=/tmp/tmux-weather-info-yr-symbol.txt
CACHE_OUTPUT_SYMBOL_PLAINTEXT=/tmp/tmux-weather-info-yr-symbol-plaintext.txt
AGE_TO_CACHE="600" #10 minutes

if [ -f "$CACHE_OUTPUT" ] && [ $(($(date +%s) - $(stat --format=%Y "$CACHE_OUTPUT"))) -le "$AGE_TO_CACHE" ] 
then
	cat "$CACHE_OUTPUT"
	exit 0
fi
(
IP_API=$(curl -s 'http://ip-api.com/json/')
LATITUDE=$(echo "$IP_API" | jq -r '.lat')
LONGITUDE=$(echo "$IP_API" | jq -r '.lon')
CITY=$(echo "$IP_API" | jq -r '.city')
echo "$CITY" > $CACHE_OUTPUT_CITY

YR_QUERY="curl -s 'https://api.met.no/weatherapi/locationforecast/2.0/compact?lat="$LATITUDE"&lon="$LONGITUDE"'"
YR=$(eval $YR_QUERY)
TEMPERATURE=$(echo "$YR" | jq -r '.properties.timeseries[0].data.instant.details.air_temperature')
SYMBOL=$(echo "$YR" | jq -r '.properties.timeseries[0].data.next_1_hours.summary.symbol_code')
TEMP_INTEGER=${TEMPERATURE%.*}
echo "$SYMBOL" > $CACHE_OUTPUT_SYMBOL_PLAINTEXT

if [ "$TEMP_INTEGER" -eq "-0" ]
then
	TEMP_INTEGER="0"
fi

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

echo "$SYMBOL" > $CACHE_OUTPUT_SYMBOL

printf "%s\n" "$TEMP_INTEGER°C"
) > $CACHE_OUTPUT
