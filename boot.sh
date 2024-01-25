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
        pacman -S git refind
        echo "Specify drive for rEFInd"
        read device
        echo "Installing..."

        refind-install --usedefault ${device}1 --alldrivers
        mkrlconf
        echo "Done!"
        echo "Editing boot config..."
        # Specify the content
        content='"Boot with minimal options" "ro root='"${device}3"'"'
        # Specify the file path
        refind_linux_conf="/boot/refind_linux.conf"
        # Use echo to create/replace the file with the specified content
        echo "$content" | sudo tee "$refind_linux_conf" > /dev/null
        echo "File replaced: $refind_linux_conf"
        echo "Now entering rEFInd config"
        nano /boot/EFI/BOOT/refind.conf
        mkdir /boot/EFI/BOOT/themes
        cd /boot/EFI/BOOT/themes
        git clone https://github.com/kgoettler/ursamajor-rEFInd.git
        echo "include themes/ursamajor-rEFInd/theme.conf" >> /boot/EFI/BOOT/refind.conf
        echo "Done! Hopefully it works!"

    elif [[ $option == "2" ]]; then
        echo "No idea yet"

    elif [[ $option == "3" ]]; then
        break
    else
        2>/dev/null
        echo 'Incorrect command. Try again.'
    fi

done

