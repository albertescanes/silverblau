#!/bin/bash

set -ouex pipefail

dnf config-manager setopt fedora-cisco-openh264.enabled=1

dnf -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    fastfetch \
    gnome-console \
    steam-devices \
    ffmpegthumbnailer

dnf -y swap \
    ffmpeg-free ffmpeg --allowerasing

dnf -y remove \
    gnome-shell-extension-apps-menu \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-places-menu \
    gnome-shell-extension-window-list \
    gnome-shell-extension-background-logo \
    firefox-langpacks \
    firefox

dnf -y clean all
