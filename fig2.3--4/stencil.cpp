#ifdef __APPLE__
  #include <OpenCL/opencl.h>
#elif __linux__
  #include <CL/cl.h>
#else
  #error Not sure where to find OpenCL header
#endif
#include <iostream>
#include <fstream>
#include <cassert>
#include <cstdio>
#include <sstream>

#include "stencil-host.h"

#define N 8

int main() {
  int *A = new int[N];
  for (int i=0; i<N; i++) {
    A[i] = i;
  }
  printf("A = [ ");
  for (int i=0; i<N-1; ++i) {
    printf("%d, ", A[i]);
  }
  printf("%d ]\n", A[N-1]);
  hostStencil(A, A, 1, N);
  printf("A = [ ");
  for (int i=0; i<N-1; ++i) {
    printf("%d, ", A[i]);
  }
  printf("%d ]\n", A[N-1]);
  delete A;
  return 0;
}
