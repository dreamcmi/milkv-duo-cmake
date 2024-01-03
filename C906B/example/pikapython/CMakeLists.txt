cmake_minimum_required(VERSION 3.16.5)

set(CONFIG_CORE_C906B 1)

include($ENV{MILKV_DUO_CMAKE_ROOT}/cmake/project.cmake)

project(pikapython)

# 默认必须存在文件main.c
# 多文件请使用target_source添加
