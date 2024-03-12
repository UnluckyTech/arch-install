#!/bin/bash


get_partition_syntax() {
    local device=$1

    if [[ $2device == /dev/nvme* ]]; then
        echo "${device}p"
    else
        echo "${device}"
    fi
}

pacman -S intel-ucode git refind --noconfirm
echo "Specify drive for rEFInd"
read device
user_device=$(get_partition_syntax "$device")

boot="${user_device}1"
swap="${user_device}2"
root="${user_device}3"

echo "Installing..."

# Check if user_device is defined
if [ -z "$user_device" ]; then
    echo "Error: user_device not defined."
    exit 1
fi

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
"Boot with standard options"  "rw root=PARTUUID='"${partuuid3}"'"
"Boot to single-user mode"    "rw root=PARTUUID='"${partuuid3}"' single"
"Boot with minimal options"   "ro root=PARTUUID='"${partuuid3}"'"
'

# Use echo to create the file with the specified content
echo "$content" | sudo tee "$refind_linux_conf" > /dev/null
echo "File created: $refind_linux_conf"
