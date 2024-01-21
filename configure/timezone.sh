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
    locale_file="/etc/locale.conf"
    locale_line="en_US.UTF-8 UTF-8"
    echo "Entering /etc/locale.gen"
    sed -i "s/^# $locale_line/$locale_line/" "$locale_file"
    locale-gen
    echo LANG=en_US.UTF-8 &gt; /etc/locale.conf
    export LANG=en_US.UTF-8
    echo "Locale configuration updated."
else
    echo "Incorrect region. Please try again."
fi