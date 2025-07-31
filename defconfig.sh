#!/bin/bash

kernel_dir="${PWD}"
objdir="${kernel_dir}/out"
TC_DIR=$HOME/tc
CLANG_DIR=$TC_DIR/clang-r547379
export CONFIG_FILE="peridot_defconfig"
export ARCH="arm64"
export KBUILD_BUILD_HOST=raghavt20
export KBUILD_BUILD_USER=raghav

export PATH="$CLANG_DIR/bin:$PATH"
if ! [ -d "$TC_DIR" ]; then
    echo "Toolchain not found! Cloning to $TC_DIR..."
    if ! git clone -q --depth=1 --single-branch https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 -b master $TC_DIR; then
        echo "Cloning failed! Aborting..."
        exit 1
    fi
fi

# Colors
NC='\033[0m'
RED='\033[0;31m'
LRD='\033[1;31m'
LGR='\033[1;32m'

make_defconfig() {
    START=$(date +"%s")
    echo -e ${LGR} "########### Generating Defconfig ############${NC}"
    make -s ARCH=${ARCH} O=${objdir} CC=clang HOSTCC=clang ${CONFIG_FILE} savedefconfig LLVM=1 LLVM_IAS=1 -j$(nproc --all)
    cp $objdir/defconfig arch/arm64/configs/peridot_defconfig
}

make_defconfig
