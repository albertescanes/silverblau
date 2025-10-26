#!/bin/bash

set -xeuo pipefail

# Default installed OpenCL-ICD-Loader conflicts with mesa-libOpenCL 
dnf -y swap OpenCL-ICD-Loader ocl-icd

# Install negativo17 repo and override packages
dnf config-manager addrepo --from-repofile="https://negativo17.org/repos/fedora-multimedia.repo"

dnf config-manager setopt fedora-multimedia.priority=90

OVERRIDE_PACKAGES="\
intel-gmmlib \
intel-mediasdk \
intel-vpl-gpu-rt \
libheif \
libva \
libva-intel-media-driver \
mesa-dri-drivers \
mesa-filesystem \
mesa-libEGL \
mesa-libgbm \
mesa-libGL \
mesa-va-drivers \
mesa-vulkan-drivers"

dnf -y install 'dnf-command(versionlock)'

dnf -y distro-sync --skip-unavailable --repo='fedora-multimedia' $OVERRIDE_PACKAGES
dnf -y versionlock add $OVERRIDE_PACKAGES

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

# Add extra codecs
dnf -y install \
    fdk-aac \
    ffmpeg \
    ffmpeg-libs \
    ffmpegthumbnailer \
    heif-pixbuf-loader \
    intel-vaapi-driver \
    libavcodec \
    libcamera \
    libcamera-gstreamer \
    libcamera-ipa \
    libcamera-tools \
    libfdk-aac \
    libheif \
    libva-utils \
    mesa-libxatracker \
    pipewire-libs-extra \
    pipewire-plugin-libcamera

# Add extra packages
dnf -y install \
    google-noto-sans-balinese-fonts \
    google-noto-sans-cjk-fonts \
    google-noto-sans-javanese-fonts \
    google-noto-sans-sundanese-fonts \
    openrgb-udev-rules \
    vim \
    wl-clipboard \
    xeyes

# Install Container Management packages (buildah, skopeo, flatpak-builder)
dnf group -y install container-management --with-optional

# Install Flathub repo
mkdir -p /etc/flatpak/remotes.d/
curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

# Don't enable Fedora Flatpak repo
systemctl disable flatpak-add-fedora-repos.service

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
