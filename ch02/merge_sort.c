
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define RMIN    -0x800000
#define RMAX    0x7FFFFF

void makeRandomNumbers(const char[], int);
void lookRandomNumbers(const char[], long, long);
void sortRandomNumbers(void(*)(int[],int,int), const char[], const char[]);
int newRandom(int, int);
void mergeSort(int[], int, int);
void arrayCopy(int[], int, int[], int);


int main()
{
    makeRandomNumbers("test", 1024 * 1024);
    sortRandomNumbers(mergeSort, "test", "out-test");
    lookRandomNumbers("out-test", 512 * 1024, 512 * 1024);
    // tabe about 3.5 seconds
    return 0;
}

void makeRandomNumbers(const char *filename, int n)
{
    FILE *write_ptr;
    int buffer = 0;

    write_ptr = fopen(filename, "wa");
    do {
        buffer = newRandom(RMIN, RMAX);
        fwrite(&buffer, sizeof(buffer), 1, write_ptr);
    } while (--n);
    fclose(write_ptr);
}

void lookRandomNumbers(const char *filename, long pos, long n)
{
    FILE *read_ptr;
    int buffer = 0;

    read_ptr = fopen(filename, "r");
    fseek(read_ptr, pos * 4, SEEK_SET);
    while (1 == fread(&buffer, sizeof(buffer), 1, read_ptr)) {
        printf("%d\n", buffer);
        --n;
        if (n == 0)
            break;
    }
    fclose(read_ptr);
}

int newRandom(int min, int max)
{
    // random value on [0 RAND_MAX]
    // RAND_MAX: 2147483647 (2^31 - 1)

    static time_t e = 0;

    unsigned range = max - min + 1;
    if (range > RAND_MAX) {
        fprintf(stderr, "random range over %d in %s\n",
                RAND_MAX, __func__);
        return 0;
    }

    srand(time(NULL) + e++);
    return rand() % range + min;
}

void mergeSort(int v[], int left, int right)
{
    if (left < right) {
        int mid = (left + right) / 2;
        mergeSort(v, left, mid);
        mergeSort(v, mid + 1, right);

        int lenLa = mid - left + 1;
        int lenRa = right - mid;
        int *La = (int*)malloc(sizeof(int) * lenLa);
        int *Ra = (int*)malloc(sizeof(int) * lenRa);

        arrayCopy(v, left, La, lenLa);
        arrayCopy(v, mid + 1, Ra, lenRa);

        int i = 0;
        int j = 0;
        int k = left;
        for (; k <= right; ++k) {
            if (i == lenLa) {
                v[k] = Ra[j];
                ++j;
            } else if (j == lenRa) {
                v[k] = La[i];
                ++i;
            } else {
                if (La[i] < Ra[j]) {
                    v[k] = La[i];
                    ++i;
                } else {
                    v[k] = Ra[j];
                    ++j;
                }
            }
        }

        free(La);
        free(Ra);
    }
}

void arrayCopy(int v1[], int start, int v2[], int n)
{
    // no bound check
    for (int i = 0; n != 0; ++i, ++start, --n) {
        v2[i] = v1[start];
    }
}

void sortRandomNumbers(void (*sort)(int[],int,int),
        const char *input, const char *output)
{
    FILE *write_ptr;
    FILE *read_ptr;
    int buffer = 0;

    // read random numbers
    read_ptr = fopen(input, "r");
    fseek(read_ptr, 0L, SEEK_END);
    long SIZE = ftell(read_ptr);
    fseek(read_ptr, 0L, SEEK_SET);

    int *v = (int*)malloc(SIZE);
    int i = 0;
    while (1 == fread(&buffer, sizeof(int), 1, read_ptr)) {
        v[i] = buffer;
        ++i;
    }
    fclose(read_ptr);

    // sort random numbers
    (*sort)(v, 0, SIZE / 4 - 1);

    // write random numbers

    write_ptr = fopen(output, "wa");
    for (i = 0; i < SIZE / 4; ++i) {
        fwrite(v + i, sizeof(int), 1, write_ptr);
    }
    fclose(write_ptr);

    free(v);
}
