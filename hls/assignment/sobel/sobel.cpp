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

    esternoY:
    for (int y = 0; y < height - 2; y++)
    {
        esternoX:
        for (int x = 0; x < width - 2; x++)
        {
            int dx = 0;
            int dy = 0;

            internoY:
            for (int k = 0; k < 3; k++)
            {
                const int inYOffset = (y + k) * width;

                internoX:
                for (int z = 0; z < 3; z++)
                {
                    const int inXOffset = x + z;

                    const int inOffset = inYOffset + inXOffset;
                    const int inElement = in[inOffset];

                    dx += sobelFilter[k][z] * inElement;
                    dy += sobelFilter[z][k] * inElement;
                }
            }

            const int outYOffset = (y + 1) * width;
            const int outXOffset = (x + 1);
            const int outOffset = outYOffset + outXOffset;
            
            out[outOffset] = sqrt((float)((dx * dx) + (dy * dy)));
        }
    }
}
