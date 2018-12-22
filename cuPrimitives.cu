#include<iostream>
#include<cuda.h>

/*

  Using CUDA warp level primitives
  all threads in a warp are executed in SIMT fashioni

  compute bound workloads

  criteria
  ------------
  performance 
  numerical accuracy and
  thread-safety


  3 topics 
  ------------
  floating point operations
  intrinsic and standard functions
  atomic operations

  
*/

__global__
void float_precision(float* f, double* d){
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  *f = 12.1;
  *d = 12.1;
}

void precision(){
  std::cout << "Testing single and double precision differences in CUDA. \n";

  // Accuracy
  double d = 12.1;
  float f  = 12.1;

  printf("Host single precision representation of 12. 1 : %.32f\n", f);
  printf("Host double precision representation of 12. 1 : %.32f\n", d);

  double* device_d;
  float*  device_f;
  double host_device_d;
  float host_device_f;

  cudaMalloc((void **) &device_f, sizeof(float));
  cudaMalloc((void **) &device_d, sizeof(double));
  float_precision<<<1,32>>>(device_f, device_d);

  cudaMemcpy(&host_device_f, device_f, sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(&host_device_d, device_d, sizeof(double), cudaMemcpyDeviceToHost);

  printf("Device single precision representation of 12. 1 : %.32f\n", host_device_f);
  printf("Device double precision representation of 12. 1 : %.32f\n", host_device_d);

  if (host_device_d == d) printf("Double representation is same for host and device.\n");
  if (host_device_f == f) printf("Float representation is same for host and device.\n");

  printf("Difference between single and double precision : %.32f\n", d-f);
  // Performance


  // Correctness
}
int main(int argc, char** argv){
  precision();
  return 0;
}
