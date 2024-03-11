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
        user_device=$(get_partition_syntax "$device")
        echo "Installing..."

        cp -rf /usr/share/refind/ boot/EFI/refind/
        mv boot/EFI/refind/refind.conf-sample boot/EFI/refind/refind.conf
        echo "Done!"
        echo "Editing boot config..."
        # Specify the content
        content='"Boot with minimal options" "ro root='"${user_device}3"'"'
        # Specify the file path
        refind_linux_conf="/boot/refind_linux.conf"
        # Use echo to create/replace the file with the specified content
        echo "$content" | sudo tee "$refind_linux_conf" > /dev/null
        echo "File replaced: $refind_linux_conf"
        # Backup the original refind.conf
        cp /boot/EFI/refind/refind.conf /boot/EFI/refind/refind.conf.bak
        # Modify the refind.conf with the new options
        awk -v device="$user_device" '/menuentry "Arch Linux"/,/options/ {sub(/root=[^ ]+/, "root=" device "1\"")} 1' /boot/EFI/refind/refind.conf > /boot/EFI/refind/refind.conf.tmp
        # Replace the original file with the modified one
        mv /boot/EFI/refind/refind.conf.tmp /boot/EFI/refind/refind.conf
        echo "Refind.conf updated successfully!"
        mkdir /boot/EFI/refind/themes
        cd /boot/EFI/refind/themes
        git clone https://github.com/kgoettler/ursamajor-rEFInd.git
        echo "include themes/ursamajor-rEFInd/theme.conf" >> /boot/EFI/refind/refind.conf
        cd /arch-install
        fatlabel ${user_device}1 ARCH

        efibootmgr --create --disk ${device} --part 1 --loader /EFI/refind/refind_x64.efi --label "rEFInd Boot Manager" --unicode

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

