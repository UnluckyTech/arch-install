#!/bin/bash
echo "input device"
read user_device
echo "Editing boot config..."
refind_linux_conf="/boot/refind_linux.conf"

# Define the content with the ${user_device} variable
content='
"Boot with standard options"  "rw root='"${user_device}"'"
"Boot to single-user mode"    "rw root='"${user_device}"' single"
"Boot with minimal options"   "ro root='"${user_device}"'"
'

# Use echo to create the file with the specified content
echo "$content" | sudo tee "$refind_linux_conf" > /dev/null
echo "File created: $refind_linux_conf"
