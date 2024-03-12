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
echo "Installing..."

# Check if user_device is defined
if [ -z "$user_device" ]; then
    echo "Error: user_device not defined."
    exit 1
fi

# Use sudo blkid to get PARTUUID
partuuid=$(sudo blkid -s PARTUUID -o value "$user_device"3)

# Check if PARTUUID is found
if [ -z "$partuuid" ]; then
    echo "Error: PARTUUID not found for device $user_device"
    exit 1
fi

# Print the obtained PARTUUID
echo "PARTUUID for $user_device: $partuuid"

echo "Editing boot config..."
refind_linux_conf="/boot/refind_linux.conf"

# Define the content with the ${user_device} variable
content='
"Boot with standard options"  "rw root=PARTUUID='"${partuuid}"'"
"Boot to single-user mode"    "rw root=PARTUUID='"${partuuid}"' single"
"Boot with minimal options"   "ro root=PARTUUID='"${partuuid}"'"
'

# Use echo to create the file with the specified content
echo "$content" | sudo tee "$refind_linux_conf" > /dev/null
echo "File created: $refind_linux_conf"
