#include <stdio.h>
#include <stdlib.h>

#include "exercise_0.hpp"

int main(int argc, char ** argv) {

	int * a = (int *)malloc(TEST_DATA_SIZE*sizeof(int));
	int * b = (int *)malloc(TEST_DATA_SIZE*sizeof(int));
	int * c = (int *)malloc(TEST_DATA_SIZE*sizeof(int));

	for(int i = 0; i < TEST_DATA_SIZE; i++) {
		a[i] = i*i;
		b[i] = i;
	}

	vadd(a, b, c, TEST_DATA_SIZE);

	for(int i = 0; i < TEST_DATA_SIZE; i++) {
		printf("%d\n", c[i]);
	}

	free(a);
	free(b);
	free(c);

	return 0;
}
