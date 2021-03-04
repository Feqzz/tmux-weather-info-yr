# tmux-mpv-info
Displays the current temperature and weather based on your current location. The weather data is provided by the Norwegian Meteorological Institute.
![](https://feqzz.no/img/tmux-weather-info-yr.png)

## Installation
Dependencies:
* socat
* jq

### Installation with Tmux Plugin Manager
Edit your `.tmux.conf` and append the plugin to your TPM list.

```tmux
set -g @plugin 'feqzz/tmux-weather-info-yr'
```
Remember to hit `<prefix> + I` to install the plugin.

### Manual
Clone the repo:
``` bash
git clone https://github.com/feqzz/tmux-weather-info-yr ~/.tmux/
```
Edit your `.tmux.conf` and add this line at the bottom.
``` bash
run-shell ~/.tmux/tmux-weather-info-yr/tmux-weather-info-yr.tmux
```
Last step is to reload the tmux config file.
``` bash
tmux source-file ~/.tmux.conf
```

## Usage
Edit your `.tmux.conf` file and add `#{weather_info_yr}` to your `status-right`. Simple example:
``` tmux
set -g status-right "#{weather_info_yr}"
```

## License
[MIT](LICENSE.md)
