FROM quay.io/fedora-ostree-desktops/silverblue:45@sha256:21ae17568ce34c6565497a1326b5fc1739cf9d452848875c1b198d3da3c89c14

RUN --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/run \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    <<EOF
set -xeuo pipefail

# RPM Fusion (Free + Nonfree)
dnf -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Steam (RPM)
dnf -y install steam

# Mesa freeworld (códecs AMD, 32 y 64 bits)
dnf -y install \
    mesa-va-drivers-freeworld \
    mesa-va-drivers-freeworld.i686
dnf -y swap \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers-freeworld

# Personalizaciones
dnf -y remove firefox firefox-langpacks
dnf -y swap ptyxis gnome-console
EOF

RUN rm -rf /var/* && mkdir /var/tmp && bootc container lint --fatal-warnings
