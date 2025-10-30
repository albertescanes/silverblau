IMAGE_NAME ?= silverblau
IMAGE_REGISTRY ?= ghcr.io/albertescanes
TAG ?= latest
DISK_TYPE ?= anaconda-iso
BIB_IMAGE ?= quay.io/centos-bootc/bootc-image-builder:latest

.PHONY: oci-image disk-image clean all

all: oci-image disk-image

oci-image:
	run0 podman build --pull=newer --tag $(IMAGE_NAME):$(TAG) .

disk-image:
	mkdir -p output
	
	sed -e 's;@@IMAGE@@;$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(TAG);g' config.toml.in > config.toml
	run0 podman run \
		--rm -it --privileged \
		--security-opt label=type:unconfined_t \
		-v ./config.toml:/config.toml:ro \
		-v ./output:/output \
		-v /var/lib/containers/storage:/var/lib/containers/storage \
		$(BIB_IMAGE) \
		--type $(DISK_TYPE) \
		--chown $$(id -u):$$(id -g) \
		--rootfs btrfs \
		--use-librepo=True \
		localhost/$(IMAGE_NAME):$(TAG)

clean:
	rm -rf output config.toml
