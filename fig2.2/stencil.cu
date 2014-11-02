#define N 8
#include <cstdio>
#include "stencil-app.cu"

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

