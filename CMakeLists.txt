cmake_minimum_required(VERSION 3.7)
project(cudaPerfProj LANGUAGES CXX  CUDA )

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
find_package(CUDA)
add_executable(cudaPerfProj b.cu)
set_property(TARGET cudaPerfProj PROPERTY CUDA_STANDARD 11)
add_executable(cudaMatrixSum matrixSum.cu)
set_property(TARGET cudaMatrixSum PROPERTY CUDA_STANDARD 11)
add_executable(cuPrimitives cuPrimitives.cu)
set_property(TARGET cuPrimitives PROPERTY CUDA_STANDARD 11)

