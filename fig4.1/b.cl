//--local_size=8 --num_groups=1 --adversarial-abstraction

#define tid get_local_id(0)

__kernel void k(__local int *A, __local int *B) {
  int v = B[0];
  int w = v ? tid : tid + 1;
  A[w] = tid;
  int vprime = B[0];
  __assert(v == vprime);
}
