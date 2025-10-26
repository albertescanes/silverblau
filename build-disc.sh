#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="silverblau"
IMAGE_REGISTRY="ghcr.io/albertescanes"
DEFAULT_TAG="latest"
DISK_TYPE="anaconda-iso"

USER_UID=$(id -u)
USER_GID=$(id -g)

CONFIG_FILE="$(mktemp /tmp/config.XXXXXX.toml)"
cat > "${CONFIG_FILE}" <<EOF
[customizations.installer.kickstart]
contents = """
%post
bootc switch --mutate-in-place --transport registry ${IMAGE_REGISTRY}/${IMAGE_NAME}:${DEFAULT_TAG}
%end
"""

[customizations.installer.modules]
enable = [
  "org.fedoraproject.Anaconda.Modules.Storage",
  "org.fedoraproject.Anaconda.Modules.Runtime"
]
disable = [
  "org.fedoraproject.Anaconda.Modules.Network",
  "org.fedoraproject.Anaconda.Modules.Security",
  "org.fedoraproject.Anaconda.Modules.Services",
  "org.fedoraproject.Anaconda.Modules.Users",
  "org.fedoraproject.Anaconda.Modules.Subscription",
  "org.fedoraproject.Anaconda.Modules.Timezone"
]
EOF

run0 podman build \
  --pull=newer \
  --tag "${IMAGE_NAME}:${DEFAULT_TAG}" \
  .

mkdir -p output

run0 podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
  --security-opt label=type:unconfined_t \
  -v "${CONFIG_FILE}":/config.toml:ro \
  -v ./output:/output \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type "${DISK_TYPE}" \
  --chown "${USER_UID}:${USER_GID}" \
  --rootfs btrfs \
  --use-librepo=True \
  localhost/"${IMAGE_NAME}":"${DEFAULT_TAG}"

rm -f "${CONFIG_FILE}"
