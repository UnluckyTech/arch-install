#!/bin/bash
fdisk -l
echo "What drive are we working with?"
read device
echo "Are you sure you want to format $device ? [y/n]"
read erase
if [[ $erase == "y" ]]; then
    echo "This will take a minute depending on size."
    wipefs --all --force $device

    # Create EFI system (assuming 1GiB size), swap partition (user-defined size), root partition with remaining space.
    echo "How much storage in GB would you like on swap?"
    read swapgb
    ( echo 'g' ; echo 'n' ; echo '1' ; echo '' ; echo '+1G' ; echo 't' ; echo '1' ; echo 'n' ; echo '2' ; echo '' ; echo "+${swapgb}G" ; echo 't' ; echo '2' ; echo '19' ; echo 'n' ; echo '3' ; echo '' ; echo '' ; echo 'w' ) | fdisk "$device"

    # Format partitions
    mkfs.fat -F32 "${device}1"  # Format EFI partition
    mkfs.ext4 "${device}3"      # Format root partition
    mkswap "${device}2"         # Format swap partition

    # Display partition information
    fdisk -l
    echo "For drive $device, you should see 3 partitions."
    echo "Returning to menu"
    sleep 2
elif [[ $erase == "n" ]]; then
    echo "Returning to Menu"
else
    echo "You need to be root to run this script."
    exit 1
fi