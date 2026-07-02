#!/usr/bin/env bash

# Vagrant hack
alias vagrant="docker run -it --rm \
  -e VAGRANT_DEFAULT_PROVIDER=libvirt \
  -v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock \
  -v ~/.vagrant.d:/.vagrant.d \
  -v \$(pwd):/workspace \
  -w /workspace \
  --network host \
  vagrantlibvirt/vagrant-libvirt:latest vagrant"
