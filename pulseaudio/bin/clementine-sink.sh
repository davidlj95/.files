#!/bin/sh
#
# Finds the clementine PulseAudio input sink index
#
clementine_sink=$(
    pacmd list-sink-inputs |
    grep -B16 Clementine |
    grep index |
    cut -d: -f2 |
    awk '{$1=$1};1')

if [ -z "$clementine_sink" ]; then
    echo "Clementine sink not found"
    exit 1
else
    echo "$clementine_sink"
fi
