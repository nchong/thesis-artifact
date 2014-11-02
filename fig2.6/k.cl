//--local_size=8 --num_groups=1

#define N 8

__kernel void k(__local int *A, __local int *B) {
  __requires(A[get_local_id(0)] == get_local_id(0));
  unsigned tid = get_local_id(0);
  A[tid] = 0;
  barrier(CLK_LOCAL_MEM_FENCE);
  if (tid != N-1) {
    B[A[tid+1]] = tid;
  }
}
