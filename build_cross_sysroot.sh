#!/bin/sh
#FROM debian:experimental

#stop on first script error
set -e

CONTAINER_NAME=$(podman run --arch aarch64 -v$(pwd)/qemu-aarch64-static:/usr/bin/qemu-aarch64-static -d debian:experimental /usr/bin/qemu-aarch64-static /bin/sh -c "apt update && yes | apt install linux-libc-dev libc-dev symlinks; symlinks -rc /usr")
podman logs -f $CONTAINER_NAME
podman export $CONTAINER_NAME -o cross_sysroot.tar
