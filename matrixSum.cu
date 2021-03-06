#include<iostream>
#include<stdio.h>
#include <cuda.h>
#include <chrono>
#include <random>
#include "common.h"

int getDeviceProperties(){
  cudaDeviceProp iProp;
  int nDevices;
  
  cudaGetDeviceCount(&nDevices);
  //std::cout << "Number of CUDA devices :  " << nDevices << "\n";
  //std::cout << "Properties of device : " << nDevices - 1 << "\n";
  cudaGetDeviceProperties(&iProp, nDevices-1);
  std::cout << "Device name : " << iProp.name << "\n";
  std::cout << " Major, minor : " << iProp.major << "." << iProp.minor  << "\n";
  std::cout << "Number of multiprocessors : " << iProp.multiProcessorCount << "\n";
  //std::cout << iProp.totalConstMem/1024.0 << " KB \n";
  //std::cout << iProp.sharedMemPerBlock/1024.0 << " KB \n";
  //std::cout << iProp.regsPerBlock << "  \n";
  //std::cout << iProp.maxThreadsPerBlock << "  \n";
  //std::cout << iProp.maxThreadsPerMultiProcessor << "  \n";
  std::cout << "Max warps per SM : " << iProp.maxThreadsPerMultiProcessor/32 << "  \n";
  return 0;
}

__global__ void sumMatrixOnGPU2D(float *a, float *b, float *c, int nx, int ny){
  unsigned int ix = blockIdx.x * blockDim.x + threadIdx.x;
  unsigned int iy = blockIdx.y * blockDim.y + threadIdx.y;

  unsigned int idx = iy * nx + ix;
  if (ix < nx && iy < ny) {
    c[idx] = a[ix] + b[ix];
  }
}


void initialize(float *a, int size){
  std::default_random_engine generator;
  std::uniform_real_distribution<float> distribution(0.0, 1.0);
  for (int i=0; i< size; ++i){
    a[i] =  distribution(generator);
  }

}


int main(int argc, char *argv[]){
  getDeviceProperties();
  int nx = 1<<14;
  int ny = 1<<14;
  //int nx = 1<<7;
  //int ny = 1<<7;


  float *d_a, *d_b, *d_c;
  float *h_a, *h_b, *h_c;

  h_a = (float*)malloc(sizeof(float)*nx*ny);
  h_b = (float*)malloc(sizeof(float)*nx*ny);
  h_c = (float*)malloc(sizeof(float)*nx*ny);

  //for (int i=0 ; i < nx; ++i){
  //    for (int j=0; j < ny; ++j){
  //        h_a[j * nx + i ] = 1.0;
  //        h_b[j * nx + i ] = 2.0;
  //    }
  //}

  initialize(h_a, nx*ny);
  initialize(h_b, nx*ny);

  cudaMalloc(&d_a, sizeof(float)*nx*ny);
  cudaMalloc(&d_b, sizeof(float)*nx*ny);
  cudaMalloc(&d_c, sizeof(float)*nx*ny);

  cudaMemcpy(&d_a, &h_a, sizeof(float)*nx*ny, cudaMemcpyHostToDevice);
  cudaMemcpy(&d_b, &h_b, sizeof(float)*nx*ny, cudaMemcpyHostToDevice);


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

  //size_t iStart, eElaps;
  CHECK(cudaDeviceSynchronize());
  auto iStart = std::chrono::system_clock::now();
  sumMatrixOnGPU2D<<<grid, block >>>(d_a, d_b, d_c, nx, ny);
  auto iEnd = std::chrono::system_clock::now();
  std::chrono::duration<double> diff = iEnd - iStart;
  std::cout << "Time : " << diff.count() << "s \n";
  cudaMemcpy(&h_c, &d_c, sizeof(float)*nx*ny, cudaMemcpyDeviceToHost);

  // Free device memory
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  // Free host memory
  free(h_a);
  free(h_b);
  free(h_c);
  return 0;
}
