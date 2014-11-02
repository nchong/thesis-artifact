void hostStencil(int *A, int *B, int radius, unsigned n) {
  // setup OpenCL platform and device
  cl_platform_id platform;
  cl_device_id device;
  clGetPlatformIDs(1, &platform, NULL);
  clGetDeviceIDs(platform, CL_DEVICE_TYPE_DEFAULT, 1, &device, NULL);
  cl_context context = clCreateContext(NULL, 1, &device, NULL, NULL, NULL);
  cl_command_queue queue = clCreateCommandQueue(context, device, 0, NULL);

  // fetch and compile kernel
  std::ifstream f("stencil.cl", std::ios::in);
  std::stringstream ss;
  ss << f.rdbuf();
  const std::string& str = ss.str();
  const char *s = str.c_str();
  cl_program program = clCreateProgramWithSource(context, 1, (const char **)&s, NULL, NULL);
  clBuildProgram(program, 1, &device, "", NULL, NULL);
  cl_kernel kernel = clCreateKernel(program, "stencil", NULL);

  // device copies of A and B
  cl_mem d_A; cl_mem d_B;

  // allocate arrays on device
  size_t sz = sizeof(int)*n;
  d_A = clCreateBuffer(context, CL_MEM_READ_ONLY, sz, NULL, NULL);
  d_B = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sz, NULL, NULL);

  // copy input to device
  clEnqueueWriteBuffer(queue, d_A, CL_TRUE, 0, sz, A, 0, NULL, NULL);

  // launch kernel
  clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&d_A);
  clSetKernelArg(kernel, 1, sizeof(cl_mem), (void *)&d_B);
  clSetKernelArg(kernel, 2, sizeof(int), (void *)&radius);
  clSetKernelArg(kernel, 3, sizeof(unsigned), (void *)&n);
  size_t global_work_size = n; size_t local_work_size = n;
  clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_work_size, &local_work_size, 0, NULL, NULL);
  clFinish(queue);

  // copy output from device
  clEnqueueReadBuffer(queue, d_B, CL_TRUE, 0, sz, B, 0, NULL, NULL);

  // free allocated arrays
  clReleaseMemObject(d_A);
  clReleaseMemObject(d_B);
}

