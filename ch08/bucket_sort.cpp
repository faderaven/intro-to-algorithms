
#include <iostream>
#include <vector>
#include <random>
#include <functional>

using std::cout;
using std::vector;

template<typename BaseData>
void exchange(vector<BaseData>& v, int i, int j) {
    BaseData temp = v[i];
    v[i] = v[j];
    v[j] = temp;
}

template<typename BaseData>
void quick_sort(vector<BaseData>& v) {
    auto partition = [&](int l, int r) {
        int k = l - 1;
        for (int i = l; i != r; i += 1) {
            if (v[i] < v[r]) {
                k += 1;
                exchange(v, i, k);
            }
        }
        k += 1;
        exchange(v, k, r);
        return k;
    };

    std::function<void (int, int)> quick_sort_asc = [&](int l, int r) {
        if (l < r) {
            int q = partition(l, r);
            quick_sort_asc(l, q - 1);
            quick_sort_asc(q + 1, r);
        }
    };

    quick_sort_asc(0, v.size() - 1);
}

void bucket_sort(vector<double>& v) {
    int n = v.size();
    vector<double> bucket[n];

    for (int i = 0; i != n; i += 1) {
        int index = n * v[i];
        bucket[index].push_back(v[i]);
    }

    for (int i = 0; i != n; i += 1) {
        quick_sort(bucket[i]);
    }

    int k = 0;
    for (int i = 0; i != n; i += 1) {
        int size = (int)bucket[i].size();
        for (int j = 0; j != size; j += 1) {
            v[k] = bucket[i][j];
            k += 1;
        }
    }
}

//--------------------------------------

long random(long min, long max) {
    std::random_device rd;
    std::mt19937_64 gen(rd());
    std::uniform_int_distribution<long> dis(min, max - 1);
    return dis(gen);
}

double random(double min, double max) {
    std::random_device rd;
    std::mt19937_64 gen(rd());
    std::uniform_real_distribution<double> dis(min, max);
    return dis(gen);
}

void set_vector(vector<long>& v, int size, long min, long max) {
    for (int i = 0; i < size; i = i+1) {
        v.push_back(random(min, max));
    }
}

void set_vector(vector<double>& v, int size, double min, double max) {
    for (int i = 0; i < size; i += 1) {
        v.push_back(random(min, max));
    }
}

template<typename BaseData>
void print_vector(vector<BaseData>& v) {
    cout << "(vector #";
    cout << v.size() << " [";
    for (int i = 0; i < (int)v.size(); i = i+1) {
        cout << v[i] << " ";
    }
    cout << "])\n";
}

int main() {
    vector<double> A;
    set_vector(A, 113, 0, 1);
    print_vector(A);
    bucket_sort(A);
    print_vector(A);
    return 0;
}
