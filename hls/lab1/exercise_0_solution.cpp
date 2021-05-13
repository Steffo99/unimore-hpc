#include "exercise_0.hpp"

const unsigned int c_dim = TEST_DATA_SIZE;

void vadd(int *a, int *b, int *c, const int len)
{
    #pragma HLS INTERFACE m_axi port=a offset=slave depth=c_dim bundle=mem
    #pragma HLS INTERFACE m_axi port=b offset=slave depth=c_dim bundle=mem
    #pragma HLS INTERFACE m_axi port=c offset=slave depth=c_dim bundle=mem
    #pragma HLS INTERFACE s_axilite port=len bundle=params
    #pragma HLS INTERFACE s_axilite port=return bundle=params

    loop: for(int i = 0; i < len; i++) {
	    #pragma HLS LOOP_TRIPCOUNT min=c_dim max=c_dim
        c[i] = a[i] + b[i];
    }
}
