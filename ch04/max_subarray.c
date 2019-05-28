
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


struct SubArray findCrossingMax(int[], int, int, int);
struct SubArray findMax(int[], int, int);
void readStringData(const char*);


struct SubArray {
    int start;
    int end;
    int sum;
};

struct SubArray findCrossingMax(int v[], int left, int mid, int right)
{
    struct SubArray max;
    max.start = mid;
    max.end = mid + 1;
    int sum_left = v[mid];
    int sum_right = v[mid + 1];

    for (int i = mid, sum = 0; i >= left; --i) {
        sum = sum + v[i];
        if (sum > sum_left) {
            sum_left = sum;
            max.start = i;
        }
    }

    for (int j = mid+1, sum = 0; j <= right; ++j) {
        sum = sum + v[j];
        if (sum > sum_right) {
            sum_right = sum;
            max.end = j;
        }
    }

    max.sum = sum_left + sum_right;
    return max;
}


struct SubArray findMax(int v[], int left, int right)
{
    struct SubArray max_left, max_right, max_cross;

    if (left == right) {
        struct SubArray one = {left, right, v[left]};
        return one;
    } else {
        int mid = (left + right) / 2;
        max_left = findMax(v, left, mid);
        max_right = findMax(v, mid + 1, right);
        max_cross = findCrossingMax(v, left, mid, right);

        if (max_left.sum >= max_right.sum &&
                max_left.sum >= max_cross.sum) {
            return max_left;
        } else if (max_right.sum >= max_left.sum &&
                max_right.sum >= max_cross.sum) {
            return max_right;
        } else {
            return max_cross;
        }
    }
}


void readStringData(const char* filename)
{
    FILE* read_ptr;
    char word[12] = {0};
    int data[100] = {0};

    read_ptr = fopen(filename, "r");
    int c = 0;
    int len = 0;
    for (int i = 0; (c = fgetc(read_ptr)) != EOF;) {
        if (isspace(c) && word[0] != 0) {
            data[len] = atoi(word);
            memset(word, 0, sizeof(word));
            ++len;
            i = 0;
        } else if (!isspace(c)) {
            word[i] = c;
            ++i;
        }
    }
    fclose(read_ptr);
    if (word[0] != 0) {
        //data[len] = atoi(word);
        //++len;
    }

    struct SubArray max;
    max = findMax(data, 0, len - 1);
    printf("(%d, %d, %d)\n", max.start, max.end, max.sum);
}

int main()
{
    readStringData("test");
    return 0;
}
