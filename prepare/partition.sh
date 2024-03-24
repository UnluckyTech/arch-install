#!/bin/bash

get_partition_syntax() {
    local device=$1

    if [[ $device == /dev/nvme* ]]; then
        echo "${device}p"
    else
        echo "${device}"
    fi
}

fdisk -l
echo "What drive are we working with?"
read device
user_device=$(get_partition_syntax "$device")

# Check if the drive already has three partitions
num_partitions=$(fdisk -l "$device" | grep -c "$device[0-9]")

if [[ $num_partitions -gt 1 ]]; then
    echo "The drive has partitions."
    echo "Would you like to format the drive? [y/n]"
    read erase

    if [[ $erase == "y" ]]; then
        echo "This will take a minute depending on size."
        # wipefs --all --force $device

        # Create EFI system (assuming 1GiB size), swap partition (user-defined size), root partition with remaining space.
        echo "How much storage in GB would you like on swap?"
        read swapgb
        echo "Use remaining space for root partition? [y/n]"
        read rootsize
            if [[ $rootsize == "y" ]]; then
                ( echo 'g' ; echo 'n' ; echo '1' ; echo '' ; echo '+1G' ; echo 't' ; echo '1' ; echo 'n' ; echo '2' ; echo '' ; echo "+${swapgb}G" ; echo 't' ; echo '2' ; echo '19' ; echo 'n' ; echo '3' ; echo '' ; echo '' ; echo 'w' ) | fdisk "$device"

                # Format partitions
                mkfs.fat -F32 "${user_device}1"  # Format EFI partition
                mkfs.ext4 "${user_device}3"      # Format root partition
                mkswap "${user_device}2"         # Format swap partition

                # Display partition information
                fdisk -l
                echo "For drive $device, you should see 3 partitions."
                echo "Returning to menu"
            elif [[ $rootsize == "n" ]]; then
                echo "Set root partition size"
                read partsize
                ( echo 'g' ; echo 'n' ; echo '1' ; echo '' ; echo '+1G' ; echo 't' ; echo '1' ; echo 'n' ; echo '2' ; echo '' ; echo "+${swapgb}G" ; echo 't' ; echo '2' ; echo '19' ; echo 'n' ; echo '3' ; echo '' ; echo "+${partsize}G" ; echo 'w' ) | fdisk "$device"

                # Format partitions
                mkfs.fat -F32 "${user_device}1"  # Format EFI partition
                mkfs.ext4 "${user_device}3"      # Format root partition
                mkswap "${user_device}2"         # Format swap partition

                # Display partition information
                fdisk -l
                echo "For drive $device, you should see 3 partitions."
                echo "Returning to menu"
            else
                echo "Incorrect Command"
                exit 1
            fi
    elif [[ $erase == "n" ]]; then
        # Create EFI system (assuming 1GiB size), swap partition (user-defined size), root partition with remaining space.
        echo "How much storage in GB would you like on swap?"
        read swapgb
        echo "Use remaining space for root partition? [y/n]"
        read rootsize
            if [[ $rootsize == "y" ]]; then
                ( echo 'n' ; echo '5' ; echo '' ; echo '+1G' ; echo 't' ; echo '5' ; echo 'n' ; echo '6' ; echo '' ; echo "+${swapgb}G" ; echo 't' ; echo '6' ; echo '19' ; echo 'n' ; echo '7' ; echo '' ; echo '' ; echo 'w' ) | fdisk "$device"

                # Format partitions
                mkfs.fat -F32 "${user_device}5"  # Format EFI partition
                mkfs.ext4 "${user_device}7"      # Format root partition
                mkswap "${user_device}6"         # Format swap partition

                # Display partition information
                fdisk -l
                echo "For drive $device, you should see 3 partitions."
                echo "Returning to menu"
            elif [[ $rootsize == "n" ]]; then
                echo "Set root partition size"
                read partsize
                ( echo 'n' ; echo '5' ; echo '' ; echo '+1G' ; echo 't' ; echo '5' ; echo 'n' ; echo '6' ; echo '' ; echo "+${swapgb}G" ; echo 't' ; echo '6' ; echo '19' ; echo 'n' ; echo '7' ; echo '' ; echo "+${partsize}G" ; echo 'w' ) | fdisk "$device"

                # Format partitions
                mkfs.fat -F32 "${user_device}5"  # Format EFI partition
                mkfs.ext4 "${user_device}7"      # Format root partition
                mkswap "${user_device}6"         # Format swap partition

                # Display partition information
                fdisk -l
                echo "For drive $device, you should see 3 partitions."
                echo "Returning to menu"
            else
                echo "Incorrect Command"
                exit 1
            fi
    else
        echo "Incorrect command."
        exit 1
    fi
fi

echo "Are you sure you want to format $device? [y/n]"
read erase

if [[ $erase == "y" ]]; then
    echo "This will take a minute depending on size."
    # Add your partitioning and formatting commands here
else
    echo "Returning to Menu"
    exit 0
fi
