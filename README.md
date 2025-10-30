# silverblau
Custom Fedora Silverblue bootc image

## Switch to this image

To switch your system to this custom image:

```bash
sudo bootc switch ghcr.io/albertescanes/silverblau:latest
```

## Build the image locally

Clone this repository and build the image with `make`:

```bash
git clone https://github.com/albertescanes/silverblau.git
cd silverblau
make all
```

This will:
1. Build the OCI image with `podman build`.
2. Convert the OCI image into a disk image (`anaconda-iso`) using `bootc-image-builder`.

To clean generated artifacts:

```bash
make clean
```
