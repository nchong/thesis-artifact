//--gridDim=[1] --blockDim=[4]

#define N 4

__global__ void saxpy(float a, float *x, float *y) {
  unsigned tid = threadIdx.x;

  for (int i=0;
       __invariant((0 <= i) & (i <= N)),
       __invariant(__read_implies(y, __read_offset_bytes(y)/sizeof(float)/N == threadIdx.x)),
       __invariant(__write_implies(y, __write_offset_bytes(y)/sizeof(float)/N == threadIdx.x)),
       i<N; i++) {
    unsigned idx = (tid * N) + i;
    y[idx] = a * x[idx] + y[idx];
  }
}
