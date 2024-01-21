#!/bin/bash
echo ''
echo '*********************************'
echo '********* Configure Arch  *******'
echo '*********************************'
echo '1. Set Time Zone'
echo '2. Configure Build'
echo '3. null'
echo '4. Chroot into System'
echo '5. Exit'
dir=$(pwd)
read option
if [[ $option == "1" ]]; then
    . /$dir/configure/timezone.sh
elif [[ $option == "2" ]]; then
    . build.sh
elif [[ $option == "3" ]]; then 
    . null.sh
elif [[ $option == "4" ]]; then
    . chroot.sh
elif [[ $option == "5" ]]; then
    exit
else
    2>/dev/null
    echo 'Incorrect command. Try again.'
fi