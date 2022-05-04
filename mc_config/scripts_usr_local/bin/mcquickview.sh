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


# Quick viewer for Midnight Commander helper scripts



FILE="$1"

MIMETYPE="$(/usr/bin/mimetype -b "$FILE")"


if [[ "$MIMETYPE" == "image/"* ]]; then
    /usr/local/bin/mcfehview.sh "$FILE" 2>&1 > "$MC_LOG_FILE"
elif [[ "$MIMETYPE" == "image/svg"* ]]; then
    /usr/local/bin/mcim6view.sh "$FILE" 2>&1 > "$MC_LOG_FILE"
elif [[ "$MIMETYPE" == "audio/"* ]]; then
    /usr/local/bin/mcfileinfo "$FILE" | less -R
elif [[ "$MIMETYPE" == "video/"* ]]; then
    /usr/local/bin/mcfileinfo "$FILE" | less -R

elif [[ "$MIMETYPE" == "application/pdf" ]]; then
    /usr/local/bin/mcpdfview.sh "$FILE" | less
elif [[ "$MIMETYPE" == *"/postscript" ]]; then
    /usr/local/bin/psview.sh "$FILE" | less
elif [[ "$MIMETYPE" == "application/epub+zip" ]]; then
    /usr/local/bin/mcepubparse.pl text "$FILE" | less


elif [[ "$MIMETYPE" == "application/msword" ]]; then
    /usr/bin/antiword "$FILE" | less -R
elif [[ "$MIMETYPE" == "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ]]; then
    /usr/local/bin/mcdocxparse.pl "$FILE" | less
elif [[ "$MIMETYPE" == "application/vnd.oasis.opendocument.text" ]]; then
    /usr/local/bin/mcodtparse.pl "$FILE" | less
elif [[ "$MIMETYPE" == "application/vnd.oasis.opendocument.spreadsheet" ]]; then
    /usr/local/bin/mcodsparse.pl "$FILE" | less
elif [[ "$MIMETYPE" == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ]]; then
    /usr/local/bin/mcxslxparse.pl "$FILE" | less
elif [[ "$MIMETYPE" == "application/vnd.ms-excel" ]]; then
    /usr/bin/xls2csv "$FILE"  | less
elif [[ "$MIMETYPE" == "application/x-sqlite3" ]]; then
    /usr/local/bin/mcsqliteview.sh "$FILE" | less
elif [[ "$MIMETYPE" == "text/html" ]]; then
    /usr/bin/w3m -dump "$FILE" | less 
    

else
    MIMETYPE="$(file --mime-type "$FILE")"

    if [[ "$MIMETYPE" =~ "text/"* ]]; then
        less "$FILE"
    else
        /usr/local/bin/mcfileinfo "$FILE" | less -R
    fi    

fi