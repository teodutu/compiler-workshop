cmake_minimum_required(VERSION 3.10)
project(FunctionPass LANGUAGES CXX)

SET(CMAKE_CXX_FLAGS "-Wall -fno-rtti")

# Find LLVM
find_package(LLVM REQUIRED CONFIG)

# Set LLVM paths
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# Add the pass
add_library(FunctionPass MODULE FunctionPass.cpp)
