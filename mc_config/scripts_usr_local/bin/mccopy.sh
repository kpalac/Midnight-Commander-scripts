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


# Copy-paste handler for Midnight Commander


. /usr/local/lib/mcglobals


MODE="$1"
shift

CLIP_FILE="$HOME/.mc_files.clip"

# Detect Nautilius and copy utility scripts if needed
if [[ -x /usr/bin/nautilus ]]; then
    NAUTILUS="true"
    if [[ ! -f ~/.local/share/nautilus/scripts/"Copy (MC)" ]]; then
        cp /usr/local/lib/mc_nautilus_copy.sh ~/.local/share/nautilus/scripts/"Copy (MC)"
        chmod 750 ~/.local/share/nautilus/scripts/"Copy (MC)"
    fi
    if [[ ! -f ~/.local/share/nautilus/scripts/"Paste (MC)" ]]; then
        cp /usr/local/lib/mc_nautilus_paste.sh ~/.local/share/nautilus/scripts/"Paste (MC)"
        chmod 750 ~/.local/share/nautilus/scripts/"Paste (MC)"
    fi
    if [[ ! -f ~/.local/share/nautilus/scripts/"Cut (MC)" ]]; then
        cp /usr/local/lib/mc_nautilus_cut.sh ~/.local/share/nautilus/scripts/"Cut (MC)"
        chmod 750 ~/.local/share/nautilus/scripts/"Cut (MC)"
    fi


else
    NAUTILUS="false"
fi



declare -a FILES



if [[ "$MODE" == "copy" || "$MODE" == "cut" ]]; then

    clear

    /usr/bin/xclip-copyfile -p "$@"

    printf "////$MODE\n" > "$CLIP_FILE"

    while [ -n "$1" ]; do
        FILE="$(readlink -f "$1")"
        printf "$FILE\n" >> "$CLIP_FILE"
        if [[ "$?" == "0" ]]; then
            if [[ "$MODE" == "copy" ]]; then 
                printf "File $FILE added to copy clipboard...\n"
            else
                printf "File $FILE added to moving clipborard...\n"
            fi
        else
            exit 1
        fi
        shift
    done   
    


elif [[ "$MODE" == "paste" ]]; then

    [[ ! -f "$CLIP_FILE" ]] && exit 0

    clear
    TEMP="$(< "$CLIP_FILE")"
    mapfile -t FILES < <( printf "$TEMP" )

    if [[ "${FILES[0]}" == '////copy' ]]; then
        MODE="copy"
    elif [[ "${FILES[0]}" == '////cut' ]]; then
        MODE="cut"
    fi
        
    LOCAL_DIR="$(pwd)"


    for FILE in "${FILES[@]}"; do

        [[ "$FILE" == "////"* ]] && continue

        BASENAME="${FILE##*/}"
        TARGET="$(MCF_FileName "$LOCAL_DIR" "$BASENAME")"
        TARGET="$LOCAL_DIR/$TARGET"    

        if [[ "$MODE" == "copy" ]]; then
            
            cp "$FILE" "$TARGET"

            if [[ "$?" == "0" ]]; then
                printf "File $FILE copied to $TARGET ...\n"            
            else
                exit 1
            fi

        elif [[ "$MODE" == "cut" ]]; then

            mv "$FILE" "$TARGET"
            if [[ "$?" == "0" ]]; then
                printf "File $FILE moved to $TARGET ...\n"            
            else
                exit 1
            fi

        fi

    done


fi


if [[ "$MC_SILENT" != "true" ]]; then
    printf '\n\t\t'%s'\n' "Press any key..."
    read -n 1 -s
fi

