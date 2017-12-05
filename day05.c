#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define INPUT_MAXLEN 8192

int part1(int* arr, int length)
{
	int *input = malloc( length*(sizeof(int)) );
	memcpy(input, arr, length*sizeof(int));
	int steps = 0;
	int i = 0;
	while (i < length)
	{
		int jump = input[i]++;
		steps++;
		i += jump;
	}
	free(input);
	return steps;
}

int part2(int* arr, int length)
{
	int *input = malloc( length*(sizeof(int)) );
	memcpy(input, arr, length*sizeof(int));
	int steps = 0;
	int i = 0;
	while (i < length)
	{
		int jump = input[i];
		( jump >= 3 ) ? input[i]-- : input[i]++;
		steps++;
		i += jump;
	}
	free(input);
	return steps;
}

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
	int r = 0, line = 0;

	if ((fptr = fopen(path, "r")) == NULL)
	{
		fprintf(stderr, "ERROR! unable to open %s\n", path);
		exit(1);
	}

	int input[INPUT_MAXLEN];
	int temp = 0;

	r = fscanf(fptr, "%d\n", &temp);
	while (r != EOF)
	{
		if (r == 1)
		{
			input[line] = temp;
		}
		else
		{
			printf ("Error, line %d in wrong format!\n\n", line);
		}
		line++;
		r = fscanf(fptr, "%d\n", &temp);
	}
	fclose(fptr);

	int results[2];
	double durations[2];
	struct timespec start, end;

	clock_gettime(CLOCK_MONOTONIC, &start);
	results[0] = part1(input, line);
	clock_gettime(CLOCK_MONOTONIC, &end);
	durations[0] = (((end.tv_sec * 1000000000 + end.tv_nsec) - (start.tv_sec * 1000000000 + start.tv_nsec)));

	clock_gettime(CLOCK_MONOTONIC, &start);
	results[1] = part2(input, line);
	clock_gettime(CLOCK_MONOTONIC, &end);
	durations[1] = (((end.tv_sec * 1000000000 + end.tv_nsec) - (start.tv_sec * 1000000000 + start.tv_nsec)));

	const char* fmt_output = "%6s: %10s = %8d (took %.3fms)\n";
	printf(fmt_output, "part1", "steps", results[0], durations[0] / 1000000);
	printf(fmt_output, "part2", "steps", results[1], durations[1] / 1000000);

	return EXIT_SUCCESS;
}
