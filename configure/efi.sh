#!/bin/bash

mkdir /boot/EFI/refind
cp -rf /usr/share/refind_x64.efi
cp -rf /boot/EFI/BOOT/themes
cp -rf /boot/EFI/BOOT/refind.conf
cp -rf /boot/EFI/BOOT/icons
cp -rf /boot/EFI/BOOT/drivers_x64
cp -rf /boot/EFI/BOOT/fonts
efibootmgr --create --disk ${device} --part 1 --loader /EFI/refind/refind_x64.efi --label "rEFInd Boot Manager" --unicode




