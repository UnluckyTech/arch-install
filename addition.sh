#!/bin/bash
while true
do

    echo ''
    echo '*********************************'
    echo '*****   Additional Configs   ****'
    echo '*********************************'
    echo '1. Network Manager'
    echo '2. Graphics Drivers (Nvidia)'
    echo '3. Aur Helper (Pakku)'
    echo '4. Display Manager (X)'
    echo '5. SDDM'
    echo '6. Desktop Environment'
    echo '7. Exit'
    dir=$(pwd)
    read option
    if [[ $option == "1" ]]; then
        echo "Configuring Network Manager"
        echo "Check docs for specifics"
        yes | pacman -S networkmanager
        systemctl enable NetworkManager
        echo "Done!"

    elif [[ $option == "2" ]]; then
        echo "NOTE: This is for Nvidia!"
        echo "Ctrl+C to exit."
        sleep 2
        sudo yes | pacman -S git linux-headers
        sudo yes | pacman -S nvidia-dkms libglvnd nvidia-utils opencl-nvidia lib32-libglvnd lib32-nvidia-utils lib32-opencl-nvidia nvidia-settings
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
        git clone https://aur.archlinux.org/pakku.git && cd pakku && makepkg -si
        echo "Done!"
    elif [[ $option == "4" ]]; then
        pacman -S xorg-server xorg-apps xorg-xinit xorg-twm xorg-xclock xterm
    elif [[ $option == "5" ]]; then
        pacman -S sddm qt5-quickcontrols qt5-graphicaleffects
        mkdir /etc/sddm.conf.d
        cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf.d/sddm.conf
        # git clone https://github.com/MarianArlt/sddm-chili
        # mv sddm-chili /usr/share/sddm/themes/chili
        sudo systemctl enable sddm.service
        # Path to the sddm.conf file
        sddm_conf_path="/etc/sddm.conf.d/sddm.conf"

        # Theme name to set
        theme_name="chili"

        # Check if the sddm.conf file exists
        # if [ -e "$sddm_conf_path" ]; then
            # Update the Current theme in sddm.conf
            # sed -i "s/^Current=.*/Current=$theme_name/" "$sddm_conf_path"
            # echo "SDDM theme updated to $theme_name"
        # else
            # echo "Error: $sddm_conf_path does not exist."
        # fi
    elif [[ $option == "6" ]]; then
        echo ''
        echo '*********************************'
        echo '******* Desktop Environment *****'
        echo '*********************************'
        echo '1. GNOME'
        echo '2. KDE Plasma'
        echo '3. XFCE4'
        echo '*********************************'
        echo '********* Window Managers *******'
        echo '*********************************'
        echo '4. Hyprland (Wayland)'
        echo '5. Awesome (Xorg)'
        echo '6. I3wm'
        echo '7. Exit'

        read option
        if [[ $option == "1" ]]; then
            pacman -S gnome gnome-extra
        elif [[ $option == "2" ]]; then
            pacman -S plasma
        elif [[ $option == "3" ]]; then 
            pacman -S xfce4 xfce4-goodies
        elif [[ $option == "4" ]]; then
            pacman -S hyprland kitty dunst xdg-desktop-portal-hyprland qt5-wayland qt6-wayland
        elif [[ $option == "5" ]]; then
            pacman -S awesome
        elif [[ $option == "6" ]]; then
            pacman -S i3-wm
        elif [[ $option == "7" ]]; then
            break
        else
            2>/dev/null
            echo 'Incorrect command. Try again.'
        fi
    elif [[ $option == "7" ]]; then
        exit
    else
        2>/dev/null
        echo 'Incorrect command. Try again.'
    fi

done

