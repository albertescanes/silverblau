FROM quay.io/fedora/fedora-silverblue:latest

COPY --chmod=0644 rootfs/ /
COPY --chmod=0755 run.sh /tmp/

RUN /tmp/run.sh
RUN bootc container lint
