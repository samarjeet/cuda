#include<iostream>
#include <cuda.h>

int main(){
  std::cout << "Hello World from CUDA\n";
  cudaDeviceProp iProp;
  cudaGetDeviceProperties(&iProp, 2);
  std::cout << iProp.multiProcessorCount << "\n";
  std::cout << iProp.totalConstMem/1024.0 << " KB \n";
  std::cout << iProp.sharedMemPerBlock/1024.0 << " KB \n";
  std::cout << iProp.regsPerBlock << "  \n";
  std::cout << iProp.maxThreadsPerBlock << "  \n";
  std::cout << iProp.maxThreadsPerMultiProcessor << "  \n";
  std::cout << iProp.maxThreadsPerMultiProcessor/32 << "  \n";
  return 0;
}
