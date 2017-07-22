#!/bin/bash
set -e

A=`tput setaf 3 && tput bold`
B=`tput sgr0`

# some options
export CC="${CC:-/usr/bin/gcc -m32}"
export LD="${LD:-/usr/bin/ld}"
export PREFIX="${PREFIX:-/usr/local/i387elfgcc}"

# some constant values
export TARGET="i386-elf"
export PATH="$PREFIX/bin:$PATH"

# create some temporary directories
SRCDIR="`mktemp -d -t src.XXXXXX`"
echo "$A(01) created directory '$SRCDIR' ...$B"

# binutils
echo "$A(02) downloading binutils ...$B"
cd "$SRCDIR"
curl -O "https://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz"
tar -xf "binutils-2.28.tar.gz"

mkdir binutils-build && cd binutils-build

echo "$A(03) configuring binutils ...$B"
../binutils-2.28/configure --target="$TARGET" --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix="$PREFIX" 2>&1 | tee configure.log && (exit ${PIPE_STATUS[0]})

echo "$A(04) installing binutils ...$B"
make all install 2>&1 | tee install.log

# gcc
echo "$A(05) downloading gcc ...$B"
cd "$SRCDIR"
curl -O "https://ftp.gnu.org/gnu/gcc/gcc-4.9.1/gcc-4.9.1.tar.gz"
tar -xf "gcc-4.9.1.tar.gz"

mkdir gcc-build && cd gcc-build

echo "$A(06) configuring gcc ...$B"
../gcc-4.9.1/configure --target="$TARGET" --prefix="$PREFIX" --disable-nls --disable-libssp --enable-languages=c --without-headers | tee configure.log && (exit ${PIPE_STATUS[0]})

echo "$A(07) building gcc ...$B"
make all-gcc
echo "$A(08) building libgcc ...$B"
make all-target-libgcc

echo "$A(09) installing gcc ...$B"
make install-gcc
echo "$A(10) installing libgcc ...$B"
make install-target-libgcc
