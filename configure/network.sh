#!/bin/bash

echo "Specify your desired hostname"
read hostname

# Use echo to add the hostname to /etc/hostname
echo "$hostname" | tee /etc/hostname > /dev/null

echo "Hostname set to $hostname."
sleep 2
systemctl enable fstrim.timer

pacman_conf="/etc/pacman.conf"
section="#[multilib]"
mirror="#Include = /etc/pacman.d/mirrorlist"
newmirror="Include = /etc/pacman.d/mirrorlist"

sed -i "" "s/$section/[multilib]/" $pacman_conf
sed -i "" "s/$mirror/$newmirror/" $pacman_conf

echo "Multilib section uncommented in $pacman_conf."
echo "Updating..."
sleep 2
pacman -Sy

