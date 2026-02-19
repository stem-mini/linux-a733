#!/bin/bash


# from bsp/modules/gpu/Makefile
export GPU_TYPE="bxm"
export GPU_BUILD_TYPE="release"

export LICHEE_KERN_DIR="$(pwd)/src"
export LICHEE_PLATFORM="linux"
export LICHEE_MOD_DIR="$(pwd)/bsp/modules/gpu/ins"
export LICHEE_OUT_DIR=${LICHEE_KERN_DIR}


# 编译系统相关
export CONFIG_ARM64=y
export ARCH=arm64
export LICHEE_ARCH=arm64
export LICHEE_KERNEL_ARCH=arm64
export LICHEE_TOOLCHAIN_PATH=/home/neptine/Desktop/a7z-android/longan/out/toolchain/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu
export LICHEE_CROSS_COMPILER=aarch64-none-linux-gnu
# 下面是我自己加的
export CROSS_COMPILE=${LICHEE_TOOLCHAIN_PATH}/bin/${LICHEE_CROSS_COMPILER}-


export LICHEE_IC=a733
export KERNEL_SRC=${LICHEE_KERN_DIR}
export BUILD_OUT_DIR=${LICHEE_OUT_DIR}/${LICHEE_IC}/kernel/build
export STAGING_DIR=${LICHEE_OUT_DIR}/${LICHEE_IC}/kernel/staging

__MAKE="make"
MAKE=${__MAKE}
MAKE+=" ARCH=${LICHEE_KERNEL_ARCH} O=${BUILD_OUT_DIR}"
MAKE+=" KERNEL_SRC=$KERNEL_SRC INSTALL_MOD_PATH=${STAGING_DIR}"
export GPU_MAKE=${MAKE}

function build_gpu(){
    # 构建
    module_path="${KERNEL_SRC}/bsp/modules/gpu"
    if [ ! -e ${KERNEL_SRC}/bsp/modules/gpu ]; then
        printf "${KERNEL_SRC}/bsp/modules/gpu does not exist!\n"
        return
    fi
    printf "\033[34;1m[%4s]: %s\033[0m\n" "GPU" "Start build GPU driver"
    printf "\033[34;1m[%4s]: %s\033[0m\n" "GPU" "Clean------------------------------------------------------"
    ${MAKE} -C ${KERNEL_SRC}/bsp/modules/gpu M=${KERNEL_SRC}/bsp/modules/gpu clean
    printf "\033[34;1m[%4s]: %s\033[0m\n" "GPU" "Build------------------------------------------------------"
    ${MAKE} -C ${KERNEL_SRC}/bsp/modules/gpu M=${KERNEL_SRC}/bsp/modules/gpu build -j1
    printf "\033[34;1m[%4s]: %s\033[0m\n" "GPU" "Install----------------------------------------------------"
    ${MAKE} -C ${KERNEL_SRC}/bsp/modules/gpu M=${KERNEL_SRC}/bsp/modules/gpu modules_install
    # echo "build gpus"
    # make "$@"
}
build_gpu
