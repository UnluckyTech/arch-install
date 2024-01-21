#!/bin/bash
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
        read option 
        if [[ $option == "1" ]]; then
            . /$user/prepare/internet.sh

        elif [[ $option == "2" ]]; then
            . /$user/prepare/partition.sh

        elif [[ $option == "3" ]]; then 
            if [[ "$device" ]]; then
                echo "Mounting Partitions"
                mount ${device}3 /mnt
                mkdir /mnt/boot
                mkdir /mnt/home
                mkdir -pv $LFS
                mount ${device}1 /mnt/boot
                swapon ${device}2
                
            else
                echo "What drive are we working with?"
                read device 
                echo "Mounting Partitions"
                mount ${device}3 /mnt
                mkdir /mnt/boot
                mkdir /mnt/home
                mkdir -pv $LFS
                mount ${device}1 /mnt/boot
                swapon ${device}2
                
            fi
        elif [[ $option == "4" ]]; then
            if [ $(whoami) == "root" ]; then
                echo "Ranking Mirrors"
                reflector
                echo "Completed!"
                sleep 2
                echo "Installing Essential Packages"
                pacstrap -K /mnt base linux linux-firmware
                echo "Essentials Installed!"
                echo "Generating fstab"
                sleep 1
                genfstab -U /mnt >> /mnt/etc/fstab
                echo "Generated"
                echo "Enter Chroot?"
                if [[ $option == "y" ]]; then
                    cp /home/arch-install /mnt
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