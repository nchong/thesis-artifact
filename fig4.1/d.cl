//--local_size=8 --num_groups=1

#define tid get_local_id(0)
#define N 8

__kernel void k(__local int *A, __local int *B) {
  A[tid] = tid;
  __barrier_invariant_2(A[tid] == tid, (tid+1)%N, __other_int((tid+1)%N));
  barrier(CLK_LOCAL_MEM_FENCE);
  int v = (tid + 1) % N;
  __assert(A[v] == v);
}
