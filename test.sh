#!/bin/bash

get_partition_syntax() {
    local device=$1

    if [[ $device == /dev/nvme* ]]; then
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
        
        read device
        user_device=$(get_partition_syntax "$device")
        echo "${user_device}"

        sleep 10
        if [[ $option == "y" ]]; then
           echo ""
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

