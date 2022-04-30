#!/bin/bash


#  Wrapper for viewing images



SFIRST=""
MANY="false"


    #Create list
    while [ -n "$1" ]; do
	SNEXT="$1"
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

printf "$SFIRST"


if [ -d "$SFIRST" ]; then
    #Display bitmaps
    /usr/bin/find "$SFIRST" -type f -regextype posix-egrep -iregex '.*\.(bmp|x[pb]m|ico|svg|ico|icon|bitmap|pc[xc])' -exec /usr/bin/display-im6 {} + &
else
    eval "(/usr/bin/display-im6 $SLIST &) &"
fi






