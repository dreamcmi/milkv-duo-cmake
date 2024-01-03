include($ENV{MILKV_DUO_CMAKE_ROOT}/cmake/toolchain.cmake)

macro(project name)

    set(PRJ_NAME "${name}-${CORE_NAME}")
    _project(${PRJ_NAME} C CXX ASM)

    add_executable(${PRJ_NAME} main.c)

    target_compile_options(
        ${PRJ_NAME} 
        PUBLIC 
        -Wall
        # -Werror
        $<$<COMPILE_LANGUAGE:C>:-std=c11>
        $<$<COMPILE_LANGUAGE:CXX>:-std=c++11>
        -g3
        -O2
    )

    target_link_options(
        ${PRJ_NAME} 
        PUBLIC 
        -Wl,-Map,${PRJ_NAME}.map 
    )

    target_link_libraries(
        ${PRJ_NAME} PRIVATE
        -Wl,--whole-archive
        wiringx
        -Wl,--no-whole-archive
    )

    set(LST_FILE ${PROJECT_BINARY_DIR}/${PRJ_NAME}.lst)
    add_custom_command(TARGET ${PRJ_NAME} POST_BUILD
        COMMAND ${CMAKE_OBJDUMP} --all-headers --demangle --disassemble $<TARGET_FILE:${PRJ_NAME}> > ${LST_FILE}
        COMMAND ${CMAKE_SIZE} --format=berkeley $<TARGET_FILE:${PRJ_NAME}>
    )
endmacro()
