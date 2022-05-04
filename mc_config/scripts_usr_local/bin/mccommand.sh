#!/bin/bash






#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#  Author: Karol Pałac (lolko), palac.karol@gmail.com



# Wrapper for Midnight Commander with %f substitution


MODE="$1"
shift
COMMAND="$1"
shift

if [ ! -r "$1" ]; then
    printf "\n\nNo file given!\n\n"
    exit 1
fi

clear





if [ "$MODE" = "each" ]; then

    while [ -r "$1" ]; do
	SNEXT="$1"
	shift

	SNEXT="${SNEXT//\\/\\\\}"
	SNEXT="${SNEXT//\"/\\\"}"
	COMMAND="${COMMAND//%f/\"$SNEXT\"}"
	COMMAND="${COMMAND//%%/\%}"
	if [[ "$COMMAND" != *"\"$SNEXT\""* ]]; then
	    COMMAND="$COMMAND \"$SNEXT\""
	fi
	eval "$COMMAND"
    done






elif [ "$MODE" = "all" ]; then

    #Create list
    while [ -r "$1" ]; do
	SNEXT="$1"
	shift

	SNEXT="${SNEXT//\\/\\\\}"
	SNEXT="${SNEXT//\"/\\\"}"
	SLIST="$SLIST\"$SNEXT\" "
    done
    if [[ "$SLIST" =~ *" " ]]; then
	SLIST="${SLIST%" "}"
    fi

    COMMAND="${COMMAND//%f/$SLIST}"
    if [[ "$COMMAND" != *"$SLIST"* ]]; then
	COMMAND="$COMMAND $SLIST"
    fi
    eval "$COMMAND"

fi




if [[ "$MC_SILENT" != "true" ]]; then
    printf "\n\n\n\t\tPress any key...\n\n"
    read -n1 -s
fi