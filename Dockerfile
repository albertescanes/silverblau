FROM quay.io/fedora-ostree-desktops/silverblue:rawhide@sha256:91a2075ef25a5011ca308669dbb431d63cb1f54b8ba7bfa20b7ea6554fce6262

COPY run.sh /tmp/run.sh

RUN /tmp/run.sh && \
    bootc container lint
