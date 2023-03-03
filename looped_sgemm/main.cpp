#include <cstdlib>
#include <ctime>
#include <curand.h>
#include <cublas_v2.h>
#include <cstdio>
#include <cmath>

void fill_vector_with_uniform_random_floats(float *v, int dim);

int main() {
  float memory_usage_in_GB = 1.5;
  float minutes_to_run = 0.5;

  int dim = floor(sqrt(1000000000*memory_usage_in_GB/12));

  float *d_A, *d_B, *d_C;
  cudaMalloc(&d_A, dim*dim*sizeof(float));
  cudaMalloc(&d_B, dim*dim*sizeof(float));
  cudaMalloc(&d_C, dim*dim*sizeof(float));

  fill_vector_with_uniform_random_floats(d_A, dim*dim);
  fill_vector_with_uniform_random_floats(d_B, dim*dim);

  cublasHandle_t handle;
  cublasCreate(&handle);
  float alpha = 1, beta = 0;
  clock_t start = clock();

  while ( ((float)(clock() - start))/CLOCKS_PER_SEC/60 < minutes_to_run) {
    cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, dim, dim, dim, &alpha, d_A, dim, d_B, dim, &beta, d_C, dim);
    cudaDeviceSynchronize();
    printf ("Elapsed (minutes): %f\n", ((float)(clock() - start))/CLOCKS_PER_SEC/60);
  }
  cublasDestroy(handle);

  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);

  return 0;
}

void fill_vector_with_uniform_random_floats(float *v, int dim) {
  curandGenerator_t prng;
  curandCreateGenerator(&prng, CURAND_RNG_PSEUDO_DEFAULT);
  curandSetPseudoRandomGeneratorSeed(prng, (unsigned long long) clock());

  curandGenerateUniform(prng, v, dim);
}
