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
    # 86 = Ampere (RTX 30xx), 90 = Hopper (H100/H200). Each arch is a full recompile of the
    # kernel, so keep this list to the GPUs actually in use.
    set(CMAKE_CUDA_ARCHITECTURES 86 90)
endif()
message(${CMAKE_CUDA_ARCHITECTURES})

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)

# Set CUDA flags
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -O3 -arch=sm_86 --use_fast_math)  # Adjust architecture as needed

set(INERTIAL_QUANTITIES_SOURCE codegen/inertial_quantities.cu)

# Include directories for your header files
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_library(inertial_quantities SHARED ${INERTIAL_QUANTITIES_SOURCE})
target_link_libraries(inertial_quantities)
