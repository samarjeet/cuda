#include<iostream>
#include<cuda.h>
#include<stdio.h>

__global__
void kernel_fmad(float* ptr, float* res){
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  //if (tid == 0)
    *res = *ptr * *ptr + *ptr;
  printf("Result is : %f \n", *res);
}

__global__
void kernel_fmad2(float ptr1, float ptr2, float* res){
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  //if (tid == 0)
    *res = ptr1 * ptr1 + ptr2;
}

void fmad(float* ptr, float* res){
  *res = *ptr * *ptr + *ptr;
}

int main(int argc, char** argv){
  float *host_f, *host_res;
  float *device_f, *device_res ;
  float host_device_res;

  host_f = (float*)malloc(sizeof(float));
  host_res = (float*)malloc(sizeof(float));
  *host_f = 12.6f;
  //cudaMalloc((void **)&device_f, sizeof(float));
  cudaMalloc((void **)&device_res, sizeof(float));
  
  //cudaMemcpy(device_f, host_f, sizeof(float), cudaMemcpyHostToDevice);

  fmad(host_f, host_res);
  //kernel_fmad<<<1,32>>>(device_f, device_res);
  float x = 12.6f;
  float y = 12.6f;
  kernel_fmad2<<<1,32>>>(x,y, device_res);
  cudaMemcpy(&host_device_res, device_res, sizeof(float), cudaMemcpyDeviceToHost);
  printf("Host kernel : %f \n", *host_res);
  printf("Device kernel : %f \n", host_device_res);
  //cudaFree(device_f);
  free(host_f);
  return 0;
}
