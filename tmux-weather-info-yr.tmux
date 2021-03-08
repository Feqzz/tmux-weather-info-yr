#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/scripts/helpers.sh"

weather_temperature="#($CURRENT_DIR/scripts/get_weather_info.sh)"
weather_temperature_interpolation="\#{weather_temperature}"

weather_symbol="#($CURRENT_DIR/scripts/get_symbol.sh)"
weather_symbol_interpolation="\#{weather_symbol}"

weather_symbol_plaintext="#($CURRENT_DIR/scripts/get_symbol_plaintext.sh)"
weather_symbol_plaintext_interpolation="\#{weather_symbol_plaintext}"

weather_city="#($CURRENT_DIR/scripts/get_city.sh)"
weather_city_interpolation="\#{weather_city}"

do_interpolation() {
  local string=$1
  local string=${string/$weather_symbol_interpolation/$weather_symbol}
  local string=${string/$weather_symbol_plaintext_interpolation/$weather_symbol_plaintext}
  local string=${string/$weather_city_interpolation/$weather_city}
  local string=${string/$weather_temperature_interpolation/$weather_temperature}
  echo "$string"
}

update_tmux_option() {
  local option="$1"
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}

main
