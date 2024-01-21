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
        echo '6. Return to Installer'
        echo ''    
        read option 
        if [[ $option == "1" ]]; then
            while true
            do
                echo ''
                echo '*********************************'
                echo '******* Configure Internet ******'
                echo '*********************************'
                echo ''    
                echo '1. Check Connection'
                echo '2. Configure WIFI'
                echo '3. Return to Installer'
                echo ''  
                read option
                if [[ $option == "1" ]]; then
                    if ip link show up | grep -q "state UP"; then
                        echo "Internet connection is available."
                        # Add your script commands here
                    else
                        echo "No active internet connection detected."
                    fi
                elif [[ $input == "2" ]]; then
                    echo "Launching iwctl"
                    echo "To get interactive prompt do: 'help' "
                    sleep 5
                    iwctl
                elif [[ $input == "3" ]]; then
                    exit
                fi
            done

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
            . prereq.sh
        elif [[ $option == "4" ]]; then
            if [ $(whoami) == "root" ]; then
                fdisk -l
                echo "What drive are we working with?"
                read device
                echo "Are you sure you want to format $device ? [y/n]"
                read erase
                if [[ $erase == "y" ]]; then
                    echo "This will take a minute depending on size."
                    mkfs.ext4 $device
                    wipefs --all --force $device
                    echo "How much storage in GB would you like on swap?"
                    read swapgb
                    echo "Will now partition the drive"
                    ( echo 'n' ; echo 'p' ; echo '1' ; echo '2048' ; echo "+${swapgb}G" ; echo 't' ; echo '82' ; echo 'n' ; echo 'p' ; echo '2' ; echo ' ' ; echo ' ' ; echo 'w' ) | fdisk "$device"
                    mkfs -v -t ext4 ${device}2
                    mkswap ${device}1
                    fdisk -l
                    echo "for drive $device you should see 2 partitions "
                    sleep 3
                elif [[ $erase == "n" ]]; then
                    echo "Returning to Menu"
                fi
            else
                echo "You need to be root to run this script."
                exit 1
            fi
        elif [[ $option == "5" ]]; then
            if [[ "$device" ]]; then
                echo "Creating LFS Variable"
                export LFS=/mnt/lfs
                echo $LFS
                echo "Mounting Partitions"
                mkdir -pv $LFS
                mount -v -t ext4 ${device}2 $LFS
                /sbin/swapon -v ${device}1
                echo "export LFS=/mnt/lfs" >> ~/.bashrc
                source ~/.bashrc
                echo "You will now exit to save the changes"
                exit 0
            else
                echo "What drive are we working with?"
                read device 
                echo "Creating LFS Variable"
                export LFS=/mnt/lfs
                echo $LFS
                echo "Mounting Partitions"
                mkdir -pv $LFS
                mount -v -t ext4 ${device}2 $LFS
                /sbin/swapon -v ${device}1
                echo "export LFS=/mnt/lfs" >> ~/.bashrc
                source ~/.bashrc
                echo "You will now exit to save the changes"
                exit 0
            fi

        elif [[ $option == "6" ]]; then
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
