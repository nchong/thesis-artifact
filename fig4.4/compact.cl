__kernel void compact(
  __global TYPE *out,
  __global TYPE *data,
  __local unsigned *flag,
  __local unsigned *idx,
  unsigned n) {

  unsigned left, right;
  unsigned tid = get_local_id(0);

  // (i) test each element with predicate p
  flag[tid] = p(data[tid]);
  // (ii) compute indices for compaction
  barrier(CLK_LOCAL_MEM_FENCE); // $\displaystyle\binv{load}$
  if (tid < n/2) {
    idx[2*tid]     = flag[2*tid];
    idx[2*tid + 1] = flag[2*tid + 1];
  }

  // (ii)(a) upsweep
  unsigned offset = 1;
  for (unsigned d = n/2; d > 0; d /= 2) {
    barrier(CLK_LOCAL_MEM_FENCE); // $\displaystyle\binv{us}$
    if (tid < d) {
      left  = offset * (2 * tid + 1) - 1;
      right = offset * (2 * tid + 2) - 1;
      idx[right] += idx[left];
    }
    offset *= 2;
  }

  // (ii)(b) downsweep
  if (tid == 0) idx[n-1] = 0;

  for (unsigned d = 1; d < n; d *= 2) {
    offset /= 2;
    barrier(CLK_LOCAL_MEM_FENCE); // $\displaystyle\binv{ds}$
    if (tid < d) {
      left  = offset * (2 * tid + 1) - 1;
      right = offset * (2 * tid + 2) - 1;
      unsigned temp = idx[left];
      idx[left] = idx[right];
      idx[right] += temp;
    }
  }
  barrier(CLK_LOCAL_MEM_FENCE); // $\displaystyle\binv{spec}$

  // (iii) compaction
  if (flag[tid]) out[idx[tid]] = data[tid];
}
