FROM scratch AS staging

COPY --chmod=0755 run.sh /

FROM quay.io/fedora-ostree-desktops/silverblue:rawhide@sha256:9819975d250afa614be4675dda3d149363f618b87bfc674de4d1787ef7a9c2a1

RUN --mount=type=bind,from=staging,source=/,target=/build \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /build/run.sh

RUN bootc container lint
