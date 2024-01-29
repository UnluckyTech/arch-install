#!/bin/bash

pacman -S sddm qt5-quickcontrols qt5-graphicaleffects
mkdir /etc/sddm.conf.d
cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf.d/sddm.conf
git clone https://github.com/MarianArlt/sddm-chili
mv sddm-chili /usr/share/sddm/themes/chili
sudo systemctl enable sddm.service
# Path to the sddm.conf file
sddm_conf_path="/etc/sddm.conf.d/sddm.conf"

# Theme name to set
theme_name="chili"

# Check if the sddm.conf file exists
 if [ -e "$sddm_conf_path" ]; then
    # Update the Current theme in sddm.conf
    sed -i "s/^Current=.*/Current=$theme_name/" "$sddm_conf_path"
    echo "SDDM theme updated to $theme_name"
 else
    echo "Error: $sddm_conf_path does not exist."
 fi