#!/bin/bash


get_partition_syntax() {
    local device=$1

    if [[ $device == /dev/nvme* ]]; then
        echo "${device}p"
    else
        echo "${device}"
    fi
}

while true; do
    echo 'AMD or Intel CPU'
    read option

    if [[ $option == "amd" ]]; then
        pacman -S amd-ucode --noconfirm
        break  # Exit the loop after installing amd-ucode
    elif [[ $option == "intel" ]]; then
        pacman -S intel-ucode --noconfirm
        break  # Exit the loop after installing intel-ucode
    else
        echo 'Incorrect command. Try again.'
    fi
done

pacman -S git refind --noconfirm
echo "Specify drive for rEFInd"
read device
user_device=$(get_partition_syntax "$device")

boot="${user_device}1"
swap="${user_device}2"
root="${user_device}3"

echo "Installing..."
mkdir /efi/EFI
cp -rf /usr/share/refind/ /efi/EFI/refind/
mv /efi/EFI/refind/refind.conf-sample /efi/EFI/refind/refind.conf

# Use sudo blkid to get PARTUUID

partuuid1=$(sudo blkid -s PARTUUID -o value "$boot")
partuuid2=$(sudo blkid -s PARTUUID -o value "$swap")
partuuid3=$(sudo blkid -s PARTUUID -o value "$root")

# Check if PARTUUID is found
if [ -z "$partuuid1" ] || [ -z "$partuuid2" ] || [ -z "$partuuid3" ]; then
    echo "Error: One or more PARTUUIDs not found."
    echo "$partuuid1"
    echo "$partuuid2"
    echo "$partuuid3"
    exit 1
fi

# Print the obtained PARTUUID
echo "PARTUUID for $user_device" 
echo "PARTUUID for $boot: $partuuid1"
echo "PARTUUID for $swap: $partuuid2"
echo "PARTUUID for $root: $partuuid3"


echo "Editing boot config..."
refind_linux_conf="/boot/refind_linux.conf"

# Define the content with the ${user_device} variable
content='
"Boot with standard options"  "rw root=PARTUUID='"${partuuid3}"' mds=full,nosmt add_efi_memmap loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0"
"Boot to single-user mode"    "rw root=PARTUUID='"${partuuid3}"' single mds=full,nosmt add_efi_memmap loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0"
"Boot with minimal options"   "ro root=PARTUUID='"${partuuid3}"' mds=full,nosmt add_efi_memmap loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0"
'

# Use echo to create the file with the specified content
echo "$content" | sudo tee "$refind_linux_conf" > /dev/null
echo "File created: $refind_linux_conf"

# Backup the original refind.conf
cp /efi/EFI/refind/refind.conf /efi/EFI/refind/refind.conf.bak

# Modify the refind.conf with the new options
awk -v partuuid="$partuuid3" '/menuentry "Arch Linux"/,/options/ {sub(/root=[^ ]+/, "root=PARTUUID=" partuuid "\"")} 1' /efi/EFI/refind/refind.conf > /efi/EFI/refind/refind.conf.tmp
# Replace the original file with the modified one
mv /efi/EFI/refind/refind.conf.tmp /efi/EFI/refind/refind.conf

# Path to the refind.conf file
refind_conf="/efi/EFI/refind/refind.conf"

# Define the line to uncomment
use_graphics="use_graphics_for osx,linux"

# Uncomment the line by removing the '#' character at the beginning
sed -i "s/^# $use_graphics/$use_graphics/" "$refind_conf"

echo "Line '$use_graphics' uncommented in refind.conf."

echo "Refind.conf updated successfully!"
mkdir /efi/EFI/refind/themes
cd /efi/EFI/refind/themes
git clone https://github.com/kgoettler/ursamajor-rEFInd.git
echo "include themes/ursamajor-rEFInd/theme.conf" >> /efi/EFI/refind/refind.conf
cd /arch-install
fatlabel ${user_device}1 ARCH
# . /arch-install/plymouth/plymouth.sh
efibootmgr --create --disk ${device} --part 1 --loader /EFI/refind/refind_x64.efi --label "rEFInd Boot Manager" --unicode
echo "Done! Hopefully it works!"