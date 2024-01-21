#!/bin/bash
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
    echo "Enter Username"
    read username
    useradd -m -g users -G wheel,storage,power -s /bin/bash $username
    echo "You will now add $username to sudo"
    sleep 2
    EDITOR=nano visudo

elif [[ $option == "3" ]]; then
    exit
else
    2>/dev/null
    echo 'Incorrect command. Try again.'
fi