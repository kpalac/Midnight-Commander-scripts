#!/bin/bash



FILE="$1"

TEMP="/tmp/mc-$USER/mc_view_tmp_$RANDOM""$RANDOM"".txt"

if [[ -d "/tmp/mc-$USER" ]]; then
    /bin/rm "/tmp/mc-$USER/"mc_view_tmp_*
fi

/usr/bin/pdftotext -layout "$FILE" "$TEMP"
/bin/cat "$TEMP"