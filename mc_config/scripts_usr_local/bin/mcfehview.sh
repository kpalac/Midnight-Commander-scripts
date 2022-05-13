#!/bin/bash


#  Wrapper for viewing images



SFIRST=""
MANY="false"


    #Create list
    while [ -n "$1" ]; do
	SNEXT="$1"
	[[ "$MANY" = "false" && -n "$2" ]] && MANY="true"
	shift

	SNEXT="$(/bin/readlink -f "$SNEXT")"
	SNEXT="${SNEXT//\\/\\\\}"
	SNEXT="${SNEXT//\"/\\\"}"

	[[ "$SFIRST" = "" ]] && SFIRST="$SNEXT"

	SLIST="$SLIST\"$SNEXT\" "
    done
    if [[ "$SLIST" =~ *" " ]]; then
	SLIST="${SLIST%" "}"
    fi


if [ -d "$SFIRST" ]; then
    eval "(/usr/bin/feh -P --scale-down -B black -r \"$SFIRST\"/ &) &"

    #Display bitmaps
elif [ "$MANY" = "false" ]; then
    DIR="${SFIRST%/*}"
    eval "(/usr/bin/feh -P --scale-down -B black --start-at \"$SFIRST\" \"$DIR\"/ &) &" &

else
    #Display images and bitmaps
    eval "(/usr/bin/feh -P --scale-down -B black $SLIST &) &"
fi






