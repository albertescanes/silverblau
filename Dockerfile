FROM quay.io/fedora-ostree-desktops/silverblue:rawhide@sha256:1757a7a796de5bc0bdaf7cda5a72c0a2f680894e3dca9999b13f48a2a1b3dc6a

COPY run.sh /tmp/run.sh

RUN /tmp/run.sh && \
    bootc container lint
