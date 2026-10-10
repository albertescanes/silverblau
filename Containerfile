FROM quay.io/fedora-ostree-desktops/silverblue:45@sha256:56d1d6216de6cf0ccf1edeb6a4b3231b2df778c7174465b9c1a2f758f77c7e0d

RUN --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/run \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    <<EOF
set -xeuo pipefail

# RPM Fusion (Free + Nonfree)
dnf -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Steam
dnf -y install steam

# Códecs (GStreamer)
dnf -y install \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly

# Mesa freeworld (AMD): VA-API + Vulkan, 64 y 32 bits
dnf -y install mesa-va-drivers-freeworld.{i686,x86_64}
dnf -y swap mesa-vulkan-drivers{,-freeworld}
dnf -y swap mesa-vulkan-drivers{,-freeworld}.i686

# Personalizaciones
dnf -y remove firefox
dnf -y swap ptyxis gnome-console
EOF

RUN rm -rf /var/* && mkdir /var/tmp && chmod 1777 /var/tmp && bootc container lint --fatal-warnings

LABEL containers.bootc 1
LABEL ostree.bootable 1
