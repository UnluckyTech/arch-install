#!/bin/bash

if mountpoint -q /mnt; then
    arch-chroot /mnt
else
    echo "System not configured."
    echo "Returning to menu..."
fi