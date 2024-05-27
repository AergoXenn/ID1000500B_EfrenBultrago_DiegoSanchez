#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_ELEMENTS 64

void generate_random_sequence(int num_elements, const char *filename) {
    FILE *file = fopen(filename, "w");
    if (!file) {
        perror("Failed to open file");
        exit(EXIT_FAILURE);
    }

    srand(time(NULL));
    for (int i = 0; i < num_elements; ++i) {
        unsigned int random_number = rand();
        fprintf(file, "%08X\n", random_number);
    }

    fclose(file);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <num_elements> <output_file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int num_elements = atoi(argv[1]);
    if (num_elements < 1 || num_elements > MAX_ELEMENTS) {
        fprintf(stderr, "Number of elements must be between 1 and %d\n", MAX_ELEMENTS);
        return EXIT_FAILURE;
    }

    const char *filename = argv[2];
    generate_random_sequence(num_elements, filename);

    return EXIT_SUCCESS;
}