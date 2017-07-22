#!/bin/bash
set -e

# this script is build to run on a 64-bit environment (but create
# 32-bit executables). The package 'gcc-multilib' is therefor required

# settings
export CC="/usr/bin/gcc -m32"
export LD="/usr/bin/ld"
export PREFIX="/usr/local/i386-elf-gcc"
export TARGET="i386-elf"
export BINUTILS_VERSION="2.28"
export GCC_VERSION="7.1.0"

# calculated values
export PATH="$PREFIX/bin:$PATH"
export BUILDDIR="`mktemp -d -t build.XXXXXX`"
export A="`tput setaf 3 && tput bold`"
export B="`tput sgr0`"
export GCC_DIR="gcc-$GCC_VERSION"
export BINUTILS_DIR="binutils-$BINUTILS_VERSION"

echo "$A(01) building into directory '$BUILDDIR' ...$B"
cd "$BUILDDIR"
mkdir {log,gcc-build,binutils-build}

echo "$A(02) downloading sources ...$B"
wget -O "https://ftp.gnu.org/gnu/$BINUTILS_DIR.tar.gz"
wget -O "https://ftp.gnu.org/gnu/gcc/$GCC_DIR/$GCC_DIR.tar.gz"

echo "$A(03) extracting sources ...$B"
tar -xf "$BINUTILS_DIR.tar.gz"
tar -xf "$GCC_DIR.tar.gz"

echo "$A(04) configuring binutils ...$B"
cd "$BUILDDIR/binutils-build"
"../$BINUTILS_DIR/configure" --target="$TARGET" --enable-interwork --enable-multilib \
	--disable-nls --disable-werror --prefix="$PREFIX" \
	2>&1 | tee ../log/binutils-configure.log && (exit ${PIPE_STATUS[0]})

echo "$A(05) building / installing binutils ...$B"
make all install 2>&1 | tee ../log/binutils-install.log && (exit ${PIPE_STATUS[0]})

echo "$A(06) configuring gcc ...$B"
cd "$BUILDDIR/gcc-build"
"../GCC_DIR/configure" --target="$TARGET" --prefix="$PREFIX" --disable-nls --disable-libssp \
	--enable-languages=c --without-headers \
	2>&1 | tee ../log/gcc-configure.log && (exit ${PIPE_STATUS[0]})

echo "$A(07) building gcc ...$B"
make all-gcc

echo "$A(08) building libgcc ...$B"
make all-target-libgcc

echo "$A(09) installing gcc ...$B"
make install-gcc

echo "$A(10) installing gcclib ...$B"
make install-target-libgcc
