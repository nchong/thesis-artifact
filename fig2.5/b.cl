//--local_size=8 --num_groups=1

__kernel void b() {
  unsigned tid = get_local_id(0);
  unsigned x = (tid == 0) ? 1 : 4;
  unsigned y = (tid == 0) ? 4 : 1;
  for (unsigned i=0; i<x; i++) {
    barrier(CLK_LOCAL_MEM_FENCE);
    for (unsigned j=0; j<y; j++) {
      barrier(CLK_LOCAL_MEM_FENCE);
    }
  }
}
