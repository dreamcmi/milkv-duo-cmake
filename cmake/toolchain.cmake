set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

if(CONFIG_CORE_C906B)
    set(CORE_NAME "C906B")  # Big Core 0
    set(CMAKE_FIND_ROOT_PATH "$ENV{MILKV_DUO_CMAKE_C906B_ROOT}/sdk/toolchain/bin/")
    set(COMPILER_PREFIX "riscv64-unknown-linux-musl-")

    add_compile_options(
        -mcpu=c906fdv 
        -march=rv64imafdcv0p7xthead 
        -mabi=lp64d 
        -mcmodel=medany
    )
    add_link_options(
        -mcpu=c906fdv 
        -march=rv64imafdcv0p7xthead 
        -mabi=lp64d
    )
    add_definitions(
        -D_LARGEFILE_SOURCE 
        -D_LARGEFILE64_SOURCE 
        -D_FILE_OFFSET_BITS=64
    )
    include_directories(
        $ENV{MILKV_DUO_CMAKE_C906B_ROOT}/sdk/rootfs/usr/inlcude
    )
    link_directories(
        $ENV{MILKV_DUO_CMAKE_C906B_ROOT}/sdk/rootfs/lib 
        $ENV{MILKV_DUO_CMAKE_C906B_ROOT}/sdk/rootfs/usr/lib
    )

elseif(CONFIG_CORE_C906L)
    set(CORE_NAME "C906L")  # Little Core
    set(CMAKE_FIND_ROOT_PATH "$ENV{MILKV_DUO_CMAKE_C906L_ROOT}/sdk/toolchain/bin/")
    set(COMPILER_PREFIX " riscv64-unknown-elf-")
    set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
    set(CMAKE_SYSTEM_PROCESSOR RISCV)

    add_compile_options(
        -mcpu=c906fdv 
        -march=rv64imafdcv0p7xthead 
        -mabi=lp64d 
        -mcmodel=medany 
        -ffunction-sections 
        -fdata-sections 
        -fno-builtin
    )
    add_link_options(
        -mcpu=c906fdv 
        -march=rv64imafdcv0p7xthead 
        -mabi=lp64d 
        -nostdlib 
        -Wl,--gc-sections
    )
    add_definitions(
        -DFREERTOS_BSP
        -DLINUX_BSP_64MB 
        # -DLINUX_BSP_128MB
        -D__riscv_xlen=64
        -DTHEAD_C906
        -DCONFIG_64BIT
        -DRISCV_FPU
    )

elseif(CONFIG_CORE_CA53)
    set(CORE_NAME "CA53")   # Big Core 1
    set(CMAKE_FIND_ROOT_PATH "$ENV{MILKV_DUO_CMAKE_CA53_ROOT}/sdk/toolchain/bin/")
    set(COMPILER_PREFIX "aarch64-linux-gnu-")

    add_compile_options(
        -mcpu=cortex-a53
    )
    include_directories(
        $ENV{MILKV_DUO_CMAKE_CA53_ROOT}/sdk/rootfs/usr/inlcude
    )
    link_directories(
        $ENV{MILKV_DUO_CMAKE_CA53_ROOT}/sdk/rootfs/lib 
        $ENV{MILKV_DUO_CMAKE_CA53_ROOT}/sdk/rootfs/usr/lib
    )

else()
    message(FATAL_ERROR "Please set the core name, the options are C906B, C906L, CA53.")
endif()


if(WIN32)
    set(COMPILER_SUFFIX ".exe")
else()
    set(COMPILER_SUFFIX "")
endif()

set(CMAKE_C_COMPILER ${CMAKE_FIND_ROOT_PATH}${COMPILER_PREFIX}gcc${COMPILER_SUFFIX})
set(CMAKE_CXX_COMPILER ${CMAKE_FIND_ROOT_PATH}${COMPILER_PREFIX}g++${COMPILER_SUFFIX})
set(CMAKE_ASM_COMPILER ${CMAKE_FIND_ROOT_PATH}${COMPILER_PREFIX}gcc${COMPILER_SUFFIX})
set(CMAKE_AR ${CMAKE_FIND_ROOT_PATH}${COMPILER_PREFIX}ar${COMPILER_SUFFIX})
set(CMAKE_OBJCOPY ${CMAKE_FIND_ROOT_PATH}${COMPILER_PREFIX}objcopy${COMPILER_SUFFIX})
set(CMAKE_OBJDUMP ${CMAKE_FIND_ROOT_PATH}${COMPILER_PREFIX}objdump${COMPILER_SUFFIX})
set(CMAKE_SIZE ${CMAKE_FIND_ROOT_PATH}${COMPILER_PREFIX}size${COMPILER_SUFFIX})

set(CMAKE_EXPORT_COMPILE_COMMANDS True)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
