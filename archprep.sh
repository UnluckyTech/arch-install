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
        read option 
        if [[ $option == "1" ]]; then
            . internet.sh

        elif [[ $option == "2" ]]; then
            if [ $(whoami) == "root" ]; then
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
                    ( echo 'n' ; echo '2' ; echo '' ; echo "+${swapgb}G" ; echo 't' ; echo '2' ; echo '82' ) | fdisk "$device"

                    # Create root partition with remaining space
                    ( echo 'n' ; echo '3' ; echo '' ; echo '' ; echo 'w' ) | fdisk "$device"

                    # Format partitions
                    mkfs.fat -F32 "${device}1"  # Format EFI partition
                    mkfs.ext4 "${device}3"      # Format root partition
                    mkswap "${device}2"         # Format swap partition

                    # Display partition information
                    fdisk -l
                    echo "For drive $device, you should see 3 partitions."
                    echo "Returning to menu"
                    sleep 5
                elif [[ $erase == "n" ]]; then
                    echo "Returning to Menu"
                fi
            else
                echo "You need to be root to run this script."
                exit 1
            fi

        elif [[ $option == "3" ]]; then 
            if [[ "$device" ]]; then
                echo "Mounting Partitions"
                mount ${device}3 /mnt
                mkdir /mnt/boot
                mkdir /mnt/home
                mkdir -pv $LFS
                mount ${device}1 /mnt/boot
                swapon ${device}2
                exit 0
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
                exit 0
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
            exit

        else
            2>/dev/null
            echo 'Incorrect command. Try again.'
        fi
    else
        echo "The system is not UEFI or not 64-bit. Exiting the script."
        exit 1
    fi  
done
