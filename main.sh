#!/bin/bash
while true
do
    echo ""
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "%%%%%                                                                    %%%%%"
    echo "%%%%% This script will now begin the Installation of Arch Linux.         %%%%%"
    echo "%%%%%                                                                    %%%%%"
    echo "%%%%% Must be running in x64 UEFI mode. Script will not run otherwise.   %%%%%"
    echo "%%%%%                                                                    %%%%%"
    echo "%%%%% Please take careful note of the console output.                    %%%%%"
    echo "%%%%%                                                                    %%%%%" 
    echo "%%%%% If you experience any issues with this script, please report them. %%%%%"
    echo "%%%%%                                                                    %%%%%"
    echo "%%%%% Please look over the README.md before using this installer         %%%%%"
    echo "%%%%%                                                                    %%%%%"
    echo "%%%%%                                                                    %%%%%"
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo ''
    if [ "$(cat /sys/firmware/efi/fw_platform_size)" = "64" ]; then
    echo "UEFI and 64-bit system detected. Continuing with the script..."
        echo ''
        echo '*********************************'
        echo '********* Arch  Installer *******'
        echo '*********************************'
        echo '1. Preparing for the Build'
        echo '2. Configure Build'
        echo '3. Boot Loader'
        echo '4. Additional Configs'
        echo '5. Chroot into System'
        echo '6. Exit'
        read option
        if [[ $option == "1" ]]; then
            . archprep.sh
        elif [[ $option == "2" ]]; then
            . build.sh
        elif [[ $option == "3" ]]; then 
            . boot.sh
        elif [[ $option == "4" ]]; then
            . addition.sh
        elif [[ $option == "5" ]]; then
            . chroot.sh
        elif [[ $option == "6" ]]; then
            exit
        else
            2>/dev/null
            echo 'Incorrect command. Try again.'
        fi
    else
        echo "The system is not UEFI or not 64-bit. Exiting the script."
        exit 1
    fi   
done
