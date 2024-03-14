#!/bin/bash

pacman -S plymouth --noconfirm

# Path to mkinitcpio.conf
mkinitcpio_conf="/etc/mkinitcpio.conf"

if grep -q "plymouth" "$mkinitcpio_conf"; then
    echo "Plymouth hook is already present in $mkinitcpio_conf."
else
    # Add plymouth hook to HOOKS array
    sed -i '/^HOOKS=/ s/\(filesystems \)/\1plymouth /' "$mkinitcpio_conf"
    echo "Added Plymouth hook to $mkinitcpio_conf."
fi

mkinitcpio -P
rm -rf /usr/share/plymouth/themes/spinner/watermark.png
rm -rf /usr/share/plymouth/themes/spinner/spinner.plymouth
cp -r /arch-install/plymouth/spinner.plymouth /usr/share/plymouth/themes/spinner/spinner.plymouth
sudo cp -r /boot/EFI/refind/themes/ursamajor-rEFInd/icons/os_arch.png /usr/share/plymouth/themes/spinner/watermark.png

sudo plymouth-set-default-theme -R spinner