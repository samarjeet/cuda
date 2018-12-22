#include<iostream>
#include <cuda.h>

int main(){
  std::cout << "Hello World from CUDA\n";
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
  std::cout << iProp.major << " " << iProp.minor << "  \n";
  return 0;
}
