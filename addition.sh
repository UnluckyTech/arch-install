#!/bin/bash
while true
do

    echo ''
    echo '*********************************'
    echo '*****   Additional Configs   ****'
    echo '*********************************'
    echo '1. Network Manager'
    echo '2. Graphics Drivers'
    echo '3. Aur Helper'
    echo '4. Display Manager (X)'
    echo '5. SDDM'
    echo '6. Desktop Environment'
    echo '7. Exit'
    dir=$(pwd)
    read option
    if [[ $option == "1" ]]; then
        echo "Configuring Network Manager"
        echo "Check docs for specifics"
        yes | pacman -S networkmanager openssh
        systemctl enable sshd
        systemctl enable NetworkManager
        echo "Done!"

    elif [[ $option == "2" ]]; then
        while true
        do
            echo ''
            echo '*********************************'
            echo '********* Graphics Drivers ******'
            echo '*********************************'
            echo '1. NVIDIA'
            echo '2. AMD'
            echo '3. Exit'
            read option
            if [[ $option == "1" ]]; then
                . /$dir/addition/nvidia.sh
            elif [[ $option == "2" ]]; then
                . /$dir/addition/amd.sh
            elif [[ $option == "3" ]]; then
                break
            else
                2>/dev/null
                echo 'Incorrect command. Try again.'
            fi
        done
        
    elif [[ $option == "3" ]]; then
        while true
        do
            echo ''
            echo '*********************************'
            echo '********** AUR Helper ***********'
            echo '*********************************'
            echo '1. YAY'
            echo '2. PAKKU'
            echo '3. Exit'
            read option
            if [[ $option == "1" ]]; then
                . /$dir/addition/yay.sh
            elif [[ $option == "2" ]]; then
                . /$dir/addition/pakku.sh
            elif [[ $option == "3" ]]; then
                break
            else
                2>/dev/null
                echo 'Incorrect command. Try again.'
            fi
        done
    elif [[ $option == "4" ]]; then
        pacman -S xorg-server xorg-apps xorg-xinit xorg-twm xorg-xclock xterm
    elif [[ $option == "5" ]]; then
        . /$dir/addition/sddm.sh
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
            pacman -S gnome gnome-extra --noconfirm
        elif [[ $option == "2" ]]; then
            pacman -S plasma --noconfirm
        elif [[ $option == "3" ]]; then 
            pacman -S xfce4 xfce4-goodies --noconfirm
        elif [[ $option == "4" ]]; then
            pacman -S hyprland kitty gtk3 dunst xdg-desktop-portal-hyprland qt5-wayland qt6-wayland pipewire polkit-kde-agent --noconfirm
        elif [[ $option == "5" ]]; then
            pacman -S awesome --noconfirm
        elif [[ $option == "6" ]]; then
            pacman -S i3-wm --noconfirm
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

