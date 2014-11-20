//--local_size=8 --num_groups=1 --adversarial-abstraction

#define tid get_local_id(0)

__kernel void k(__local int *A, __local int *B) {
  int v = 2 *  tid;
  int w = 2 *  tid + 1;
  A[v] = A[w];
}
