#!/bin/bash



printf "Installing scripts ...\n\n"

sudo cp -r ./scripts_usr_local/bin/* "/usr/local/bin"
sudo cp -r ./scripts_usr_local/lib/* "/usr/local/lib"

sudo chmod 755 /usr/local/bin/mc*
sudo chown root:root /usr/local/bin/mc*

sudo chmod 755 /usr/local/lib/mc*
sudo chown root:root /usr/local/lib/mc*

printf "\nDone...\n\n"

printf "Copying theme file ...\n\n"
sudo cp -r ./mc_dark_theme_kp.ini "/usr/share/mc/skins/mc_dark_theme_kp.ini"
sudo chmod 655 "/usr/share/mc/skins/mc_dark_theme_kp.ini"
sudo chown root:root "/usr/share/mc/skins/mc_dark_theme_kp.ini"

printf "\nDone...\n\n"


printf "Copying Midnight Commander config for current user..."

cp -r ./menu ~/.config/mc/menu
cp -r ./mc.ext ~/.config/mc/mc.ext
cp -r ./filehighlight.ini ~/.config/mc/filehighlight.ini

mkdir ~/.local/share/mc_templates
cp -r ./templates/* ~/.local/share/mc_templates

printf "\nDone...\n\n"



# Install dependencies
if [[ "$1" != "no_deps" ]]; then

    printf "Installing tools/dependencies ...\n"

    sudo cpan -i MIME::Lite
    sudo apt-get install csvkit
    sudo apt-get install antiword
    
    sudo apt-get install apg
    sudo apt-get install bless
    sudo apt-get install pdftk
    sudo apt-get install youtube-dl
    sudo apt-get install wget
    sudo apt-get install lynx
    sudo apt-get install sqlite3
    sudo apt-get install ffmpeg
    sudo apt-get install gtkhash
    sudo apt-get install imagemagick
    sudo apt-get install exif
    sudo apt-get install inxi
    sudo apt-get install htop
    sudo apt-get install pdfgrep
    
    printf "\n\nDone...\n"

fi


