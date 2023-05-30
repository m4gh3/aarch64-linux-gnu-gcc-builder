#!/bin/sh
#FROM debian:experimental

#stop on first script error
set -e

podman manifest inspect docker.io/debian:experimental
CONTAINER_NAME=$(podman run --arch arm64 -v$(pwd)/qemu-aarch64-static:/usr/bin/qemu-aarch64-static -d docker.io/debian:experimental /usr/bin/qemu-aarch64-static /bin/sh -c "apt update && yes | apt install linux-libc-dev libc-dev symlinks; symlinks -rc /usr")
podman logs -f $CONTAINER_NAME
podman export $CONTAINER_NAME -o cross_sysroot.tar
