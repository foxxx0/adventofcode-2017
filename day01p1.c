#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define INPUT_MAXLEN 1034248

int main(int argc, char **argv)
{
	if (argc != 2)
	{
		fprintf(stderr, "ERROR: missing argument\n");
		fprintf(stderr, "usage: %s <file>\n", argv[0]);
		exit(1);
	}

	char* path = argv[1];
	FILE *fptr;

	if ((fptr = fopen(path, "r")) == NULL)
	{
		fprintf(stderr, "ERROR! unable to open %s\n", path);
		exit(1);
	}

	char input[INPUT_MAXLEN];
	struct timespec start, end;

	if (fgets(input, INPUT_MAXLEN, fptr) == input)
	{
		fclose(fptr);
		size_t len = strcspn(input, "\n");

		int sum = 0;
		size_t i;
		clock_gettime(CLOCK_MONOTONIC, &start);
		for( i=0; i < len; i++ )
		{
			/* printf("i: %zu\n", i); */
			if ( i == len - 1 )
			{
				if (input[i] == input[0]) sum += (input[i] - 48);
			}
			else
			{
				if (input[i] == input[i + 1]) sum += (input[i] - 48);
			}
		}
		clock_gettime(CLOCK_MONOTONIC, &end);

		double duration = (((end.tv_sec * 1000000000 + end.tv_nsec) - (start.tv_sec * 1000000000 + start.tv_nsec)));

		printf("sum = %d (took %.3fms)\n", sum, duration / 1000000);
	}
	else
	{
		fprintf(stderr, "ERROR! read error\n");
		fclose(fptr);
		exit(2);
	}

	return EXIT_SUCCESS;
}
