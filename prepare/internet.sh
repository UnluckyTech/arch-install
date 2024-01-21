#!/bin/bash
while true
do
    echo ''
    echo '*********************************'
    echo '******* Configure Internet ******'
    echo '*********************************'
    echo ''    
    echo '1. Check Connection'
    echo '2. Configure WIFI'
    echo '3. Return to Installer'
    echo ''  
    read option
    if [[ $option == "1" ]]; then
        if ip link show up | grep -q "state UP"; then
            echo "Internet connection is available."
        else
            echo "No active internet connection detected."
        fi
    elif [[ $option == "2" ]]; then
        echo "Launching iwctl"
        echo "To get interactive prompt do: 'help' "
        sleep 5
        iwctl
    elif [[ $option == "3" ]]; then
        break
    fi
done