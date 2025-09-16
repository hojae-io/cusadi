// AUTOMATICALLY GENERATED CODE FOR CUSADI

#include <cuda_runtime.h>
#include <math.h>
#include <iostream>

__constant__ int nnz_in[] = {25};
__constant__ int nnz_out[] = {3};
__constant__ int n_w = 1;

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true) {
if (code != cudaSuccess) {
    fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
    if (abort) exit(code);
}
}


__global__ void evaluate_kernel (
        const float *inputs[],
        float *work,
        float *outputs[],
        const int batch_size) {

    float work_env[1];
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int env_idx = idx * n_w;
    if (idx < batch_size) {
        work[env_idx + 0] = inputs[0][idx * nnz_in[0] + 0];
        outputs[0][idx * nnz_out[0] + 0] = work[env_idx + 0];
        work[env_idx + 0] = inputs[0][idx * nnz_in[0] + 1];
        outputs[0][idx * nnz_out[0] + 1] = work[env_idx + 0];
        work[env_idx + 0] = inputs[0][idx * nnz_in[0] + 2];
        outputs[0][idx * nnz_out[0] + 2] = work[env_idx + 0];
    }
}


extern "C" {

void evaluate(const float *inputs[],
            float *work,
            float *outputs[],
            const int batch_size) {
    int blockSize = 256;
    int gridSize = (batch_size + blockSize - 1) / blockSize;
    evaluate_kernel<<<gridSize, blockSize>>>(inputs,
                                            work,
                                            outputs,
                                            batch_size);

    gpuErrchk(cudaPeekAtLastError());
    gpuErrchk(cudaDeviceSynchronize());
}

}