
#include <iostream>
#include <vector>
#include <random>

using std::cout;
using std::vector; using std::string;

int power(int n, int times) {
    if (times == 0) {
        return 1;
    }
    return n * power(n, times - 1);
}

int extract_b(int n, int digit) {
    int p1 = power(10, digit);
    int p2 = power(10, digit - 1);
    return ((n % p1) - (n % p2)) / p2;
}

int extract(int n, int digit) {
    if (n < 0) {
        cout << "extract: n must be a positive integer\n";
        return -1;
    } else if (digit < 1) {
        cout << "extract: digit at least 1\n";
        return -1;
    } else {
        return extract_b(n, digit);
    }
}

void radix_sort(vector<int>& in, int d) {

    vector<int> out;
    for (int i = 0; i != (int)in.size(); i += 1) {
        out.push_back(0);
    }

    auto counting_stable = [&] (int d) {
        vector<int> record;
        for (int i = 0; i != 10; i += 1) {
            record.push_back(0);
        }

        for (int i = 0; i != (int)in.size(); i += 1) {
            int n = extract(in[i], d);
            record[n] += 1;
        }

        for (int i = 1; i != (int)record.size(); i += 1) {
            record[i] = record[i] + record[i - 1];
        }

        for (int i = (int)in.size() - 1; i >= 0; i -= 1) {
            int n = extract(in[i], d);
            int index = record[n] - 1;
            out[index] = in[i];
            record[n] = index;
        }

        in = out;
    };

    for (int i = 1; i <= d; i += 1) {
        counting_stable(i);
    }
}

//--------------------------------------

int random(int min, int max) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> dis(min, max - 1);

    return dis(gen);
}

void set_vector(vector<int>& v, int size, int min, int max) {
    for (int i = 0; i < size; i = i+1) {
        v.push_back(random(min, max));
    }
}

void print_vector(vector<int>& v) {
    cout << "(vector #";
    cout << v.size() << " [";
    for (int i = 0; i < (int)v.size(); i = i+1) {
        cout << v[i] << " ";
    }
    cout << "])\n";
}

int main() {
    int count = 100;
    int n_min = 10000;
    int n_max = 1000000;
    int digits = 6;

    vector<int> A = vector<int>();
    set_vector(A, count, n_min, n_max);
    print_vector(A);
    radix_sort(A, digits);
    print_vector(A);
    return 0;
}
