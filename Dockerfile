FROM quay.io/fedora-ostree-desktops/silverblue:rawhide@sha256:9819975d250afa614be4675dda3d149363f618b87bfc674de4d1787ef7a9c2a1

COPY --chmod=0755 run.sh /tmp/

RUN /tmp/run.sh && rm -f /tmp/run.sh
RUN bootc container lint
