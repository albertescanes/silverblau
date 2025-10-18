#!/bin/bash

set -xeuo pipefail

dnf config-manager setopt fedora-cisco-openh264.enabled=1

dnf -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    fastfetch \
    steam-devices \
    ffmpegthumbnailer

dnf -y swap \
    ffmpeg-free ffmpeg --allowerasing

dnf -y remove \
    firefox-langpacks \
    firefox \
    gnome-shell-extension-{apps-menu,launch-new-instance,places-menu,window-list}

dnf -y clean all
rm -rf /var/{log,cache,lib}/*
