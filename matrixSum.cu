#include<iostream>
#include<stdio.h>
#include <cuda.h>

int getDeviceProperties(){
  cudaDeviceProp iProp;
  int nDevices;
  
  cudaGetDeviceCount(&nDevices);
  std::cout << "Number of CUDA devices :  " << nDevices << "\n";
  std::cout << "Properties of device : " << nDevices - 1 << "\n";
  cudaGetDeviceProperties(&iProp, nDevices-1);
  std::cout << "Device name : " << iProp.name << "\n";
  std::cout << "Number of multiprocessors : " << iProp.multiProcessorCount << "\n";
  std::cout << iProp.totalConstMem/1024.0 << " KB \n";
  std::cout << iProp.sharedMemPerBlock/1024.0 << " KB \n";
  std::cout << iProp.regsPerBlock << "  \n";
  std::cout << iProp.maxThreadsPerBlock << "  \n";
  std::cout << iProp.maxThreadsPerMultiProcessor << "  \n";
  std::cout << iProp.maxThreadsPerMultiProcessor/32 << "  \n";
  return 0;
}

__global__ void sumMatrixOnGPU2D(float *A, float *B, float *C, int nx, int ny){
  unsigned int ix = blockIdx.x * blockDim.x + threadIdx.x;
  unsigned int iy = blockIdx.y * blockDim.y + threadIdx.y;

  unsigned int idx = iy * nx + ix;
  if (ix < nx && iy < ny) {
    c[ix] = a[ix] + b[ix];
  }
}

int main(int argc, char *argv[]){
  int nx = 1<<14;
  int ny = 1<<14;

  int dimx, dimy;
  if (argc > 2) {
    dimx = atoi(argv[1]);
    dimy = atoi(argv[2]);
  }
  else {
    dimx = 32;
    dimy = 32;
  }

  dim3 block(dimx, dimy);
  dim3 grid((nx + block.x - 1 )/ block.x, (ny + block.y -1)/block.y);

  return 0; 
}
