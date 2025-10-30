#!/bin/bash

set -xeuo pipefail


# RPM Fusion needs the openh264 library repository to be explicitly enabled
dnf config-manager setopt fedora-cisco-openh264.enabled=1

# Install RPM Fusion repositories
dnf -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf -y swap ffmpeg-free ffmpeg --allowerasing
dnf -y swap mesa-va-drivers mesa-va-drivers-freeworld

# Remove Firefox rpm and unused repos
dnf -y remove \
    fedora-flathub-remote \
    fedora-third-party \
    firefox \
    firefox-langpacks

# Using a more upstream GNOME
#dnf -y swap fedora-logos generic-logos

dnf -y remove \
    desktop-backgrounds-gnome \
    f*-backgrounds* \
    fedora-backgrounds \
    fedora-workstation-background

dnf -y install \
    gnome-backgrounds \
    gnome-console
dnf -y remove \
    gnome-classic-session \
    gnome-shell-extension-{apps-menu,launch-new-instance,places-menu,window-list} \
    ptyxis

# Add extra packages
dnf -y install \
    fastfetch \
    make \
    openrgb-udev-rules \
    vim \
    xeyes

dnf -y group install container-management --with-optional

# Install Flathub repo
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

# Don't enable Fedora Flatpak repo
systemctl disable flatpak-add-fedora-repos.service

# Enable automatic updates
systemctl enable rpm-ostreed-automatic.timer

# Install game-devices-udev
mkdir -p /tmp/game-devices-udev/
curl --retry 3 -Lo /tmp/game-devices-udev/main.zip https://codeberg.org/fabiscafe/game-devices-udev/archive/main.zip
unzip -q /tmp/game-devices-udev/main.zip -d /tmp/game-devices-udev/
cp /tmp/game-devices-udev/game-devices-udev/*.rules /etc/udev/rules.d/
mkdir -p /etc/modules-load.d/
echo "uinput" | tee /etc/modules-load.d/uinput.conf

# Not using Firefox rpm so avoid cluttering more home directories
rm -rf /etc/skel/.mozilla

# Cleanup
dnf -y clean all
find /var -mindepth 1 -delete
find /tmp -mindepth 1 -delete
