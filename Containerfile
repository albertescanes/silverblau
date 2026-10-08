FROM quay.io/fedora-ostree-desktops/silverblue:45@sha256:8aae1234d23aa077203dd5f3b2585fcfaa61f56ea2bd83439785f00791b6a94f

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
dnf -y remove firefox
dnf -y swap ptyxis gnome-console
EOF

RUN rm -rf /var/* && mkdir /var/tmp && chmod 1777 /var/tmp && bootc container lint --fatal-warnings
