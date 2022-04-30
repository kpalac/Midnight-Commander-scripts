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




# Convert image to text. Wrapper for Midnight Commander


clear
LNG="$1"
if [[ "$LNG" = "help" ]]; then
    /usr/bin/tesseract --list-langs
    exit 0
fi


shift



TARGET_DIR="$PWD/Text_extracted_on_$(/bin/date +"%Y-%m-%d %H:%M:%S")"
/bin/mkdir "$TARGET_DIR"


while [ -n "$1" ]; do

    FILE="$1"
    EXT="${FILE##*.}"
    BASENAME="${FILE##*/}"
    BASENAME="${BASENAME%.*}"
    shift
    

    printf %s "Extracting text from "
    printf "\e[1;39m$FILE\e[0;39m" 
    printf %s'\n' ". This may take a while..."
    TEMP="$TCM_TMP_PATH/image$RANDOM$RANDOM$RANDOM.$EXT"
    
    /bin/cp "$FILE" "$TEMP"
    /usr/bin/mogrify -modulate 100,0 -resize 1000% -sharpen 0x.3 "$TEMP"
    /usr/bin/tesseract "$TEMP" "$TARGET_DIR/$BASENAME" -l "$LNG"
    /bin/rm "$TEMP"

done