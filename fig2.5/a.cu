//--blockDim=8 --gridDim=1

__global__ void a() {
  unsigned tid = threadIdx.x;
  if ((tid % 2) == 0)
    __syncthreads();
  else
    __syncthreads();
}
