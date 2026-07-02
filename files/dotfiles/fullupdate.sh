#!/usr/bin/env bash

sudo pacman -Syu
yay -Syu
mise upgrade
if command -v opam >/dev/null 2>&1; then
  opam update
  opam upgrade
fi
