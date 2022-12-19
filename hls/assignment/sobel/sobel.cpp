#include <math.h>
#include "sobel.h"

void sobel(uint8_t *__restrict__ out, uint8_t *__restrict__ in, const int width, const int height)
{
#pragma HLS INTERFACE axis port=out bundle=boutput
#pragma HLS INTERFACE axis port=in bundle=binput
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
                    dx += sobelFilter[k][z] * in[(y + k - 1) * width + x + z - 1];
                    dy += sobelFilter[z][k] * in[(y + k - 1) * width + x + z - 1];
                }
            }

            out[y * width + x] = sqrt((float)((dx * dx) + (dy * dy)));
        }
    }
}
