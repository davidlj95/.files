#!/bin/bash

# <bitbar.title>Kraken.com price tickers</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>davidlj95</bitbar.author>
# <bitbar.author.github>davidlj95</bitbar.author.github>
# <bitbar.desc>Last selected tickers from Kraken.com</bitbar.desc>
# <bitbar.image>https://i.imgur.com/iGX2yjR.png</bitbar.image>
# <bitbar.dependencies>bash</bitbar.dependencies>
#

# Tickers
TICKERS="XBTEUR XBTEUR XBTUSD ETHEUR XMREUR"

# Constants
API_ENDPOINT="https://api.kraken.com/0/public"
CRYPTOWATCH_URL="https://cryptowat.ch/markets/kraken"
KRAKEN_LOGO="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAGUExURQAAAFhB2Kai4mUAAAABdFJOUwBA5thmAAAALElEQVQY02NgIBswMqJxQQCdjxBhZEQVYWREEwFSUB5CgAGKiBUAC4IRmQAAJfwARW3AzG4AAAAASUVORK5CYII="

# Currency symbols, you can define moar
EUR_SYMBOL="€"
USD_SYMBOL="$"
XBT_SYMBOL="₿"
ETH_SYMBOL="Ξ"
XMR_SYMBOL="ɱ"

# Gets tickers information from Kraken
# Arguments: Tickers you want to fetch
# Response:  { error: [], result: {} }
# See also:  https://www.kraken.com/features/api#get-ticker-info
get_tickers_info() {
    tickers="$(echo "$@" | tr ' ' ,)"
    API_URL="$API_ENDPOINT/Ticker?pair=$tickers"
    curl -s "$API_URL"
}

get_last_price_by_ticker() {
    ticker="$1"
    echo "$tickers" | jq -r ".$ticker.c[0]" | tr . ,
}

get_last_day_avg_price_by_ticker() {
    ticker="$1"
    echo "$tickers" | jq -r ".$ticker.p[1]" | tr . ,
}

real_to_int() {
    printf "%.0f" "$1"
}

get_ticker_color() {
    last_price_int="$(real_to_int "$1")"
    last_day_avg_price_int="$(real_to_int "$2")"
    color="\033[;32m"
    if [ "$last_price_int" -lt "$last_day_avg_price_int" ]; then
        color="\033[;31m"
    fi
    echo "$color"
}

get_ticker_icon() {
    last_price_int="$(real_to_int "$1")"
    last_day_avg_price_int="$(real_to_int "$2")"
    icon=":chart_with_upwards_trend:"
    if [ "$last_price_int" -lt "$last_day_avg_price_int" ]; then
        icon=":chart_with_downwards_trend:"
    fi
    echo "$icon"
}

print_conversion() {
    src_currency="$1"
    dst_currency="$2"
    [ -n "$3" ] && src_symbol="$3" || src_symbol=" $src_currency"
    [ -n "$4" ] && dst_symbol="$4" || dst_symbol=" $dst_currency"

    ticker="X${src_currency}Z${dst_currency}"
    url="$CRYPTOWATCH_URL/${src_currency}/${dst_currency}"
    last_price="$(get_last_price_by_ticker "$ticker")"
    last_day_avg_price="$(get_last_day_avg_price_by_ticker "$ticker")"
    icon="$(get_ticker_icon "$last_price" "$last_day_avg_price")"
    color="$(get_ticker_color "$last_price" "$last_day_avg_price")"

    echo "$(printf "%s %s1%s = %'.0f%s\n" \
         "$icon" "$color" "$src_symbol" "$last_price" "$dst_symbol") \
         | size=13 href=\"$url\""
}

print_tickers() {
    tickers_info="$(get_tickers_info "$@")"
    tickers="$(echo "$tickers_info" | jq .result)"
    first="true"
    while [ $# -gt 0 ]; do
        src_currency="$(echo "$1" | cut -c1-3)"
        dst_currency="$(echo "$1" | cut -c4-6)"
        src_symbol="$(eval "echo \$${src_currency}_SYMBOL")"
        dst_symbol="$(eval "echo \$${dst_currency}_SYMBOL")"
        print_conversion "$src_currency" "$dst_currency" "$src_symbol" "$dst_symbol"
        [ "$first" = "true" ] && echo "---" && first="false"
        shift
    done
}

# Get tickers info
print_tickers $TICKERS
echo "Moar on Kraken.com | href=\"https://www.kraken.com/\" image=$KRAKEN_LOGO"
echo ":computer:    Made by @davidlj95 | href=\"https://www.davidlj95.com\""
