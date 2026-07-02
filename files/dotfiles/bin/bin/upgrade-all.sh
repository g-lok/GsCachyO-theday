#!/usr/bin/env bash

# apt
sudo apt update && sudo apt full-upgrade -y
sudo apt update
sudo apt clean
sudo apt autoremove --purge
sudo apt autoclean
# homebrew
brew update && brew upgrade
brew cleanup --prune=all
# snap
sudo snap refresh
# flatpak
flatpak update && flatpak uninstall --unused
# gnome extensions
gext update --filesystem --install
# mise
mise upgrade
