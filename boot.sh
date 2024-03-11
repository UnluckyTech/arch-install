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
    user=$(whoami)
    read option
    if [[ $option == "1" ]]; then
        echo "rEFInd does require manual configuration"
        echo "Check docs for specifics"
        pacman -S intel-ucode git refind --noconfirm
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
        # Backup the original refind.conf
        cp /boot/EFI/BOOT/refind.conf /boot/EFI/BOOT/refind.conf.bak
        # Modify the refind.conf with the new options
        awk -v device="$device" '/menuentry "Arch Linux"/,/options/ {sub(/root=[^ ]+/, "root=" device "1\"")} 1' /boot/EFI/BOOT/refind.conf > /boot/EFI/BOOT/refind.conf.tmp
        # Replace the original file with the modified one
        mv /boot/EFI/BOOT/refind.conf.tmp /boot/EFI/BOOT/refind.conf
        echo "Refind.conf updated successfully!"
        mkdir /boot/EFI/BOOT/themes
        cd /boot/EFI/BOOT/themes
        git clone https://github.com/kgoettler/ursamajor-rEFInd.git
        echo "include themes/ursamajor-rEFInd/theme.conf" >> /boot/EFI/BOOT/refind.conf
        cd /arch-install
        fatlabel ${device}1 ARCH
        echo "Would you like to move configs to /boot/EFI/refind? [y/n]"
        read option
        if [[ $option == "y" ]]; then
           . /configure/efi.sh
        elif [[ $option == "n" ]]; then
            echo ""
        fi
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

