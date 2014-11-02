#ifdef __APPLE__
  #include <OpenCL/opencl.h>
#elif __linux__
  #include <CL/cl.h>
#else
  #error Not sure where to find OpenCL header
#endif
#include <iostream>
#include <fstream>
#include <cassert>
#include <cstdio>
#include <sstream>

void hostCompact(char *out, char *data, unsigned n) {
  // setup OpenCL platform and device
  cl_platform_id platform;
  cl_device_id device;
  clGetPlatformIDs(1, &platform, NULL);
  clGetDeviceIDs(platform, CL_DEVICE_TYPE_DEFAULT, 1, &device, NULL);
  cl_context context = clCreateContext(NULL, 1, &device, NULL, NULL, NULL);
  cl_command_queue queue = clCreateCommandQueue(context, device, 0, NULL);

  // fetch and compile kernel
  std::ifstream f("compact.cl", std::ios::in);
  std::stringstream ss;
  ss << "#define TYPE char\n";
  ss << "#define p(x) (x == 'A' || x == 'C' || x == 'D' || x == 'G')\n";
  ss << f.rdbuf();
  const std::string& str = ss.str();
  const char *s = str.c_str();
  cl_program program = clCreateProgramWithSource(context, 1, (const char **)&s, NULL, NULL);
  clBuildProgram(program, 1, &device, NULL, NULL, NULL);
  cl_kernel kernel = clCreateKernel(program, "compact", NULL);

  // device copies of out and data
  cl_mem d_out; cl_mem d_data;

  // allocate arrays on device
  size_t sz = sizeof(char)*n;
  d_out = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sz, NULL, NULL);
  d_data = clCreateBuffer(context, CL_MEM_READ_ONLY, sz, NULL, NULL);

  // copy input to device
  clEnqueueWriteBuffer(queue, d_data, CL_TRUE, 0, sz, data, 0, NULL, NULL);
  clEnqueueWriteBuffer(queue, d_out, CL_TRUE, 0, sz, out, 0, NULL, NULL);

  // launch kernel
  clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&d_out);
  clSetKernelArg(kernel, 1, sizeof(cl_mem), (void *)&d_data);
  clSetKernelArg(kernel, 2, sizeof(unsigned)*n, NULL);
  clSetKernelArg(kernel, 3, sizeof(unsigned)*n, NULL);
  clSetKernelArg(kernel, 4, sizeof(unsigned), (void *)&n);
  size_t global_work_size = n; size_t local_work_size = n;
  clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_work_size, &local_work_size, 0, NULL, NULL);
  clFinish(queue);

  // copy output from device
  clEnqueueReadBuffer(queue, d_out, CL_TRUE, 0, sz, out, 0, NULL, NULL);

  // free allocated arrays
  clReleaseMemObject(d_out);
  clReleaseMemObject(d_data);
}


#define N 8

int main() {
  char *data = new char[N];
  char *out = new char[N];
  char c = 'A';
  for (int i=0; i<N; i++) {
    data[i] = c++;
    out[i] = '-';
  }
  printf("data = [ ");
  for (int i=0; i<N-1; ++i) {
    printf("%c, ", data[i]);
  }
  printf("%c ]\n", data[N-1]);
  printf("out  = [ ");
  for (int i=0; i<N-1; ++i) {
    printf("%c, ", out[i]);
  }
  printf("%c ]\n", out[N-1]);

  hostCompact(out, data, N);

  printf("out' = [ ");
  for (int i=0; i<N-1; ++i) {
    printf("%c, ", out[i]);
  }
  printf("%c ]\n", out[N-1]);
  return 0;
}
