#include <iostream>
#include <vector>
#include <random>
#include <functional>
#include <stdexcept>

using std::cout;
using std::vector;


template<typename BaseData>
void print_vector(vector<BaseData>&);
template<typename BaseData>
void exchange(vector<BaseData>&, int, int);
long random(long, long);


template<typename BaseData>
int partition(vector<BaseData>& v, int left, int right) {
    int i = left - 1;
    for (int j = left; j != right; j += 1) {
        if (v[j] < v[right]) {
            i += 1;
            exchange(v, i, j);
        }
    }
    i += 1;
    exchange(v, i, right);
    return i;
}

template<typename BaseData>
int random_partition(vector<BaseData>& v, int left, int right) {
    int p = random(left, right + 1);
    exchange(v, p, right);
    return partition<BaseData>(v, left, right);
}


long random_select_b(int index,
        vector<long>& v, int left, int right) {

    std::function<long (int, int)> RS_help = [&](int l, int r) {
        if (l < r) {
            int p = random_partition(v, l, r);
            if (index < p) {
                RS_help(l, p - 1);
            } else if (index > p) {
                RS_help(p + 1, r);
            } else {
                return v[index];
            }
            //return v[index];  // damn clang++, why need this one?
        } else {
            return v[index];
        }
    };

    return RS_help(left, right);
}

long random_select(int index,
        vector<long>& v, int left, int right) {
    if (left < 0) {
        throw std::invalid_argument("left");
    } else if (right >= (int)v.size()) {
        throw std::length_error("right");
    } else if (left > index || index > right) {
        throw std::out_of_range("index");
    } else {
        return random_select_b(index, v, left, right);
    }
}


//--------------------------------------

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

long random(long min, long max) {
    std::random_device rd;
    std::mt19937_64 gen(rd());
    std::uniform_int_distribution<long> dis(min, max - 1);
    return dis(gen);
}

void set_vector(vector<long>& v, int size, long min, long max) {
    for (int i = 0; i < size; i = i+1) {
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
    vector<long> A;
    set_vector(A, 100, 0, 100);
    print_vector(A);
    cout << random_select(97, A, 0, 99) << "\n";
    quick_sort(A);
    print_vector(A);
    return 0;
}
