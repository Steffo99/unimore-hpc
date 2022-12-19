#include <math.h>
#include "sobel.h"

void sobel(uint8_t *__restrict__ out, uint8_t *__restrict__ in, const int width, const int height)
{
#pragma HLS INTERFACE m_axi port=out offset=slave bundle=bout
#pragma HLS INTERFACE m_axi port=in offset=slave bundle=bin
#pragma HLS INTERFACE s_axilite port=width bundle=bwidth
#pragma HLS INTERFACE s_axilite port=height bundle=bheight

    const int sobelFilter[3][3] = {
        {-1, 0, 1}, 
        {-2, 0, 2}, 
        {-1, 0, 1}
    };

    for (int y = 1; y < height - 1; y++)
    {
        for (int x = 1; x < width - 1; x++)
        {
            int dx = 0;
            int dy = 0;

            for (int k = 0; k < 3; k++)
            {
                for (int z = 0; z < 3; z++)
                {
                    const int address = (y + k - 1) * width + x + z - 1;

                    dx += sobelFilter[k][z] * in[address];
                    dy += sobelFilter[z][k] * in[address];
                }
            }

            out[y * width + x] = sqrt((float)((dx * dx) + (dy * dy)));
        }
    }
}
