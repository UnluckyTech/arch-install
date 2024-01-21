#!/bin/bash

Echo "Specify your desired hostname"
read hostname

# Use echo to add the hostname to /etc/hostname
echo "$hostname" | sudo tee /etc/hostname > /dev/null

echo "Hostname set to $hostname."
sleep 2
systemctl enable fstrim.timer

pacman_conf="/etc/pacman.conf"
section="[multilib]"
sed -i "/^# $section/,/^#$/ s/^#//" "$pacman_conf"

echo "Multilib section uncommented in $pacman_conf."
echo "Updating..."
sleep 2
pacman -Sy

