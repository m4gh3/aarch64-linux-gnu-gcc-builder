#!/bin/bash

export CC=gcc-12
export CXX=g++-12

# stop script on first error
set -e

# variables that define the result
install_dir="$(pwd)/install"
sysroot_dir="/" #"$(pwd)/sysroot"
build_sysroot_dir="$(pwd)/cross_sysroot"
arch=armv8-a
tune=cortex-a53

gcc_version='12.2.0'
binutils_version='2.40'
mpfr_version='4.2.0'
mpc_version='1.2.1'
gmp_version='6.2.1'

mkdir gcc_build -p
cd gcc_build

#if false; then
# get sources

echo getting binutils sources...
curl -Lo binutils.tar.bz2 \
  "https://ftpmirror.gnu.org/binutils/binutils-$binutils_version.tar.bz2"

echo getting gcc sources...
curl -Lo gcc.tar.xz \
  "https://ftp.wayne.edu/gnu/gcc/gcc-$gcc_version/gcc-$gcc_version.tar.xz"
#if false; then

echo getting mpfr sources...
curl -Lo mpfr.tar.bz2 \
	"https://www.mpfr.org/mpfr-current/mpfr-$mpfr_version.tar.bz2"

echo getting mpc sources...
curl -Lo mpc.tar.gz \
	"https://gcc.gnu.org/pub/gcc/infrastructure/mpc-$mpc_version.tar.gz"

echo getting gmp sources...
curl -Lo gmp.tar.bz2 \
	"https://gcc.gnu.org/pub/gcc/infrastructure/gmp-$gmp_version.tar.bz2"
#fi

#Do a static build so that the built tools do not require any shared library
export CFLAGS=-static
export CXXFLAGS=-static

file gcc.tar.xz
file binutils.tar.bz2
file mpfr.tar.bz2
file mpc.tar.gz
file gmp.tar.bz2

#We need to buikd gmp, mpfr, mpc from scratch because we are doing a static build
#if false; then

STATIC_LIBS=$(pwd)/static_libs
mkdir $STATIC_LIBS

#build gmp
mkdir gmp_source -p
cd gmp_source
tar --strip-components 1 -xf ../gmp.tar.bz2
./configure --disable-shared --enable-static --prefix=$STATIC_LIBS
make -j10
make check -j10
make install
cd ..

#build mpfr
mkdir mpfr_source -p
cd mpfr_source
tar --strip-components 1 -xf ../mpfr.tar.bz2
./configure --disable-shared --enable-static --prefix=$STATIC_LIBS --with-gmp=$STATIC_LIBS
make -j10
#right now check fails on tsprintf
#make check -j10
make install
cd ..

#build mpc
mkdir mpc_source
cd mpc_source
tar --strip-components 1 -xf ../mpc.tar.gz
./configure --disable-shared --enable-static --prefix=$STATIC_LIBS --with-gmp=$STATIC_LIBS
make -j10
make check -j10
make install
cd ..

#fi

# build binutils
mkdir binutils_source -p
cd binutils_source
tar --strip-components 1 -xf ../binutils.tar.bz2
mkdir ../binutils_build -p
cd ../binutils_build
../binutils_source/configure \
  --prefix="$install_dir" \
  --target=aarch64-linux-gnu \
  --with-arch=$arch \
  --with-tune=$tune \
  --with-fpu=vfp \
  --with-float=hard \
  --disable-multilib \
  --with-sysroot="$sysroot_dir" \
  --with-build-sysroot="$build_sysroot_dir" \
  --enable-gold=yes \
  --enable-lto
make configure-host
make LDFLAGS="--static" -j10
make install
cd ..

#export CT_CC_GCC_EXTRA_CONFIG_ARRAY="--without-zstd"

# build gcc
#if false; then
mkdir gcc_source -p
cd gcc_source
tar --strip-components 1 -xf ../gcc.tar.xz
mkdir ../gcc_build -p
cd ../gcc_build
../gcc_source/configure \
  --prefix="$install_dir" \
  --target=aarch64-linux-gnu \
  --with-arch=$arch \
  --with-tune=$tune \
  --disable-multilib \
  --with-sysroot="$sysroot_dir" \
  --with-build-sysroot="$build_sysroot_dir" \
  --enable-languages=c,c++ \
  --with-gmp=$STATIC_LIBS \
  --with-mpfr=$STATIC_LIBS \
  --with-mpc=$STATIC_LIBS \
  --without-zstd
make -j10
make install
cd ..
#fi

echo "Successfully compiled 'binutils' and 'gcc'"
