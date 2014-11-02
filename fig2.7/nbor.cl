//--local_size=8 --num_groups=1

__kernel void nbor(__local int *A, unsigned i, unsigned n) {
  int v, w;
  unsigned tid = get_local_id(0);
  v = 0;
  if (tid + i < n) {
    v = A[tid + i];
  }
  w = A[tid];
#ifdef APPLY_FIX
  barrier(CLK_LOCAL_MEM_FENCE);
#endif
  A[tid] = v + w;
}
