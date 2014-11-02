__kernel void stencil(__global int *A, __global int *B, int radius, unsigned n) {
  unsigned tid = get_global_id(0);

  int sum = 0;
  for (int i=-radius; i<=radius; i++) {
    int idx = tid + i;
    if (0 <= idx && idx < n) {
      sum += A[idx];
    }
  }

  if (tid < n) B[tid] = sum;
}
