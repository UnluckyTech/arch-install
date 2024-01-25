#!/bin/bash

echo "Specify your desired hostname"
read hostname

# Use echo to add the hostname to /etc/hostname
echo "$hostname" | tee /etc/hostname > /dev/null

echo "Hostname set to $hostname."
systemctl enable fstrim.timer

echo "Would you like to update repo's used? (y/n)"
read option
if [[ $option == "y" ]]; then
    yes | pacman -S nano bash-completion
    nano /etc/pacman.conf
    pacman -Sy
elif [[ $option == "n" ]]; then
    break
else
    2>/dev/null
    echo 'Incorrect command. Try again.'
fi


