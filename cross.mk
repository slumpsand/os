SHELL := /bin/bash

A := $(shell tput setaf 3 && tput bold)
B := $(shell tput sgr0)

export PATH := "/opt/cross/bin:$(PATH)"

build:
	@read -p "$(A)building at: '$(PWD)', ok? $(B)" -n 1 -r && test "$$REPLY" = "y"
	@echo

	mkdir -p build-gcc build-binutils build-gdb

	@echo "$(A)(01) downloading ...$(B)"
	curl -O https://ftp.gnu.org/gnu/gcc/gcc-7.1.0/gcc-7.1.0.tar.gz
	curl -O https://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz
	curl -O https://ftp.gnu.org/gnu/gdb/gdb-8.0.tar.gz

	@echo "$(A)(02) extracting ...$(B)"
	tar -xf gcc-7.1.0.tar.gz
	tar -xf binutils-2.28.tar.gz
	tar -xf gdb-8.0.tar.gz

	@echo "$(A)(03) configuring binutils ...$(B)"
	cd build-binutils && ../binutils-2.28/configure --prefix=/opt/cross \
	     --target=i386-elf --enable-interwork --enable-multilib --disable-nls \
	     --disable-werror

	@echo "$(A)(04) building binutils ...$(B)"
	cd build-binutils && make -j8

	@echo "$(A)(05) installing binutils ...$(B)"
	cd build-binutils && make install

	@echo "$(A)(06) configuring gcc ...$(B)"
	cd gcc-7.1.0 && ./contrib/download_prerequisites
	cd build-gcc && ../gcc-7.1.0/configure --prefix=/opt/cross \
	    --target=i386-elf --disable-nls --disable-libssp --enable-languages=c \
	    --without-headers

	@echo "$(A)(07) building gcc ...$(B)"
	cd build-gcc && make -j8 all-gcc

	@echo "$(A)(08) building libgcc ...$(B)"
	cd build-gcc && make -j8 all-target-libgcc

	@echo "$(A)(09) installing gcc ...$(B)"
	cd build-gcc && make install-gcc

	@echo "$(A)(10) installing libgcc ...$(B)"
	cd build-gcc && make install-target-libgcc

	@echo "$(A)(11) configuring gdb ...$(B)"
	cd build-gdb && ../gdb-8.0/configure --prefix=/opt/cross --target=i386-elf \
		--program-prefix=i386-elf-

	@echo "$(A)(12) building gdb ...$(B)"
	cd build-gdb && make -j8

	@echo "$(A)(13) installing gdb ...$(B)"
	cd build-gdb && make install
