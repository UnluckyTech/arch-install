#!/bin/bash
ls /usr/share/zoneinfo
echo ""
echo "Enter Region"
read region
if ls /usr/share/zoneinfo/"$region" &> /dev/null; then
    echo "Region is correct. Enter your city: "
    read city
    timezone="$region/$city"
    ln -sf /usr/share/zoneinfo/"$timezone" /etc/localtime
    echo "Timezone set to $timezone."
    echo "Generating Hardware Clock"
    hwclock --systohc
    touch /etc/locale.conf
    locale_file="/etc/locale.conf"
    locale_line="en_US.UTF-8 UTF-8"
    echo "Entering /etc/locale.gen"
    sed -i "s/^# $locale_line/$locale_line/" "$locale_file"
    locale-gen
    touch /etc/locale.conf
    # Specify the desired LANG setting
    new_lang="en_US.UTF-8"

    # Check if /etc/locale.conf exists, create it if not
        if [ ! -f "/etc/locale.conf" ]; then
            sudo touch /etc/locale.conf
        fi

    # Use echo to write the LANG setting to /etc/locale.conf
    echo "LANG=$new_lang" | tee /etc/locale.conf > /dev/null

    # Export the LANG variable
    export LANG=$new_lang

    echo "Locale configuration updated to $new_lang."

else
    echo "Incorrect region. Please try again."
fi