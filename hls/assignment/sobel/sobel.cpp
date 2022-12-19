#include <cstring>
#include <math.h>
#include "sobel.h"

#define WIDTH 512
#define HEIGHT 512

void sobel(uint8_t *__restrict__ out, uint8_t *__restrict__ in)
{
#pragma HLS INTERFACE m_axi port=out offset=slave bundle=bout
#pragma HLS INTERFACE m_axi port=in offset=slave bundle=bin

    const int sobelFilter[3][3] = {
        {-1, 0, 1}, 
        {-2, 0, 2}, 
        {-1, 0, 1}
    };

    // Carica le prime tre righe nel buffer
    uint8_t inBuffer[3*WIDTH];
    memcpy(inBuffer, in, 3*WIDTH*sizeof(uint8_t));

    esternoY:
    for (int y = 0; y < HEIGHT - 2; y++)
    {

        esternoX:
        for (int x = 0; x < WIDTH - 2; x++)
        {
        #pragma HLS PIPELINE

            int dx = 0;
            int dy = 0;

            internoY:
            for (int k = 0; k < 3; k++)
            {
            #pragma HLS UNROLL

                const int inYOffset = (y + k) * WIDTH;

                internoX:
                for (int z = 0; z < 3; z++)
                {
                #pragma HLS UNROLL

                    const int inXOffset = (x + z) % 3;

                    const int inOffset = inYOffset + inXOffset;
                    const int inElement = inBuffer[inOffset];

                    dx += sobelFilter[k][z] * inElement;
                    dy += sobelFilter[z][k] * inElement;
                }
            }

            const int outYOffset = (y + 1) * WIDTH;
            const int outXOffset = (x + 1);
            const int outOffset = outYOffset + outXOffset;

            out[outOffset] = sqrt((float)((dx * dx) + (dy * dy)));
        }

        memcpy(inBuffer, in + y * WIDTH, WIDTH*sizeof(uint8_t));
    }
}
