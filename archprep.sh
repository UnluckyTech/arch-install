#!/bin/bash

get_partition_syntax() {
    local device=$1

    if [[ $2device == /dev/nvme* ]]; then
        echo "${device}p"
    else
        echo "${device}"
    fi
}

while true
do
    if [ "$(cat /sys/firmware/efi/fw_platform_size)" = "64" ]; then
        echo "UEFI and 64-bit system detected. Continuing with the script..."
        echo ''
        echo '*********************************'
        echo '******** Arch Prep Script *******'
        echo '*********************************'
        echo ''    
        echo '1. Configure Internet'
        echo '2. Partition Drive'
        echo '3. Mount Partitions'
        echo '4. Install Essentials'
        echo '5. Return to Installer'
        user="$(whoami)"
        dir=$(pwd)    
        read option 
        if [[ $option == "1" ]]; then
            . /$dir/prepare/internet.sh

        elif [[ $option == "2" ]]; then
            . /$dir/prepare/partition.sh

        elif [[ $option == "3" ]]; then 
            if [[ "$device" ]]; then
                echo "Mounting Partitions"
                mount ${user_device}3 /mnt
                mkdir /mnt/efi
                mkdir /mnt/home
                mount ${user_device}1 /mnt/efi
                swapon ${user_device}2
                
            else
                echo "What drive are we working with?"
                read device 
                user_device=$(get_partition_syntax "$device")
                echo "Mounting Partitions"
                mount ${user_device}3 /mnt
                mkdir /mnt/boot
                mkdir /mnt/home
                mount ${user_device}1 /mnt/boot
                swapon ${user_device}2
                
            fi
        elif [[ $option == "4" ]]; then
            if [ $(whoami) == "root" ]; then
                echo "Ranking Mirrors"
                reflector
                echo "Completed!"
                echo "Installing Essential Packages"
                pacstrap -K /mnt base base-devel linux linux-firmware
                echo "Essentials Installed!"
                echo "Generating fstab"
                genfstab -U /mnt >> /mnt/etc/fstab
                echo "Generated"
                echo "Enter Chroot?"
                read option
                if [[ $option == "y" ]]; then
                    cp -rf /$user/arch-install /mnt
                    arch-chroot /mnt
                elif [[ $option == "n" ]]; then
                    echo "Returning to Menu"
                fi
            else
                echo "You need to be root to run this script."
                exit 1
            fi
        elif [[ $option == "5" ]]; then
            break

        else
            2>/dev/null
            echo 'Incorrect command. Try again.'
        fi
    else
        echo "The system is not UEFI or not 64-bit. Exiting the script."
        exit 1
    fi  
done