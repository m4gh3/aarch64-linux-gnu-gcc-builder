#!/bin/sh

#stop on first script error
set -e

cd build
wget https://github.com/m4gh3/qemu-ci-cd/releases/download/release.2023.05.28/qemu-aarch64-static
chmod +x qemu-aarch64-static
cp ../res/* .

../build_cross_sysroot.sh
mkdir cross_sysroot; cd cross_sysroot
tar xf ../cross_sysroot.tar
cd ..

../build_gcc_target.sh
cd install
tar cf ../install.tar .
cd ..

podman build --arch arm64 -t cross_builder_aarch64 .
