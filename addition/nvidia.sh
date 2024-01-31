#!/bin/bash

echo "NOTE: This is for Nvidia!"
echo "Ctrl+C to exit."
sleep 2
sudo yes | pacman -S git linux-headers --noconfirm
sudo yes | pacman -S nvidia-dkms libglvnd nvidia-utils opencl-nvidia lib32-libglvnd lib32-nvidia-utils lib32-opencl-nvidia nvidia-settings --noconfirm
echo "Modifying mkinitcpio config..."
sudo nano /etc/mkinitcpio.conf
sudo mkdir /etc/pacman.d/hooks
sudo touch /etc/pacman.d/hooks/nvidia.hook
hook_content="[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia

[Action]
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -P
"

# Specify the file path
hook_file="/etc/pacman.d/hooks/nvidia.hook"

# Use echo to write the content to the file
echo "$hook_content" | sudo tee "$hook_file" > /dev/null

echo "nvidia.hook file created at $hook_file."