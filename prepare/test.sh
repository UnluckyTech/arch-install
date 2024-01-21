#!/bin/bash
fdisk -l
echo "What drive are we working with?"
read device
echo "Are you sure you want to format $device ? [y/n]"
read erase
if [[ $erase == "y" ]]; then
    echo "This will take a minute depending on size."
    wipefs --all --force $device

    # Create EFI system partition (assuming 1GiB size)
    ( echo 'g' ; echo 'n' ; echo '1' ; echo '' ; echo '+1G' ; echo 't' ; echo '1' ) | fdisk "$device"

    # Create swap partition (user-defined size)
    echo "How much storage in GB would you like on swap?"
    read swapgb
    ( echo 'n' ; echo '2' ; echo '' ; echo "+${swapgb}G" ; echo 't' ; echo '2' ; echo '19' ) | fdisk "$device"


elif [[ $erase == "n" ]]; then
    echo "Returning to Menu"
else
    echo "You need to be root to run this script."
    exit 1
fi