#!/bin/bash
while true
do

    echo ''
    echo '*********************************'
    echo '********* Configure Arch  *******'
    echo '*********************************'
    echo '1. Set Time Zone'
    echo '2. Network & Package Manager'
    echo '3. Root & User'
    echo '4. Exit'
    dir=$(pwd)
    read option
    if [[ $option == "1" ]]; then
        . /$dir/configure/timezone.sh
    elif [[ $option == "2" ]]; then
        . /$dir/configure/network.sh
    elif [[ $option == "3" ]]; then 
        . /$dir/configure/user.sh
    elif [[ $option == "4" ]]; then
        break
    else
        2>/dev/null
        echo 'Incorrect command. Try again.'
    fi

done