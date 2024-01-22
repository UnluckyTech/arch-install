#!/bin/bash
while true
do

    echo ''
    echo '*********************************'
    echo '*****   Additional Configs   ****'
    echo '*********************************'
    echo '1. Network Manager'
    echo '2. Graphics Drivers (Nvidia)'
    echo '3. Aur Helper (Yay)'
    echo '4. Display Manager (X)'
    echo '5. Desktop Environment (GNOME)'
    echo '6. Exit'
    dir=$(pwd)
    read option
    if [[ $option == "1" ]]; then
        echo "Configuring Network Manager"
        echo "Check docs for specifics"
        pacman -S networkmanager
        systemctl enable NetworkManager
        echo "Done!"

    elif [[ $option == "2" ]]; then
        echo "NOTE: This is for Nvidia!"
        echo "Ctrl+C to exit."
        sleep 3
        sudo pacman -S git linux-headers
        sudo pacman -S nvidia-dkms libglvnd nvidia-utils opencl-nvidia lib32-libglvnd lib32-nvidia-utils lib32-opencl-nvidia nvidia-settings
        echo "Modifying mkinitcpio config..."
        sudo nano /etc/mkinitcpio.conf
        sudo mkdir /etc/pacman.d/hooks
        sudo touch /etc/pacman.d/hooks/nvidia.hook
        hook_content="[Trigger]
        Operation=Install
        Operation=Upgrade
        Operation=Remove
        Type=Package
        Target=nvidia

        [Action]
        Depends=mkinitcpio
        When=PostTransaction
        Exec=/usr/bin/mkinitcpio -P
        "

        # Specify the file path
        hook_file="/etc/pacman.d/hooks/nvidia.hook"

        # Use echo to write the content to the file
        echo "$hook_content" | sudo tee "$hook_file" > /dev/null

        echo "nvidia.hook file created at $hook_file."


    elif [[ $option == "3" ]]; then
        sudo git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
        echo "Done!"
    elif [[ $option == "4" ]]; then
        sudo pacman -S xorg-server xorg-apps xorg-xinit xorg-twm xorg-xclock xterm
    elif [[ $option == "5" ]]; then
        sudo pacman -S gnome sddm
        sudo systemctl enable sddm.service
    elif [[ $option == "6" ]]; then
        exit
    else
        2>/dev/null
        echo 'Incorrect command. Try again.'
    fi

done

