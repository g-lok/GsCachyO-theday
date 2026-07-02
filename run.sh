#!/usr/bin/env bash
sudo pacman -S ansible cachyos-niri-noctalia
ansible-galaxy install -r requirements.yml
ansible-playbook main.yml -K --ask-vault-pass
gh auth login
gh auth setup-git
chsh -s /usr/bin/zsh
sudo systemctl enable --all
sudo systemctl daemon-reexec
sudo systemctl restart
