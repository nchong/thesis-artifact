__global__ void stencil(int *A, int *B, int radius, unsigned n) {
  unsigned tid = blockDim.x * blockIdx.x + threadIdx.x;

  int sum = 0;
  for (int i=-radius; i<=radius; i++) {
    int idx = tid + i;
    if (0 <= idx && idx < n) {
      sum += A[idx];
    }
  }

  if (tid < n) B[tid] = sum;
}

void hostStencil(int *A, int *B, int radius, unsigned n) {
  // device copies of A and B
  int *d_A; int *d_B;

  // allocate arrays on device
  size_t sz = sizeof(int)*n;
  cudaMalloc(&d_A, sz); cudaMalloc(&d_B, sz);

  // copy input to device
  cudaMemcpy(d_A, A, sz, cudaMemcpyHostToDevice);

  // launch kernel
  stencil<<<1,n>>>(d_A, d_B, radius, n);

  // copy output from device
  cudaMemcpy(B, d_B, sz, cudaMemcpyDeviceToHost);

  // free allocated arrays
  cudaFree(d_A); cudaFree(d_B);
}

