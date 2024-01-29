#!/bin/bash

git clone https://aur.archlinux.org/pakku.git
cd pakku
makepkg -si
cd /arch-install