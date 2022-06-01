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

# Cut helper for integration of Nautilus with MC

CLIP_FILE="$HOME/.mc_files.clip"

printf "////cut\n" > "$CLIP_FILE"

printf "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" >> "$CLIP_FILE"

if [[ "$?" == "0" ]]; then
    notify-send "File(s) added to clipboard for moving..."
else
    notify-send "Error!"
fi

