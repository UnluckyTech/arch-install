#!/bin/bash
while true
do

    echo ''
    echo '*********************************'
    echo '*********      User       *******'
    echo '*********************************'
    echo '1. Set Root Password'
    echo '2. Create New User'
    echo '3. Exit'
    dir=$(pwd)
    read option
    if [[ $option == "1" ]]; then
        echo "Enter Root Password"
        passwd
        echo "Done!"
    elif [[ $option == "2" ]]; then
        pacman --sync sudo
        echo "Enter Username"
        read username
        useradd -m -g users -G wheel,storage,power -s /bin/bash $username
        echo "Enter User Password"
        passwd $username
        echo "You will now add $username to sudo"
        sleep 2

        # Uncomment %wheel ALL=(ALL) ALL
        sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

        # Append Defaults rootpw at the very bottom
        echo "Defaults rootpw" >> /etc/sudoers

    elif [[ $option == "3" ]]; then
        exit
    else
        2>/dev/null
        echo 'Incorrect command. Try again.'
    fi

done