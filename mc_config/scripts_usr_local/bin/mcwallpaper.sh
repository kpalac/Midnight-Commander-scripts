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


# Desktop background changer for Midnight Commander


. /usr/local/lib/mcglobals


FILE="$1"
if [[ ! -f "$FILE" ]]; then
    printf "File does not exist!"
fi

FILE="$(readlink -f "$FILE")"


if [[ "$XDG_CURRENT_DESKTOP" =~ "GNOME"* ]]; then

    printf %s "file://$(TF_UrlEncode "$FILE")"
    
    gsettings set org.gnome.desktop.background draw-background false && gsettings set org.gnome.desktop.background picture-uri "file://$(TF_UrlEncode "$FILE")" && gsettings set org.gnome.desktop.background draw-background true

elif [[ -f /usr/bin/feh ]]; then

    /usr/bin/feh --bg-fill "$FILE"

else
    printf "Could not find appropriate method to change desktop background"
fi
    

