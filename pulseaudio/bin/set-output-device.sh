#!/bin/sh
#
# Uses PulseAudio CLI utility pacmd to set the default output sink and move all
# the input sinks there

# Check if we have the utility
if ! command -v pacmd > /dev/null 2>&1; then
    echo "pacmd command not found."
    exit 1
fi

# Usage
if [ $# -eq 0 ]; then
    echo "Usage: "
    echo ""
    echo "$0 <default-output-sink>"
    exit 1
fi

# Output sink
output_sink="$1"
echo "Selected output sink: <$1>"

# List current input sinks
trim() { awk '{$1=$1};1'; }

inputs=$(pacmd list-sink-inputs | grep index | cut -d: -f2 | trim)

# Move all inputs to current sink
echo "Moving all input sinks to selected output sink..."
for input in $inputs; do
    echo " - Sink #$input"
    if ! pacmd move-sink-input "$input" "$output_sink"; then
        echo "Unable to move"
        exit 1
    fi
done

# Default sink is the specified one
echo "Setting default sink..."
if ! pacmd set-default-sink "$output_sink"; then
    echo "Unable to set default sink"
    exit 1
fi
echo "Done"
