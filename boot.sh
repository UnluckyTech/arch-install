#!/bin/bash
while true
do

    echo ''
    echo '*********************************'
    echo '*********   Boot Loader   *******'
    echo '*********************************'
    echo '1. rEFInd'
    echo '2. GRUB'
    echo '3. Exit'
    dir=$(pwd)
    read option
    if [[ $option == "1" ]]; then
        echo "rEFInd does require manual configuration"
        echo "Check docs for specifics"
        pacman -S refind
        echo "Specify partition for rEFInd"
        read device
        echo "Installing..."

        refind-install --usedefault $device --alldrivers
        mkrlconf
        echo "Done!"
        echo "Now entering boot config..."
        sleep 2
        nano /boot/refind_linux.conf
        echo "Now entering rEFInd config"
        nano /boot/EFI/BOOT/refind.conf
        echo "Done! Hopefully it works!"
    elif [[ $option == "2" ]]; then
        echo "No idea yet"

    elif [[ $option == "3" ]]; then
        exit
    else
        2>/dev/null
        echo 'Incorrect command. Try again.'
    fi

done

