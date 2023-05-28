#!/bin/sh

#stop on first script error

set -e

cd build
../build_cross_sysroot.sh
mkdir cross_sysroot; cd cross_sysroot
tar xf ../cross_sysroot.tar
cd ..
../build_gcc_target.sh
cd install
tar cf ../install.tar .
cd ..
cp ../res/* .
podman build --arch aarch64 -t cross_builder_aarch64 .
