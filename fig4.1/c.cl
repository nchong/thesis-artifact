//--local_size=8 --num_groups=1 --equality-abstraction

#define tid get_local_id(0)

__kernel void k(__local int *A, __local int *B) {
  A[tid] = tid;
//__barrier_invariant_1(A[tid] == tid, tid);
  barrier(CLK_LOCAL_MEM_FENCE);
  int v = tid;
  __assert(A[v] == v);
}
