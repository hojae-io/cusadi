cmake_minimum_required(VERSION 3.15)
project(CusADi)

# Find CUDA package
include(CheckLanguage)
check_language(CUDA)
find_package(CUDAToolkit REQUIRED)
if(CMAKE_CUDA_COMPILER)
enable_language(CUDA)
include_directories(${CUDA_INCLUDE_DIRS})
message("CUDA found")
endif()
if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
    # 80 = A100 (brl-aloha), 86 = RTX 30xx (185), 89 = RTX 4090 (brl-temp), 90 = Hopper
    # (cluster). A cubin runs only on the same major at equal-or-higher minor, so every
    # target needs its own entry; the fat binary then loads unchanged on all of them.
    set(CMAKE_CUDA_ARCHITECTURES 80 86 89 90)
endif()
message(${CMAKE_CUDA_ARCHITECTURES})

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)

# Set CUDA flags
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -O3 --use_fast_math)

set(INERTIAL_QUANTITIES_SOURCE codegen/inertial_quantities.cu)

# Include directories for your header files
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_library(inertial_quantities SHARED ${INERTIAL_QUANTITIES_SOURCE})
target_link_libraries(inertial_quantities)
