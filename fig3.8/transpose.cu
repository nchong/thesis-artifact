//--blockDim=[4,2] --gridDim=[2,2] -DWIDTH=8 -DHEIGHT=8 -DTILE_DIM=4 -DBLOCK_ROWS=2

// Example taken from transpose benchmark in the CUDA SDK (v5.0)
// Note fly in ointment with threadIdx.y invariant (should investigate)

#define WIDTH 8
#define HEIGHT 8
#define TILE_DIM 4
#define BLOCK_ROWS 2

__global__ void transpose(float *odata, float *idata, int width, int height) {
    __requires(width == WIDTH);
    __requires(height == HEIGHT);

    // additional preconditions that we check
    __assert(blockDim.x == TILE_DIM);
    __assert(blockDim.y == BLOCK_ROWS);
    __assert(width  == gridDim.x * TILE_DIM);
    __assert(height == gridDim.y * TILE_DIM);

    int xIndex = blockIdx.x * TILE_DIM + threadIdx.x;
    int yIndex = blockIdx.y * TILE_DIM + threadIdx.y;

    int index_in  = xIndex + width * yIndex;
    int index_out = yIndex + height * xIndex;
  
    for (int i=0;
         __invariant(__mod_pow2(i, BLOCK_ROWS) == 0),
         __invariant(0 <= i),
         __invariant(i <= TILE_DIM),
         __invariant(__write_implies(odata, __write_offset_bytes(odata)/sizeof(float) / HEIGHT % TILE_DIM == threadIdx.x)),
         __invariant(__write_implies(odata, __write_offset_bytes(odata)/sizeof(float) % HEIGHT % TILE_DIM % BLOCK_ROWS == threadIdx.y)),
         __invariant(__write_implies(odata, __write_offset_bytes(odata)/sizeof(float) / HEIGHT / TILE_DIM == blockIdx.x)),
         __invariant(__write_implies(odata, __write_offset_bytes(odata)/sizeof(float) % HEIGHT / TILE_DIM == blockIdx.y)),
         i<TILE_DIM; i+=BLOCK_ROWS)
    {
        odata[index_out+i] = idata[index_in+i*width];
    }
}
