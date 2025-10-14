FROM scratch AS staging

COPY --chmod=0755 run.sh /

FROM quay.io/fedora-ostree-desktops/silverblue:rawhide@sha256:aafdd7cbacbd5db4c5260a6c50ef1143880837f85ef06371b7e23ce85685fb57

RUN --mount=type=bind,from=staging,source=/,target=/build \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /build/run.sh

RUN bootc container lint
