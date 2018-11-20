cmake_minimum_required(VERSION 3.7)
project(cudaPerfProj LANGUAGES CXX  CUDA )

set(CMAKE_CXX_STANDARD 11)
find_package(CUDA)
message("${CUDA_NVCC_FLAGS}")
add_executable(cudaPerfProj b.cu)
add_executable(cudaMatrixSum matrixSum.cu)

