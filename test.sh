#!/bin/bash
echo "input device"
read user_device
echo "Editing boot config..."
content='"Boot with minimal options" "rw root='"${user_device}3"'"'
# Specify the file path
refind_linux_conf="/boot/refind_linux.conf"
# Use sed to replace "ro" with "rw" in the file content
sudo sed -i 's/ro/rw/' "$refind_linux_conf"
# Use echo to create/replace the file with the modified content
echo "$content" | sudo tee "$refind_linux_conf" > /dev/null
echo "File replaced: $refind_linux_conf"