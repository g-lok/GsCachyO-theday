#!/usr/bin/env bash

pacman -Qeq >"$HOME/dotfiles/packages.txt"
pacman -Qmq >"$HOME/dotfiles/aur_packages.txt"
